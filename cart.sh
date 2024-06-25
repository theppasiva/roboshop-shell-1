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

dnf module disable nodejs -y
VALIDATE $? "Removing NodeJs10"

dnf module enable nodejs:18 -y
VALIDATE $? "Enabling NodeJs18"

dnf install nodejs -y
VALIDATE $? "Installing NodeJs Server"

useradd roboshop
VALIDATE $? "Creating roboshop user"

mkdir /app
VALIDATE $? "Creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "Downloading the cart package"

cd /app 
VALIDATE $? "Adding app directory"

unzip -o /tmp/cart.zip
VALIDATE $? "Unzipping the cart package"

npm install 
VALIDATE $? "Installing npm package"

cp cart.service /etc/systemd/system/cart.service
VALIDATE $? "Adding cart package"

systemctl daemon-reload
VALIDATE $? "Loading demon reload"

systemctl enable cart 
VALIDATE $? "Enabling cart server"

systemctl start cart
VALIDATE $? "Starting cart server"




