#!/bin/bash

if [ $# -ne 1 ]
  then
    echo "Error. Invalid arguments! Usage: runClient.sh <username>"
    exit
fi


sudo docker run -v /home/team5/SPbAU-database-hw/src:/DBsrc -it --rm --link dbserver:postgres postgres psql -h postgres -U "$1"
