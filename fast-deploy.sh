source variables.sh

. connect-az-cli.sh
. create-kind-cluster.sh
. connect-arc.sh
. create-service-principal.sh


. gitops/2-gitops-cluster-config.sh
. gitops/3-gitops-dev-team-1-ns-config.sh
. gitops/4-gitops-monitor-ns-config.sh

. parse-kubectl.sh ./role-user-binding-template.yml | kubectl apply -f -