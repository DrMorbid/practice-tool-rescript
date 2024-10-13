#!/bin/bash

echo "Deployment started"

. ./aws-common.sh

echo "Deploying to ${environment}"

. ./aws-rm.sh ${environment}

echo "Previous deployment purged"

. ./aws-cp.sh ${environment}

echo "Deployment finished"
