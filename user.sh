#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGODB_HOST=mongodb.shivarampractise.online

echo "Script started excuting at $TIMESTAMP" &>> $LOGFILE 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "Error:: $2..  $R is failed $N"
        exit 1
    else
        echo -e "$2  $G is success $N"
    fi

}
if [ $ID -ne 0 ]
then
    echo -e "$R Error:: please run with root user $N"
    exit 1
else
    echo "You are root user"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling current NodeJs10"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabling NodeJs18"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing NodeJs Server"

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "Downloading the user package"

cd /app 

unzip -o /tmp/user.zip &>> $LOGFILE
VALIDATE $? "Unzipping the user package"

npm install &>> $LOGFILE
VALIDATE $? "Installing npm package"

# use absolute, because cart.service exists there
cp /home/centos/roboshop-shell-1/user.service /etc/systemd/system/user.service &>> $LOGFILE
VALIDATE $? "Adding cart package"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "User demon reload"

systemctl enable user &>> $LOGFILE
VALIDATE $? "Enabling User "

systemctl start user &>> $LOGFILE
VALIDATE $? "Starting user "

cp /home/centos/roboshop-shell-1/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Coping mongoRepo Configuration"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/user.js &>> $LOGFILE
VALIDATE $? "Loading catalouge data into MongoDB "




