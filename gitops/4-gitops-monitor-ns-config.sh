#!/bin/bash
source ../variables.sh

echo "Creating flux configuration for monitor namespace"
az k8s-configuration flux create \
    --name monitor-config \
    --namespace monitor \
    --cluster-name $CLUSTER_NAME \
    --resource-group $RESOURCE_GROUP \
    -u $GIT_REPO \
    --https-user $GIT_USER \
    --https-key $GIT_PASSWORD \
    --scope namespace \
    --cluster-type connectedClusters \
    --branch $GIT_BRANCH \
    --kustomization name=monitor-ns prune=true path=kind-arc-cicd-cluster/monitor

