#!/bin/bash
source ./variables.sh

echo -e "${BLUE}Creating local Kind cluster ${NC}"
# Create kind cluster
kind create cluster --config ./cluster-config.yml --name $CLUSTER_NAME
echo -e "${GREEN}Local Kind cluster created ${NC}"


