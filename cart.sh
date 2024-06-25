#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
#exec &> $LOGFILE

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

mkdir /app
VALIDATE $? "Creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "Downloading the cart package"

cd /app 

unzip -o /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "Unzipping the cart package"

npm install &>> $LOGFILE
VALIDATE $? "Installing npm package"

# use absolute, because cart.service exists there
cp /home/centos/roboshop-shell-1/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "Adding cart package"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Cart demon reload"

systemctl enable cart &>> $LOGFILE
VALIDATE $? "Enabling cart "

systemctl start cart &>> $LOGFILE
VALIDATE $? "Starting cart "




