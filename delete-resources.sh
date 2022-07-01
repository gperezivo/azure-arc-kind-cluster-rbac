source variables.sh

az connectedk8s delete --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --subscription $SUBSCRIPTION_ID 
kind delete cluster --name $CLUSTER_NAME
SERVER_APP_ID=$(az ad app show --id "api://$TENANT_ID/ARC-KIND-CONNECTED" --query appId -o tsv)


az ad app delete --id "${SERVER_APP_ID}"
export CLUSTER_NAME=$CLUSTER_NAME
export SUBSCRIPTION_ID=$SUBSCRIPTION_ID
ACCESS_CHECK_DEFINITION=$(envsubst < accessCheck.json)
ACCESS_CHECK_NAME=$(echo $ACCESS_CHECK_DEFINITION | jq -r '.Name')
ROLE_ID=$(az role definition list --custom-role true --name "$ACCESS_CHECK_NAME" --query '[].id' -o tsv)
az role assignment delete --role $ROLE_ID  
az role definition delete --name "$ACCESS_CHECK_NAME"