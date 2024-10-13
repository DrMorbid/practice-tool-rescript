#!/bin/bash

. ./aws-common.sh

aws s3 ls s3://${bucket} \
  --recursive \
  --human-readable \
  --summarize
