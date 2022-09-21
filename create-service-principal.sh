#!/bin/bash
source ./variables.sh
#https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/azure-rbac
SERVER_APP_NAME="${CLUSTER_NAME}Server"
SERVER_APP_ID=$(az ad app list --identifier-uri "api://$TENANT_ID/ARC-KIND-CONNECTED-$CLUSTER_NAME" --query '[].appId' -o tsv)

## check if server app exists
if [ -z "$SERVER_APP_ID" ]; then
    echo -e "Server app does not exist"
    SERVER_APP_ID=$(az ad app create --display-name $SERVER_APP_NAME --identifier-uris "api://$TENANT_ID/ARC-KIND-CONNECTED-$CLUSTER_NAME" --query appId -o tsv)
    az ad app update --id "${SERVER_APP_ID}" --set groupMembershipClaims=All
    az ad sp create --id "${SERVER_APP_ID}"
    echo -e "${GREEN}Server app created with id: $SERVER_APP_ID ${NC}"
    SERVER_APP_SECRET=$(az ad sp credential reset --id "${SERVER_APP_ID}" --display-name "ArcSecret" --query password -o tsv)
    az ad app permission add --id "${SERVER_APP_ID}" --api 00000003-0000-0000-c000-000000000000 --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope
    #az ad app permission grant --id "${SERVER_APP_ID}" --api 00000003-0000-0000-c000-000000000000
else
    echo -e "${BLUE}Server app already exists $SERVER_APP_ID ${NC}"
    echo -e "${YELLOW}Resetting server app secret ${NC}"
    SERVER_APP_SECRET=$(az ad sp credential reset --id "${SERVER_APP_ID}" --display-name "ArcSecret" --query password -o tsv)
fi

#Replace variables on accessCheck.json with the values from variables.sh
export CLUSTER_NAME=$CLUSTER_NAME
export SUBSCRIPTION_ID=$SUBSCRIPTION_ID
ACCESS_CHECK_DEFINITION=$(envsubst < accessCheck.json)
ACCESS_CHECK_NAME=$(echo $ACCESS_CHECK_DEFINITION | jq -r '.Name')


#Create a role assignment for the server application
#https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/azure-rbac#create-a-role-assignment-for-the-server-application
#check if custom role definition exists
ROLE_ID=$(az role definition list --custom-role true --name "$ACCESS_CHECK_NAME" --query '[].id' -o tsv)
if [ -z "$ROLE_ID" ]; then
    echo -e "${GREEN}Custom role definition does not exist${NC}"
    ROLE_ID=$(az role definition create --role-definition "$ACCESS_CHECK_DEFINITION" --query id -o tsv)
else
    echo -e "${BLUE}Custom role $ACCESS_CHECK_NAME definition already exists ${NC}"
fi
# echo -e "${YELLOW}Waiting for Service principal registration ${NC}"
# sleep 5


ROLE_ASSIGNMENT_ID=$(az role assignment list --assignee $SERVER_APP_ID --role $ROLE_ID  --scope "/subscriptions/$SUBSCRIPTION_ID" --query id -o tsv)
if [ -z "$ROLE_ASSIGNMENT_ID" ]; then
    echo -e "${BLUE}Role assignment does not exist${NC}"
    ROLE_ASSIGNMENT_ID=$(az role assignment create --assignee $SERVER_APP_ID --role $ROLE_ID --scope "/subscriptions/$SUBSCRIPTION_ID" --query id -o tsv)
    echo -e "${GREEN}Role assignment created ${NC}"
else
    echo -e "${BLUE}Role assignment already exists ${NC}"
fi



#Enable Azure RBAC on the cluster
echo -e "${BLUE}Enabling Azure RBAC on the cluster ${NC}"
az connectedk8s enable-features -n $CLUSTER_NAME -g $RESOURCE_GROUP --features azure-rbac --app-id "${SERVER_APP_ID}" --app-secret "${SERVER_APP_SECRET}"
echo -e "${GREEN}Azure RBAC enabled on the cluster ${NC}"