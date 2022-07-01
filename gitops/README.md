# Configure Azure ARC connected cluster to use GitOps Flow

## 1 - Install k8s-configuration extension
```bash
az extension add --name k8s-configuration
```

## 2 - Create a new GitOps connection
```bash
#!/bin/sh
source /variables.sh
echo "Creating a new GitOps connection with $GIT_URL"
az k8s-configuration flux create \
   --name cluster-config \
   --cluster-name  $CLUSTER_NAME\
   --namespace cluster-config \
   --resource-group $RESOURCE_GROUP \
   -u $GIT_URL \
   --https-user $GIT_USER \
   --https-key $GIT_PASSWORD \
   --scope cluster \
   --cluster-type connectedClusters \
   --branch $GIT_BRANCH \
   --kustomization name=cluster-config prune=true path=kind-arc-cicd-cluster/manifests
   ```