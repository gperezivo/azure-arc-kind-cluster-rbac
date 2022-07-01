#!/bin/bash
source ./variables.sh
echo -e "${BLUE}Creating Azure Arc cluster ${NC}"
az connectedk8s connect --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --subscription $SUBSCRIPTION_ID --location $LOCATION
echo -e "${GREEN}Azure Arc cluster created ${NC}"