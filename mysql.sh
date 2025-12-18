#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
 
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)
 mkdir -p $LOGS_FOLDER
echo "script started executed at: $(date)"|tee -a $LOG_FILE
if [ $USERID -ne 0 ]; then
    echo "ERROR:: please run this script with root previliges"
    exit 1
    fi
    VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
    echo -e "$2 .....$R failed $N"|tee -a $LOG_FILE
    exit 1
    else
    echo -e  "$2 ....$G success $N"|tee -a $LOG_FILE
    fi
    }
dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing mysql server"
systemctl enable mysqld &>>LOG_FILE
VALIDATE $? "enable mysqld"
systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "start mysqld"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "setting up root password"

 END_TIME=$(date +%S)
    TOTAL_TIME=$(( $END_TIME-$START_TIME ))
    echo -e "script executed in:$Y $TOTAL_TIME seconds $N"
