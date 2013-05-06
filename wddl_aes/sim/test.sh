#!/bin/bash

make test

INCR=0
T=1
for i in {0..0}
do
	cp configure.txt.bak configure.txt
	cat configure.txt | sed -e "s/COPY_HERE/INCR_MSB $INCR/g" > temp1.txt
	mv temp1.txt configure.txt
	make run 
#	cp configure.txt.bak configure.txt
	INCR=$(($T+$INCR))
done
