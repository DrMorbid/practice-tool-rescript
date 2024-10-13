#!/bin/bash

. ./aws-common.sh

aws s3 cp ${buildPath} s3://${bucket} \
  --recursive
