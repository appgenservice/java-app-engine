#!/bin/bash

GIT_REPO=$1
APP_ID=$2

# Below two lines doesn't belong here. When register for service create database, user and password
mysql -uroot -ppassword  --host=127.0.0.1 --port=3306 -e "drop database app${APP_ID};"
mysql -uroot -ppassword  --host=127.0.0.1 --port=3306 -e "create database app${APP_ID};"

echo "Will be cloning ${GIT_REPO} to ${APP_ID}"
rm -rf /tmp/${APP_ID}
echo "Removed /tmp/${APP_ID}"
echo git clone --single-branch --branch app-${APP_ID} ${GIT_REPO} /tmp/${APP_ID}
git clone --single-branch --branch app-${APP_ID} ${GIT_REPO} /tmp/${APP_ID}

echo "Clone  ${GIT_REPO} to /tmp/${APP_ID}"
rm -rf ./src/main/java/*
cp -R /tmp/${APP_ID}/src/main/java ./src/main/java
echo "Copied /tmp/${APP_ID} to java-app-engine"

mvn clean package
echo "App package created"

docker build -t cheenath/java-app-${APP_ID} .
docker rm -f java-app-${APP_ID}
#If docker running on same machine, add link to communicate between app and mysql
docker run -p 808${APP_ID}:8080 --name=java-app-${APP_ID} -e DB_NAME=app${APP_ID} --link mysql  -d cheenath/java-app-${APP_ID}
