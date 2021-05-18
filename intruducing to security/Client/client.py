import socket
import tqdm
import os
from cryptography.fernet import Fernet
import hashlib
import base64
import random
import time

host="127.0.0.1"
port=6000;
fileName="file.pdf"
key =random.getrandbits(128)#session key random
n=0x8c4f90913d030056be3264e3667c9a5bd1f99660c83d38fde99bbe8db5b321c205e0d81974f5d1bf77ecf68ea745a58dadd88c9956c2e7338561ac5517469613194a7fa0c1da504d0c129734b11eaeb53d2dff861b40f3ef628492a52323c4edc585ca3b942ba30f2c3fed6cf314a345d46f2b169ff3785e02f6aa8603442cfd
server_pub=0x10001
print(key)
send_key=pow(key,server_pub,n)
__Sessionkey__ = base64.urlsafe_b64encode( hashlib.sha256(str(key).encode()).digest())

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
    print(received)
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


s=socket.socket()
s.connect((host,port))
#Exchenge_key(s)
s.sendall(str(send_key).encode('utf-8'))

sleep_time=2;
login=0;

while 1:
    commandString=input()
    command=commandString.split(" ")
    operation=command[0]
    #print(len(command))

    if operation=="register":
        if(len(command)!=5):
            print("invalid command")
        else:
            #print("register")
            # cm=encrypt(commandString,__Sessionkey__)
            # print(cm)
            # print(decrypt(cm,__Sessionkey__))
            s.sendall(encrypt(commandString,__Sessionkey__))
            message=s.recv(1024)
            if decrypt(message,__Sessionkey__)=="ACK":
                print("Register was Successeful")
            elif decrypt(message,__Sessionkey__)[0]=='y':
                print(decrypt(message,__Sessionkey__))
            else:
                print("UserName repeated or invalid BLP_Levels or invalid Biba_Levels")



    elif operation=="login":
        if(len(command)!=3):
            print("invalid command")
        else:
            #print("login")
            s.sendall(encrypt(commandString,__Sessionkey__))
            message=s.recv(1024)
            if decrypt(message,__Sessionkey__)=="ACK":
                print("Login was Successeful")
                login=1;
                sleep_time=2;
            else:
                print("Wrong UserName or Password : try again after ",sleep_time," seconds")
                time.sleep(sleep_time)
                sleep_time=sleep_time*2
                print("you can try again.")



    elif operation=="put":
        if login==0:
            print("Login First")
        else:
            if len(command)!=4:
                print("invalid command")
            elif'/' in command[1]:
                print("enter file name not address")
            else:
                #print("put")
                s.sendall(encrypt(commandString,__Sessionkey__))
                message=s.recv(1024)

                if decrypt(message,__Sessionkey__)=="ACK" :
                    fileName=command[1]
                    encrypt_file(fileName,__Sessionkey__)
                    SendFile(s,fileName+".enc")
                    os.remove(fileName+".enc")
                    print("Upload was Successeful")

                else :
                    print("file name repeated or invalid BLP_Levels or invalid Biba_Levels")






    elif operation=="list":
        if login==0:
            print("Login First")
        else:
            if len(command)!=1:
                print("invalid command")
            else:
                #print("list")
                s.sendall(encrypt(commandString,__Sessionkey__))
                message=s.recv(1024)
                print("list of files :")
                list=(decrypt(message,__Sessionkey__)).split("\n")
                for i in list:
                    print(i)



    elif operation=="read":
        if login==0:
            print("Login First")
        else:
            if len(command)!=2 :
                print("invalid command")

            else:
                #print("read")
                s.sendall(encrypt(commandString,__Sessionkey__))
                message=s.recv(1024)
                #print(decrypt(message,__Sessionkey__))
                if decrypt(message,__Sessionkey__)=="ACK" :
                    message2=s.recv(1024)
                    #print("before")
                    print(decrypt(message2,__Sessionkey__))
                    #print("after")
                elif decrypt(message,__Sessionkey__)=="NACK1" :
                    print("No Such File or no valid permission")


    elif operation=="write":
        if login==0:
            print("Login First")
        else:
            if len(command)!=3 :
                print("invalid command")

            else:
                #print("write")
                s.sendall(encrypt(commandString,__Sessionkey__))
                message=s.recv(1024)
                #print(decrypt(message,__Sessionkey__))
                if decrypt(message,__Sessionkey__)=="ACK" :
                    print("Write was Successeful")
                elif decrypt(message,__Sessionkey__)=="NACK1" :
                    print("No Such File or invalid permission")


    elif operation=="get":
        if login==0:
            print("Login First")
        else:
            if len(command)!=2:
                print("invalid command")
            else:
                print("get")
                s.sendall(encrypt(commandString,__Sessionkey__))
                message=s.recv(1024)
                if decrypt(message,__Sessionkey__)=="ACK" :
                    filename=ReceiveFile(s)
                    decrypt_file(filename,__Sessionkey__)
                    os.remove(filename)
                    os.rename(filename+".dec",command[1])
                else :print("No Such File or You Are Not Owner")


    else:
        print("invalid command")

#encrypt_file(fileName,__Sessionkey__)
#fileName=fileName+".enc"

#SendFile(s,fileName)

s.close()
