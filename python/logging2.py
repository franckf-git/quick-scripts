#!/usr/bin/python

import os

BASE_PATH=os.getcwd()
LOG_FILE=open(os.path.join(BASE_PATH,"script.log"),"a")

def log(message):
    m=time.strftime("%d-%m-%y %H:%M:%S")+" "+message
    LOG_FILE.write(m+"\n")
    LOG_FILE.flush()
    print(m)

if __name__ == "__main__":
    log("=== Processing started ===")
    try:
      print ("hello")
    except Exception as e:
        log("ERROR : %s" % (e))
    log("=== Processing done ===")
    LOG_FILE.close()