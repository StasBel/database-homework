#!/bin/bash

psql -U postgres -d vpiska<<-EOF
	\i /DBsrc/src/vpiska/build.sql
EOF
