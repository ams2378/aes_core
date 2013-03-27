#!/bin/bash

incr = "2"
cat configure.txt | sed -e 's/INCR_MSB */INCR_MSB $incr /' > temp.txt
rm -rf testfile.txt
mv temp.txt testfile.txt
