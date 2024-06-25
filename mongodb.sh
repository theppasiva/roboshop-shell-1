#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started excuting at $TIMESTAMP" &>> LOGFILE 

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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE
VALIDATE $? "Copied MongDBRepo"

dnf install mongodb-org -y &>> LOGFILE
VALIDATE $? "Installing MongDB"

systemctl enable mongod &>> LOGFILE
VALIDATE $? "Enabling MongDB"

systemctl start mongod &>> LOGFILE
VALIDATE $? "Starting MongDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> LOGFILE
VALIDATE $? "Remote access MongDB"

systemctl restart mongod &>> LOGFILE
VALIDATE $? "Restarting MongDB"



