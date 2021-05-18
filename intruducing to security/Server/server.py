import socket
import tqdm #for sending file
import os
from cryptography.fernet import Fernet
from password_strength import PasswordPolicy
import hashlib
import base64
import secrets
from datetime import datetime



SERVER_HOST = "127.0.0.1"
SERVER_PORT = 6000
policy = PasswordPolicy.from_names(
    length=8,
    uppercase=2,
    numbers=2,
    special=2,
    nonletters=2,
)
connected_name=""
req_res=""
n=0x8c4f90913d030056be3264e3667c9a5bd1f99660c83d38fde99bbe8db5b321c205e0d81974f5d1bf77ecf68ea745a58dadd88c9956c2e7338561ac5517469613194a7fa0c1da504d0c129734b11eaeb53d2dff861b40f3ef628492a52323c4edc585ca3b942ba30f2c3fed6cf314a345d46f2b169ff3785e02f6aa8603442cfd

server_pr=0x55790695233897d53fa9cd41a5a61416093464c1f2593145a43067054681a7f7dcc2da81af792bdbda7f74b6f3f8fe5fef5e32501ac542386571599cc040149d01ec338046aedf330a7728592e10e01cb6a300fb4d37a10706003b9aefa89c35edd6b688ab4d2924d85943b07be0effc55ddbd30ed4cbc3196c846ed7fe2d681
#just for first test befor key exchange
#key=248144999179718380399380278775224181965
#__Sessionkey__ = base64.urlsafe_b64encode( hashlib.sha256(str(key).encode()).digest())
#*************************************************************
def logTime():
    now = datetime.now()
    return now.strftime("%H:%M:%S")

def blp(level):
    if level=="topsecret":
        return 4
    elif level=="secret":
        return 3
    elif level=="confidential":
        return 2
    elif level=="unclassified":
        return 1
    else :
        print("invalid BLP_Levels")
        return 0


def biba(level):
    if level=="verytrusted":
        return 4
    elif level=="trusted":
        return 3
    elif level=="slightlytrusted":
        return 2
    elif level=="untrusted":
        return 1
    else :
        print("invalid Biba_Levels")
        return 0


def read_blp(file,user):# 2 ta adad midim
    if user >= file:
        return 1
    else:
        return 0

def read_biba(file,user):# 2 ta adad midim
    if user <= file:
        return 1
    else:
        return 0

def write_blp(file,user):# 2 ta adad midim
    if user <= file:
        return 1
    else:
        return 0

def write_biba(file,user):# 2 ta adad midim
    if user >= file:
        return 1
    else:
        return 0

#*************************************************************
def encrypt_file(filename,key):
    f=Fernet(key)
    with open(filename,"rb")as file:
        file_data=file.read()
    encrypted_data=f.encrypt(file_data)
    with open(filename+".enc","wb")as file:
        file.write(encrypted_data)

def decrypt_file(filename,key):
    f=Fernet(key)
    with open(filename,"rb") as file:
        encrypted_data=file.read();
    decrypted_data=f.decrypt(encrypted_data)
    with open(filename+".dec","wb") as file:
        file.write(decrypted_data)
#*************************************************************
def encrypt(message, key):
    f=Fernet(key)
    return f.encrypt(message.encode())
def decrypt(message, key):
    f=Fernet(key)
    return (f.decrypt(message)).decode()
#*************************************************************
def SendFile(s,fileName):
    separator="<SEPARATOR>"
    BUFFER_SIZE=4096
    fileSize=os.path.getsize(fileName)
    s.send(encrypt(f"{fileName}{separator}{fileSize}",__Sessionkey__))
    size=0;
    progress = tqdm.tqdm(range(fileSize), f"Sending {fileName}", unit="B", unit_scale=True, unit_divisor=1024)
    with open(fileName, "rb") as f:
        while size<fileSize:
            # read the bytes from the file
            size=size+BUFFER_SIZE
            bytes_read = f.read(BUFFER_SIZE)
            if not bytes_read:
                # file transmitting is done
                break
            # we use sendall to assure transimission in
            # busy networks
            s.sendall(bytes_read)
            # update the progress bar
            progress.update(len(bytes_read))
    print("send")

def ReceiveFile(s):
    BUFFER_SIZE=4096
    SEPARATOR="<SEPARATOR>"
    received = decrypt(s.recv(BUFFER_SIZE),__Sessionkey__)
    filename, filesize = received.split(SEPARATOR)
    # remove absolute path if there is
    filename = os.path.basename(filename)
    print("receiving "+filename)

    # convert to integer
    filesize = int(filesize)
    size=0
    progress = tqdm.tqdm(range(filesize), f"Receiving {filename}", unit="B", unit_scale=True, unit_divisor=1024)
    with open(filename, "wb") as f:
        while size<filesize:
            # read 1024 bytes from the socket (receive)
            size=size+BUFFER_SIZE
            bytes_read = s.recv(BUFFER_SIZE)
            if not bytes_read:
                # nothing is received
                # file transmitting is done
                break
            # write to the file the bytes we just received
            f.write(bytes_read)
            # update the progress bar
            progress.update(len(bytes_read))
    print("received")
    return filename;
#*************************************************************

BUFFER_SIZE = 4096
SEPARATOR = "<SEPARATOR>"

#create log.txt if not exist
f=open("log.txt","w")
f.close()


objects=[]
users=[]

s = socket.socket()

s.bind((SERVER_HOST, SERVER_PORT))

s.listen(5)
print("listening")



client_socket, address = s.accept()
print("connected by : ",address)
key=pow(int(client_socket.recv(BUFFER_SIZE).decode('utf-8')),server_pr,n)
__Sessionkey__ = base64.urlsafe_b64encode( hashlib.sha256(str(key).encode()).digest())

print(key)

while 1:
    command = (decrypt(client_socket.recv(BUFFER_SIZE),__Sessionkey__)).split(" ")
    #print(command)
    if command[0]=="register":
        message=""
        user_names=[x[0] for x in users]
        if command[1] not in user_names:
            salt=secrets.token_hex(8)
            if  policy.test(command[2]):
                message=("your password needs : \n" + str(policy.test(command[2])))
                req_res="N"
            else :
                password=hashlib.sha256((command[2]+salt).encode()).digest()
                conf_level=blp(command[3])
                integ_level=biba(command[4])
                print(conf_level,integ_level)
                if (conf_level!=0 and integ_level!=0):
                    users.append([command[1],password,salt,conf_level,integ_level])
                    message="ACK"
                    req_res="Y"
                else:
                    message="NACK"
                    req_res="N"

        else:
            message="NACK"
            req_res="N"

        f=open("log.txt","a+")
        f.write("registerReq "+logTime()+" "+command[1]+" "+str(blp(command[3]))+" "+str(biba(command[4]))+" "+req_res+"\n")
        f.close()
        client_socket.sendall(encrypt(message,__Sessionkey__))


    elif command[0]=="login":
        message=""
        user_names=[x[0] for x in users]
        passes=[x[1] for x in users]
        salts=[x[2] for x in users]
        if command[1] in user_names:
            temp_pass=passes[user_names.index(command[1])]
            temp_salt=salts[user_names.index(command[1])]
            test_pass=hashlib.sha256((command[2]+temp_salt).encode()).digest()
            if test_pass==temp_pass:
                message="ACK"
                connected_name=command[1]
                req_res="Y"
            else:
                message="NACK"
                req_res="N"
        else:
            message="NACK"
            req_res="N"

        client_socket.sendall(encrypt(message,__Sessionkey__))
        f=open("log.txt","a+")
        f.write("loginReq "+logTime()+" "+command[1]+" "+req_res+"\n")
        f.close()
    elif command[0]=="put":
        message=""
        conf_level=blp(command[2])
        integ_level=biba(command[3])
        print(conf_level,integ_level)

        files=[x[0] for x in objects]
        if command[1] not in files and conf_level!=0 and integ_level!=0:
            message="ACK"
            client_socket.sendall(encrypt(message,__Sessionkey__))
            filename=ReceiveFile(client_socket)
            decrypt_file(filename,__Sessionkey__)
            os.remove(filename)
            os.rename(filename+".dec",command[1])
            objects.append([command[1],connected_name,conf_level,integ_level])
            f=open("log.txt","a+")
            f.write("PutReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(conf_level)+" "+str(integ_level)+" Y\n")
            f.close()

        else:
            message="NACK"
            client_socket.sendall(encrypt(message,__Sessionkey__))
            f=open("log.txt","a+")
            f.write("PutReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(blp(command[2]))+" "+str(biba(command[3]))+" N\n")
            f.close()


    elif command[0]=="list":
        message=""
        for object in objects:
            message=message+object[0]+" "+object[1]+" "+str(object[2])+" "+str(object[3])+"\n"
        #print(objects)
        client_socket.sendall(encrypt(message,__Sessionkey__))
        f=open("log.txt","a+")
        f.write("ListReq "+logTime()+" "+connected_name+" Y\n")
        f.close()



    elif command[0]=="read":
        message=""
        files=[x[0] for x in objects]#list file
        files_conf_levels=[x[2] for x in objects]#file conf level
        files_integ_levels=[x[3] for x in objects]#file integ level

        users_conf_levels=[x[3] for x in users]#users conf L
        users_integ_levels=[x[4] for x in users]#users integ L
        users2=[x[0] for x in users]#user names totally


        if command[1]  in files:
            user_conf_level= users_conf_levels[users2.index(connected_name)]
            user_integ_level= users_integ_levels[users2.index(connected_name)]

            file_conf_level= files_conf_levels[files.index(command[1])]
            file_integ_level= files_integ_levels[files.index(command[1])]

            print("file: ")
            print(file_conf_level,file_integ_level)
            print("user: ")
            print(user_conf_level,user_integ_level)
            if (read_blp(file_conf_level,user_conf_level) and read_biba(file_integ_level,user_integ_level)):
                message="ACK"
                client_socket.sendall(encrypt(message,__Sessionkey__))

                f=open(command[1],"r")
                client_socket.sendall(encrypt(f.read(),__Sessionkey__))
                f.close()
                l=open("log.txt","a+")
                l.write("readReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(user_conf_level)+" "+str(user_integ_level)+" "+str(file_conf_level)+" "+str(file_integ_level)+" Y\n")
                l.close()
            else:
                message="NACK1"
                client_socket.sendall(encrypt(message,__Sessionkey__))
                l=open("log.txt","a+")
                l.write("readReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(user_conf_level)+" "+str(user_integ_level)+" "+str(file_conf_level)+" "+str(file_integ_level)+" N\n")
                l.close()
        else:
            message="NACK1"
            client_socket.sendall(encrypt(message,__Sessionkey__))
            l=open("log.txt","a+")
            l.write("readReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(users_conf_levels[users2.index(connected_name)])+" "+str(users_integ_levels[users2.index(connected_name)])+" N\n")
            l.close()

    elif command[0]=="write":
        message=""
        files=[x[0] for x in objects]#list file
        files_conf_levels=[x[2] for x in objects]#file conf level
        files_integ_levels=[x[3] for x in objects]#file integ level

        users_conf_levels=[x[3] for x in users]#users conf L
        users_integ_levels=[x[4] for x in users]#users integ L
        users2=[x[0] for x in users]#user names totally

        if command[1]  in files:
            user_conf_level= users_conf_levels[users2.index(connected_name)]
            user_integ_level= users_integ_levels[users2.index(connected_name)]

            file_conf_level= files_conf_levels[files.index(command[1])]
            file_integ_level= files_integ_levels[files.index(command[1])]

            print("file: ")
            print(file_conf_level,file_integ_level)
            print("user: ")
            print(user_conf_level,user_integ_level)


            if (write_blp(file_conf_level,user_conf_level) and write_biba(file_integ_level,user_integ_level)):
                f=open(command[1],"w")
                f.write(command[2])
                f.close()
                message="ACK"
                client_socket.sendall(encrypt(message,__Sessionkey__))
                l=open("log.txt","a+")
                l.write("writeReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(user_conf_level)+" "+str(user_integ_level)+" "+str(file_conf_level)+" "+str(file_integ_level)+" Y\n")
                l.close()
            else :
                message="NACK1"
                client_socket.sendall(encrypt(message,__Sessionkey__))
                l=open("log.txt","a+")
                l.write("writeReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(user_conf_level)+" "+str(user_integ_level)+" "+str(file_conf_level)+" "+str(file_integ_level)+" N\n")
                l.close()
        else:
            message="NACK1"
            client_socket.sendall(encrypt(message,__Sessionkey__))
            l=open("log.txt","a+")
            l.write("writeReq "+logTime()+" "+connected_name+" "+command[1]+" "+str(users_conf_levels[users2.index(connected_name)])+" "+str(users_integ_levels[users2.index(connected_name)])+" N\n")
            l.close()



    elif command[0]=="get":
        message=""
        files=[x[0] for x in objects]
        owners=[x[1] for x in objects]

        if command[1]  in files and owners[files.index(command[1])]==connected_name:
            message="ACK"
            client_socket.sendall(encrypt(message,__Sessionkey__))
            encrypt_file(command[1],__Sessionkey__)
            fileName=command[1]
            SendFile(client_socket,fileName+".enc")
            os.remove(fileName+".enc")
            os.remove(fileName)
            del objects[files.index(command[1])]
            l=open("log.txt","a+")
            l.write("getReq "+logTime()+" "+connected_name+" "+command[1]+" Y\n")
            l.close()
            #print (users)
        else:
            message="NACK"
            client_socket.sendall(encrypt(message,__Sessionkey__))
            l=open("log.txt","a+")
            l.write("getReq "+logTime()+" "+connected_name+" "+command[1]+" N\n")
            l.close()







#get file :

#close client socket:
client_socket.close()
# close the server socket
s.close()
