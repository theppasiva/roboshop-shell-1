#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
#MONGODB_HOST=mongodb.sivapractice.online

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

dnf install python36 gcc python3-devel -y &>> $LOGFILE
VALIDATE $? "Installing Python"

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

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
VALIDATE $? "Downloading the Payment application"

cd /app
VALIDATE $? "moving to app directory"

unzip -o /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "Unzipping the Payment package"

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "Installing the dependencies"


cp /home/centos/roboshop-shell-1/payment.service /etc/systemd/system/payment.service
VALIDATE $? "Copying Payment service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Payment demon reload"

systemctl enable payment   &>> $LOGFILE
VALIDATE $? "Enabling payment   "

systemctl start payment   &>> $LOGFILE
VALIDATE $? "Starting payment   "




