#!/bin/bash

ami="$1"

# amzn2: arm64
./create-cf.sh wp-03 ${ami} t4g.micro


