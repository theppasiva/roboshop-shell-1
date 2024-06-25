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

dnf module disable mysql -y &>> LOGFILE
VALIDATE $? "Desable mysql"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> LOGFILE
VALIDATE $? "Copying MySqlRepo"

dnf install mysql-community-server -y &>> LOGFILE
VALIDATE $? "Installing MySqlServer"

systemctl enable mysqld &>> LOGFILE
VALIDATE $? "Enabling MySqlServer"

systemctl start mysqld &>> LOGFILE
VALIDATE $? "Starting MySqlServer"

mysql_secure_installation --set-root-pass RoboShop@1 &>> LOGFILE
VALIDATE $? "Setting MySqlRepo  root Password"








