#!/bin/bash
#./deploy.sh https://github.com/appgenservice/java-spring-starter.git main 1 user management dbname_1 dbuser_1 dbpassword_1
GIT_REPO=$1
GIT_BRANCH=$2
APP_ID=$3
APP_NAME=$5
DB_NAME=$6
DB_USER=$7
DB_PASSWORD=$8
PORT_BASE=9000
PORT=$(( $PORT_BASE + $APP_ID ))
APP_TMP_DIR=/tmp/${APP_NAME}
DOCKER_IMAGE=appgenservice/${APP_NAME}

echo "Will be cloning ${GIT_REPO} to ${APP_TMP_DIR}"

rm -rf ${APP_TMP_DIR}
echo "Removed ${APP_TMP_DIR}"
echo git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO} ${APP_TMP_DIR}
git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO} ${APP_TMP_DIR}

echo "Clone  ${GIT_REPO} to ${APP_TMP_DIR}"
rm -rf ./src/main/java/*
cp -R ${APP_TMP_DIR}/src/main/java/* ./src/main/java/
echo "Copied ${APP_TMP_DIR} to java-app-engine"

mvn clean package
echo "App package created"

docker build -t ${DOCKER_IMAGE} .
docker rm -f ${APP_NAME}
#If docker running on same machine, add link to communicate between app and mysql
docker run -p ${PORT}:8080 --name=${APP_NAME} -e DB_NAME=${APP_NAME} -e DB_USER=${DB_USER} -e DB_PASSWORD=${DB_PASSWORD} --link mysql  -d ${DOCKER_IMAGE}

sleep 10
echo "Open API UI :  http://appgenservice.com:${PORT}/swagger-ui-custom.html"
