#!/bin/bash
#./deploy.sh ${APP_GIT_REPO_URL} ${GIT_BRANCH} ${APP_ID} ${APP_NAME}
GIT_REPO=$1
GIT_BRANCH=$2
APP_ID=$3
APP_NAME=$4_${APP_ID}
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
docker run -p ${PORT}:8080 --name=${APP_NAME} -e DB_NAME=${APP_NAME} --link mysql  -d ${DOCKER_IMAGE}

sleep 10
echo "Open API UI :  http://appgenservice.com:${PORT}/swagger-ui-custom.html"
