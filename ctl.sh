#!/bin/bash

CONT=dbserver
IMAGE=mypostgres
POSTGRES_CONT=postgres
DEFAULT_PASS=password
DOCKERFILE=./Dockerfile
DOCKER_SRC=/DBsrc
SRC=`pwd`/src
INIT_SQL=init.sql
DROP_SQL=drop.sql
DBNAME=vpiska

function print_usage() {
	echo ""
}

function create_cnt() {
	local password=$DEFAULT_PASS
	local cont=$CONT
	if [ -n "$1" ];then
		cont=$1
	fi
	if [ -n "$2" ];then
		password=$2
	fi
	docker run --name $cont -e POSTGRES_PASSWORD=$password -d $IMAGE
}

function start_cnt() {
	local cont=$CONT
	if [ -n "$1" ];then
		cont=$1
	fi
	docker start $cont
}

function stop_cnt() {
	local cont=$CONT
	if [ -n "$1" ];then
		cont=$1
	fi
	docker stop $cont
}

function restart_cnt() {
	local cont=$CONT
	if [ -n "$1" ];then
		cont=$1
	fi
	docker restart $cont
}

function build-im() {
	local tag=latest
	if [ -n "$1" ];then
		tag=$1
	fi
	docker build -f $DOCKERFILE -t $IMAGE:$tag .
} 

function psql-cmd() {
	if [ -z $1 ] ;then
	    echo "please, provide username"
	    exit
	fi
	local cont=$CONT
	if [ -n "$2" ];then
		cont=$2
	fi
	docker run -v $SRC:$DOCKER_SRC -it --rm --link $cont:$POSTGRES_CONT postgres psql -h postgres -U "$1"
}

function psql_rebuild_db() {
	if [ $# -lt 2 ]
	  then
	    echo "please, provide username and reload script"
	    exit
	fi
	local cont=$CONT
	if [ -n "$3" ];then
		cont=$3
	fi
	
	CMD="docker run -v `pwd`:$DOCKER_SRC -it --rm --link $cont:$POSTGRES_CONT postgres psql -h postgres -U $1"
	
	$CMD -c "\i $DOCKER_SRC/drop.sql"
	$CMD -c "\i $DOCKER_SRC/init.sql"
	$CMD -d $DBNAME -c "\i $DOCKER_SRC/src/$2"
}

if [ $# -eq 0 ]; then
	print_usage
	exit 0
fi

set -e
set -o xtrace

case $1 in
create-cnt):
	create_cnt $2 $3
	;;
build-im):
	build-im $2
	;;
start-cnt):
	start_cnt $2
	;;
stop-cnt):
	stop_cnt $2
	;;
restart-cnt)
	restart_cnt $2
	;;
psql-cmd):
	psql-cmd $2 $3
	;;
psql-rebuild-db):
	psql_rebuild_db $2 $3 $4
	;;
*)
	;;
esac
