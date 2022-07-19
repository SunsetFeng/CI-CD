#!/bin/bash

project=$1
version=$2
host=192.168.233.131
port=8070
storage=repo
dockerName=$host:$port/$storage/$project

containers=$(docker ps -a | grep $dockerName  | awk '{print $1}')
for id in $containers
do
    docker stop $id
    docker rm $id
done

images=$(docker images | grep $dockerName | awk '{print $3}')
for image in $images
do
    docker rmi $image
done

docker login -u admin -p '211120Qy&Lrr' $host:$port
docker pull $dockerName:$version

docker run -d -p 80:80 $dockerName:$version