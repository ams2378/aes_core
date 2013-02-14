#!/bin/bash

key="01020304050607080900010203040506"
iv="01020304050607080900010203040506"
openssl enc -aes-128-cbc -in test -out test.enc -K $key128 -iv $iv
