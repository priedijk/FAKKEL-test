az login
az account set -s "6d67d5d0-fc45-49eb-af8d-053a6064db99"

clusterName="cni-overlay-cluster"
resourceGroup="aks-cni-overlay"
location="eastus"

az group create -n $resourceGroup -l $location
az aks create -n $clusterName -g $resourceGroup --location $location --network-plugin azure --network-plugin-mode overlay --pod-cidr 172.16.0.0/16 --node-vm-size "Standard_D2plds_v5" --node-count 2 --enable-azure-rbac --enable-aad

az aks get-credentials -n $clusterName -g $resourceGroup

kubelogin convert-kubeconfig -l azurecli

kubectl get no
kubectl get pods -A

kubectl create deployment pingtest --image=busybox --replicas=3 -- sleep infinity
kubectl get pods --selector=app=pingtest --output=wide

kubectl exec -it pingtest-59c784bfb4-96568 -- sh

ping 192.168.45.193 -c 4
