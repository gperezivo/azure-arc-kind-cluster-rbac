#!/bin/bash
source ./variables.sh

# Create kind cluster
kind create cluster --config ./cluster-config.yml --name $CLUSTER_NAME


