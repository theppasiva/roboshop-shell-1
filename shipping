#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
#MONGODB_HOST=mongodb.shivarampractise.online

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

dnf install maven -y &>> $LOGFILE
VALIDATE $? "Installing Maven"

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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
VALIDATE $? "Downloading the Shipping application"

cd /app
VALIDATE $? "moving to app directory"

unzip -o /tmp/shipping.zip &>> $LOGFILE
VALIDATE $? "Unzipping the Shipping package"

mvn clean package &>> $LOGFILE
VALIDATE $? "Installing the dependencies"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
VALIDATE $? "Renaming Jar file"

cp /home/centos/roboshop-shell-1/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "Copying Shipping service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Shipping demon reload"

systemctl enable shipping  &>> $LOGFILE
VALIDATE $? "Enabling shipping  "

systemctl start shipping  &>> $LOGFILE
VALIDATE $? "Starting shipping  "

dnf install mysql -y &>> $LOGFILE
VALIDATE $? "Installing mysql client "

mysql -h mysql.shivarampractise.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE
VALIDATE $? "Loading shipping data"

systemctl restart shipping &>> $LOGFILE
VALIDATE $? "Restarting shipping  "

