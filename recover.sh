#!/bin/sh

VERSION=latest


# stop & remove docker
echo "### stop & remove docker ###"
docker stop $(docker ps -q)
docker rm $(docker ps -q -a)


# stop & start docker
systemctl stop docker
sleep 1
systemctl start docker

# wait docker start
sleep 10
docker version

# pull & run docker images
docker run -d -p 8888:8888 --name jupyter -e TZ=JST-9 irixjp/aitac-automation:${VERSION:?}
sleep 10

# add handson contents into the container
docker exec jupyter git clone https://github.com/irixjp/aitac-automation-handson.git

#PUB_IP=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
PUB_IP=`curl -s ipinfo.io|jq .ip`
echo ''
echo ''
echo 'Access to the below url'
echo '###############################################################'
echo ''
docker logs jupyter 2>&1 | grep "     http://localhost:8888/?token=" | tail -1 | sed -e s/localhost/${PUB_IP:?}/g
echo ''
echo '###############################################################'
echo ''
echo ''


