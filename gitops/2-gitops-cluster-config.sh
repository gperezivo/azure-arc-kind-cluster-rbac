#!/bin/bash
source ../variables.sh
echo "Creating a new GitOps connection with $GIT_REPO"
az k8s-configuration flux create \
   --name cluster-config \
   --cluster-name  $CLUSTER_NAME\
   --namespace cluster-config \
   --resource-group $RESOURCE_GROUP \
   -u $GIT_REPO \
   --scope cluster \
   --cluster-type connectedClusters \
   --branch $GIT_BRANCH \
   --kustomization name=cluster-manifests prune=true path=kind-arc-cicd-cluster/manifests