#!/bin/bash
GIT_REPO=$1
GIT_BRANCH=$2
APP_ID=$3
APP_NAME=$4
DB_NAME=$5
DB_USER=$6
DB_PASSWORD=$7
PORT=$8
APP_TMP_DIR=/tmp/${APP_NAME}
DOCKER_IMAGE=appgenservice/${APP_NAME}

MYSQL_LINK=mysql

echo "Will be cloning ${GIT_REPO} to ${APP_TMP_DIR}"

rm -rf ${APP_TMP_DIR}
echo "Removed ${APP_TMP_DIR}"
echo git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO} ${APP_TMP_DIR}
git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO} ${APP_TMP_DIR}

cd ${APP_TMP_DIR}
#echo "Clone  ${GIT_REPO} to ${APP_TMP_DIR}"
#rm -rf ./src/main/*
#cp -R ${APP_TMP_DIR}/src/main/* ./src/main/
#cp ${APP_TMP_DIR}/pom.xml ./pom.xml
#echo "Copied ${APP_TMP_DIR} to java-app-engine"

mvn clean package
echo "App package created"

echo docker build -t ${DOCKER_IMAGE} .
docker build -t ${DOCKER_IMAGE} .
echo docker rm -f ${APP_NAME}
docker rm -f ${APP_NAME}
#If docker running on same machine, add link to communicate between app and mysql
echo docker run -p ${PORT}:8080 --name=${APP_NAME} -e DB_NAME=${DB_NAME} -e DB_USER=${DB_USER} -e DB_PASSWORD=${DB_PASSWORD} --link mysql  -d ${DOCKER_IMAGE}
docker run -p ${PORT}:8080 --name=${APP_NAME} -e DB_NAME=${DB_NAME} -e DB_USER=${DB_USER} -e DB_PASSWORD=${DB_PASSWORD} -e MYSQL_HOST=${MYSQL_LINK} --link ${MYSQL_LINK}  -d ${DOCKER_IMAGE}

sleep 10
echo "Open API UI :  http://myvotes.in:${PORT}/swagger-ui-custom.html"

rm -rf ${APP_TMP_DIR}
echo "All set. Removed ${APP_TMP_DIR}"

