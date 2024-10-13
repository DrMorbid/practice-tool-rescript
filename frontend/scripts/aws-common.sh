#!/bin/bash

environment=$1
bucket=practice-tool-dev
buildPath=/home/filip/development/practice-tool-rescript/frontend/out

if [ ${environment} == "prod" ]; then
    bucket=practice-tool
fi
