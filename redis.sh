#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
exec &> $LOGFILE

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "Installing remi release package"

dnf module enable redis:remi-6.2 -y
VALIDATE $? "Enabling redis package"

dnf install redis -y
VALIDATE $? "Installing redis Server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "Remote access redis "

systemctl enable redis
VALIDATE $? "Enabling redis Server"

systemctl start redis
VALIDATE $? "Starting redis Server"





