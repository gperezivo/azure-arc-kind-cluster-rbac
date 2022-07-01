#!/bin/bash
source ../variables.sh

echo "Creating flux configuration for dev-team-1 namespace"
az k8s-configuration flux create \
    --name dev-team-1-config \
    --namespace dev-team-1 \
    --cluster-name $CLUSTER_NAME \
    --resource-group $RESOURCE_GROUP \
    -u $GIT_REPO \
    --https-user $GIT_USER \
    --https-key $GIT_PASSWORD \
    --scope namespace \
    --cluster-type connectedClusters \
    --branch $GIT_BRANCH \
    --kustomization name=dev-team-1-ns prune=true path=kind-arc-cicd-cluster/dev-team-1

