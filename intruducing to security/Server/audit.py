import socket
import tqdm #for sending file
import os
from cryptography.fernet import Fernet
from password_strength import PasswordPolicy
import hashlib
import base64
import secrets
from datetime import datetime


def logTime():
    now = datetime.now()
    return now.strftime("%H:%M:%S")


file1 = open('log.txt', 'r')
lines = file1.readlines()

users=[]
tries=[]
count=0
for x in lines:
    lines_token=x.split(" ")
    count+=1

    if lines_token[0]=="registerReq" :
        if lines_token[5]=="Y\n" :
            users.append(lines_token[2])
            tries.append(0)

    elif lines_token[0]=="loginReq" :
        if lines_token[2] in users :
            if lines_token[3]=="Y\n" :
                tries[users.index(lines_token[2])]=0
            else :
                tries[users.index(lines_token[2])]+=1
                if tries[users.index(lines_token[2])]>=10:
                    print("LINE"+str(count))
                    print(x+"WARNING : brute force try for user "+lines_token[2])
                    print("----------------------------------------------------------\n")


    elif lines_token[0]=="readReq" and len(lines_token)==9 :
        if(int(lines_token[4])<int(lines_token[6])) :
            if lines_token[8]=="N\n" :
                print("LINE"+str(count))
                print(x+"WARNING : BLP simple property violation try ")
                print("----------------------------------------------------------\n")
            else :
                print("LINE"+str(count))
                print(":::::::::###>>>  ERROR  <<<###:::::::::")
                print(x+"ERROR: BLP simple property VIOLATED")
                print("----------------------------------------------------------\n")

        if(int(lines_token[5])>int(lines_token[7])) :
            if lines_token[8]=="N\n" :
                print("LINE"+str(count))
                print(x+"WARNING : BIBA simple property violation try ")
                print("----------------------------------------------------------\n")
            else :
                print("LINE"+str(count))
                print(":::::::::###>>>  ERROR  <<<###:::::::::")
                print(x+"ERROR: BIBA simple property VIOLATED")
                print("----------------------------------------------------------\n")


    elif lines_token[0]=="writeReq" and len(lines_token)==9 :

        if(int(lines_token[4])>int(lines_token[6])) :
            if lines_token[8]=="N\n" :
                print("LINE"+str(count))
                print(x+"WARNING : BLP *-property violation try ")
                print("----------------------------------------------------------\n")
            else :
                print("LINE"+str(count))
                print(":::::::::###>>>  ERROR  <<<###:::::::::")
                print(x+"ERROR: BLP *-property VIOLATED")
                print("----------------------------------------------------------\n")

        if(int(lines_token[5])<int(lines_token[7])) :
            if lines_token[8]=="N\n" :
                print("LINE"+str(count))
                print(x+"WARNING : BIBA *- property violation try ")
                print("----------------------------------------------------------\n")
            else :
                print("LINE"+str(count))
                print(":::::::::###>>>  ERROR  <<<###:::::::::")
                print(x+"ERROR: BIBA *-property VIOLATED")
                print("----------------------------------------------------------\n")
