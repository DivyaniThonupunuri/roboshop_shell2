
#!/bin/bash

source ./common.sh
appname=catalogue

#list of functions calling from common.sh
root_check
nodejs_setup
app_setup
system_setup


cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongodb.repo 
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB Client"

STATUS=$(mongosh --host mongodb.devsecops-dt.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.devsecops-dt.site </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi
