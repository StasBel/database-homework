#!/bin/bash

if [ $# -lt 4]; then
    echo "invalid options"
    exit	
fi

DROP_SQL=$1
INIT_SQL=$2
DBNAME=$3
REBUILD_SQL=$4

psql -U postgres<<-EOF
	\i $DROP_SQL
	\i $INIT_SQL
	\c $DBNAME
	\i $REBUILD_SQL
EOF