#!/bin/bash
source ./variables.sh
#https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/azure-rbac

#Create a server application
SERVER_APP_ID=$(az ad app create --display-name "${CLUSTER_NAME}Server" --identifier-uris "api://$TENANT_ID/ARC-KIND-SERVER" --query appId -o tsv)
az ad app update --id "${SERVER_APP_ID}" --set groupMembershipClaims=All
az ad sp create --id "${SERVER_APP_ID}"
SERVER_APP_SECRET=$(az ad sp credential reset --name "${SERVER_APP_ID}" --credential-description "ArcSecret" --query password -o tsv)
az ad app permission add --id "${SERVER_APP_ID}" --api 00000003-0000-0000-c000-000000000000 --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope
az ad app permission grant --id "${SERVER_APP_ID}" --api 00000003-0000-0000-c000-000000000000

#Create a role assignment for the server application
#https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/azure-rbac#create-a-role-assignment-for-the-server-application
ROLE_ID=$(az role definition create --role-definition ./accessCheck.json --query id -o tsv)
az role assignment create --role "${ROLE_ID}" --assignee "${SERVER_APP_ID}" --scope "/subscriptions/$SUBSCRIPTION_ID"


#Enable Azure RBAC on the cluster
az connectedk8s enable-features -n $CLUSTER_NAME -g $RESOURCE_GROUP --features azure-rbac --app-id "${SERVER_APP_ID}" --app-secret "${SERVER_APP_SECRET}"