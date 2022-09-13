#!/bin/bash

echo "Creating flux configuration for monitor namespace"
az k8s-configuration flux create \
    --name monitor-config \
    --namespace cluster-config \
    --cluster-name $CLUSTER_NAME \
    --resource-group $RESOURCE_GROUP \
    -u $GIT_REPO \
    --https-user $GIT_USER \
    --https-key $GIT_PASSWORD \
    --scope cluster \
    --cluster-type connectedClusters \
    --branch $GIT_BRANCH \
    --kustomization name=monitor-ns prune=true path=kind-arc-cicd-cluster/monitor

