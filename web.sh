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

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "Removing default website conf"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "Downloading the Web application"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "moving nginx html directory"


unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "Unzipping the web package"


cp /home/centos/roboshop-shell-1/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE 
VALIDATE $? "copied roboshop reverse proxy config"

systemctl restart nginx  &>> $LOGFILE
VALIDATE $? "Restart Nginx"





