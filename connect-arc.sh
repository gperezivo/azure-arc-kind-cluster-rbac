#!/bin/bash
source ./variables.sh
az connectedk8s connect --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --subscription $SUBSCRIPTION_ID --location $LOCATION