#!/bin/bash

if [ $# -eq 0 ]
  then
    sudo docker run --name dbserver -e POSTGRES_PASSWORD='password' -d mypostgres
    sudo docker ps
    exit
fi

sudo docker run --name dbserver -e POSTGRES_PASSWORD="$1" -d mypostgres
sudo docker ps
