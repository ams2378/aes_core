#!/bin/bash

INCR=0
T=1
for i in {0..10}
do
	cat configure.txt | sed -e "s/COPY_HERE/INCR_MSB $INCR/g" > temp1.txt
	rm -rf configure.txt
	mv temp1.txt configure.txt
	make test 
	cat configure.txt | sed -e "s/INCR_MSB $INCR/COPY_HERE/g" > temp2.txt
	mv temp2.txt configure.txt
	INCR=$(($T+$INCR))
done
