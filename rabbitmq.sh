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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE 
VALIDATE $? "Downloading earlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE 
VALIDATE $? "Downloading RabbitMq Script"

dnf install rabbitmq-server -y &>> $LOGFILE 
VALIDATE $? "Installing RabbitMq Server" 

systemctl enable rabbitmq-server &>> $LOGFILE 
VALIDATE $? "Enabling RabbitMq Server"

systemctl start rabbitmq-server &>> $LOGFILE 
VALIDATE $? "Starting RabbitMq Server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE 
VALIDATE $? "Creating RabbitMq User"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE 
VALIDATE $? "Setting Permission RabbitMq User"


