#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
 
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
 mkdir -p $LOGS_FOLDER
echo "script started executed at: $(date)"|tee -a $LOG_FILE
if [ $USERID -ne 0 ]; then
    echo "ERROR:: please run this script with root previliges"
    exit 1
    fi
    VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
    echo -e "$2.....$R failed $N"
    exit 1
    else
    echo -e  "$2....$G success $N"
    fi
    }
    cp mongo.repo /etc/yum.repos.d/mongo.repo
    VALIDATE $? "Adding Mongo repo"
    dnf install mongodb-org -y &>>$LOG_FILE
    VALIDATE $? "Installing MongoDB"
   systemctl  enable mongod &>>$LOG_FILE
   VALIDATE $? "enable mongodb"
   systemctl   start mongod &>>$LOG_FILE
   VALIDATE $? "start mongodb"
   sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
   VALIDATE $? "Allowing remote connections to mongodb"
   systemctl restart mongod &>>$LOG_FILE
   VALIDATE $? "Restarted mongod"

