#!/bin/bash

. ./aws-common.sh

aws s3 rm s3://${bucket} \
  --recursive
