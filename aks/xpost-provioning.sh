#!/bin/bash  

### --- REMOTE ---

export IDENTITY_RESOURCE_GROUP=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw resourcegroup)
export IDENTITY_CLIENT_ID=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw identity_client_id)
export IDENTITY_TENANT_ID=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw identity_tenant_id)
export IDENTITY_RESOURCE_ID=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw identity_id)
export KEYVAULT_NAME=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw keyvault_name)
export ID_NAME=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw id_name)
export SUBSCRIPTION_ID=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw subscription_id)
export AGW_NAME=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw agw_name)
export AGW_RESOURCE_GROUP=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw agw_resource_group)
export AGIC_CLIENT_ID=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw agic_client_id)
export AGIC_TENANT_ID=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw agic_tenant_id)
export AGIC_RESOURCE_ID=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw agic_id)
export VM=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw vm)
export AKS=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw aks_name)
export RG=$(terraform -chdir=${{ inputs.terraform-directory }} output -raw aks_resource_group_name)

echo $IDENTITY_RESOURCE_GROUP
echo $IDENTITY_CLIENT_ID
echo $IDENTITY_RESOURCE_ID
echo $IDENTITY_TENANT_ID
echo $KEYVAULT_NAME
echo $ID_NAME
echo $SUBSCRIPTION_ID
echo $AGW_NAME
echo $AGW_RESOURCE_GROUP
echo $AGIC_CLIENT_ID
echo $AGIC_TENANT_ID
echo $AGIC_RESOURCE_ID
echo $VM
echo $AKS
echo $RG

az aks command invoke -n $AKS -g $RG -c 'helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts && helm repo update && helm upgrade --install aad-pod-identity aad-pod-identity/aad-pod-identity --namespace=kube-system'

az aks command invoke -n $AKS -g $RG -c 'kubectl get pods -A'

az aks enable-addons --addons azure-keyvault-secrets-provider --name $AKS  --resource-group $RG

cat <<EOF >/tmp/ai.yaml
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: ${ID_NAME}
spec:
  type: 0
  resourceID: ${IDENTITY_RESOURCE_ID}
  clientID: ${IDENTITY_CLIENT_ID}
EOF

cat <<EOF >/tmp/aib.yaml
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: ${ID_NAME}-binding
spec:
  azureIdentity: ${ID_NAME}
  selector: ${ID_NAME}
EOF

az aks command invoke -n $AKS -g $RG -f /tmp/ai.yaml -c 'kubectl apply -f ai.yaml'

az aks command invoke -n $AKS -g $RG -f /tmp/aib.yaml -c 'kubectl apply -f aib.yaml'

cat <<EOF >/tmp/spc.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kvname-podid
spec:
  provider: azure
  secretObjects:
  - secretName: testsecret
    type: Opaque                              
    data: 
    - objectName: MYSECRET
      key: datafield
  parameters:
    usePodIdentity: "true"               
    keyvaultName: ${KEYVAULT_NAME}
    cloudName: ""                        
    objects:  |
      array:
        - |
          objectName: MYSECRET
          objectType: secret             
          objectVersion: ""              
    tenantId: ${IDENTITY_TENANT_ID}
EOF

cat <<EOF >/tmp/php.yaml
kind: Pod
apiVersion: v1
metadata:
  name: php
  labels:
    aadpodidbinding: ${ID_NAME}
spec:
  containers:
    - name: php
      image: tvdvoorde/php5000:2
      volumeMounts:
      - name: secrets-store01-inline
        mountPath: "/mnt/secrets-store"
        readOnly: true
      env:
      - name: SECRETVALUEFROMKEYVAULT
        valueFrom:
          secretKeyRef:
            name: testsecret
            key: datafield
  volumes:
    - name: secrets-store01-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "azure-kvname-podid"
EOF

cat <<EOF >/tmp/test.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: test
    aadpodidbinding: ${ID_NAME}
  name: test
spec:
  containers:
  - args:
    - sleep
    - "3600"
    image: mcr.microsoft.com/azure-cli
    name: test
EOF

az aks command invoke -n $AKS -g $RG -f /tmp/spc.yaml -c 'kubectl apply -f spc.yaml'

az aks command invoke -n $AKS -g $RG -f /tmp/php.yaml -c 'kubectl apply -f php.yaml'

az aks command invoke -n $AKS -g $RG -f /tmp/test.yaml -c 'kubectl apply -f test.yaml'

az aks command invoke -n $AKS -g $RG -c 'kubectl get pods'

az aks command invoke -n $AKS -g $RG -c 'kubectl get secrets'

az aks command invoke -n $AKS -g $RG -c 'kubectl get pods'

az aks command invoke -n $AKS -g $RG -c 'kubectl get secrets'


# ---CONSOLE---

ssh-keygen -f "/home/ted/.ssh/known_hosts" -R "$VM"
ssh azureuser@$VM

az login --identity
export ACR=$(az acr list --query '[].name' -o tsv)
export AKS=$(az aks list --query '[].name' -o tsv)
export RG=$(az aks list --query '[].resourceGroup' -o tsv)
echo $RG $AKS $ACR
az aks get-credentials -n $AKS -g $RG --admin --overwrite-existing
sudo az aks install-cli  

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

kubectl get pods -w

kubectl exec test -it -- bash

# curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true -s
# curl -H Metadata:true http://169.254.169.254/metadata/instance/compute?api-version=2019-11-01


token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true -s|jq -r ".access_token"|cut -f2 -d.)
echo $token==|base64 -d|jq .
exit

# ---REMOTE---

cat <<EOF >/tmp/agic.yaml
verbosityLevel: 3
appgw:
  subscriptionId: ${SUBSCRIPTION_ID}
  resourceGroup: ${AGW_RESOURCE_GROUP}
  name: ${AGW_NAME}
  usePrivateIP: true
  shared: true
kubernetes:
  watchNamespace: default
armAuth:
  type: aadPodIdentity
  identityResourceID: ${AGIC_RESOURCE_ID}
  identityClientID: ${AGIC_CLIENT_ID}
rbac:
  enabled: true
EOF

az aks command invoke -n $AKS -g $RG -f /tmp/agic.yaml -c 'helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/ && helm repo update && helm install ingress-azure -f agic.yaml application-gateway-kubernetes-ingress/ingress-azure --version 1.5.2'

# az aks command invoke -n $AKS -g $RG -f /home/ted/app3.thx1139.com.crt -f /home/ted/app3.thx1139.com.key  -c 'kubectl create secret tls app3 --cert=app3.thx1139.com.crt --key=app3.thx1139.com.key'

# ---CONSOLE---

ssh azureuser@$VM

openssl req -x509 -nodes -days 10000 -newkey rsa:2048 -keyout cert.key -out cert.crt -subj "/C=NL/ST=Utrecht/L=Utrecht/O=IT/CN=nginx.domain.local"

kubectl create secret tls nginx --cert=cert.crt --key=cert.key

kubectl create deployment nginx --image=nginx --port=80

kubectl expose deployment nginx --type=ClusterIP

kubectl get AzureIngressProhibitedTarget

# apiVersion: v1
# items:
# - apiVersion: appgw.ingress.k8s.io/v1
#   kind: AzureIngressProhibitedTarget
#   metadata:
#     annotations:
#       meta.helm.sh/release-name: application-gateway-kubernetes-ingress
#       meta.helm.sh/release-namespace: agic-system
#     creationTimestamp: "2022-02-08T17:43:49Z"
#     generation: 1
#     labels:
#       app.kubernetes.io/managed-by: Helm
#     name: prohibit-all-targets
#     namespace: agic-system
#     resourceVersion: "4476"
#     uid: edba73a5-bc97-4fa2-8178-b26de27c050c
#   spec:
#     paths:
#     - /*
# kind: List
# metadata:
#   resourceVersion: ""
#   selfLink: ""

cat <<EOF |kubectl apply -f -
apiVersion: "appgw.ingress.k8s.io/v1"
kind: AzureIngressProhibitedTarget
metadata:
  name: appsvc
spec:
  hostname: appsvc.domain.local
EOF

kubectl delete AzureIngressProhibitedTarget prohibit-all-targets

cat <<EOF |kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: app
  annotations:
    appgw.ingress.kubernetes.io/backend-path-prefix: /
    appgw.ingress.kubernetes.io/connection-draining: "true"
    appgw.ingress.kubernetes.io/connection-draining-timeout: "30"
    appgw.ingress.kubernetes.io/ssl-redirect: "false"
    appgw.ingress.kubernetes.io/use-private-ip: "true"
    appgw.ingress.kubernetes.io/override-frontend-port: "443"
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  tls:
  - hosts:
      - nginx.domain.local
    secretName: nginx
  rules:
    - host: nginx.domain.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx
                port:
                  number: 80
EOF

kubectl logs deployment/ingress-azure -f

curl -k https://nginx.domain.local --resolve nginx.domain.local:443:10.1.0.10

curl -k https://appsvc.domain.local --resolve appsvc.domain.local:443:10.1.0.10

kubectl create ns sysdig-agent
helm repo add sysdig https://charts.sysdig.com
helm repo update
helm upgrade --install sysdig-agent sysdig/sysdig \
  --namespace sysdig-agent \
  --set sysdig.accessKey=0b83920a-bd47-4866-abdd-34891223c124 \
  --set sysdig.settings.collector=ingest-eu1.app.sysdig.com \
  --set sysdig.settings.collector_port=6443 \
  --set sysdig.settings.tags="linux:ubuntu\,dept:dev\,local:nyc" \
  --set clusterName=THX \
  --set secure.vulnerabilityManagement.newEngineOnly=true \
  --set nodeAnalyzer.deploy=false

# kubectl create ns sysdig-agent
# helm repo add sysdig https://charts.sysdig.com
# helm repo update
# helm install
#     --namespace=`dev`
#     --sysdig.accessKey=`1234-your-key-here-1234`
#     --sysdig.settings.collector='mycollector.elb.us-west-1.amazonaws.com'
#     --sysdig.settings.collector_port=`6443`
#     --set sysdig.settings.tags='linux:ubuntu,dept:dev,local:nyc'
#     --set sysdig.settings.k8s_cluster_name='my_cluster'
#   sysdig/sysdig

# kubectl create ns sysdig-admission-controller
# helm repo add sysdig https://charts.sysdig.com
# helm repo update
# helm upgrade --install admission-controller sysdig/admission-controller \
#   --namespace sysdig-admission-controller \
#   --set sysdig.secureAPIToken=c3077596-f5a4-45c2-bc73-28bcd371f8e0 \
#   --set clusterName=THX \
#   --set sysdig.url=https://eu1.app.sysdig.com \
#   --set features.k8sAuditDetections=true \
#   --set nodeSelector."kubernetes\.azure\.com/mode"=system 
#








































### APP Service

### ---REMOTE---

scp ../php/*.php azureuser@$VM:/tmp
ssh azureuser@$VM

### ---console---

az login --identity
export WEBAPP=$(az webapp list --query '[].name' -o tsv)
export RG=$(az webapp list --query '[].resourceGroup' -o tsv)
rm php.zip
zip -j php.zip /tmp/*.php 
az webapp deployment source config-zip --resource-group $RG --name $WEBAPP --src php.zip
curl https://https://$WEBAPP.azurewebsites.net
curl -k https://appsvc.domain.local --resolve appsvc.domain.local:443:10.1.0.10
curl -X POST -F 'name=/bin/bash -c "ls -ltr"'  https://$WEBAPP.azurewebsites.net/process.php
curl -X POST -F 'name=/bin/bash -c "curl ifconfig.io"'  https://$WEBAPP.azurewebsites.net/process.php
curl -k -v https://appsvc.domain.local --resolve appsvc.domain.local:443:10.1.0.10
echo "10.1.0.10  appsvc.domain.local" | sudo tee -a /etc/hosts
w3m https://appsvc.domain.local


#

# https://docs.sysdig.com/en/docs/installation/admission-controller-installation/#admission-controller-installation


#





























































































# on console

az login --service-principal -u 16f393ec-2523-4db2-8c56-175b2839e735 -p 3UNLwktcTpJ1qPWBbLrhHsCVbZ~8SH7qeX  --tenant thx1139corp.onmicrosoft.com

export ACR=$(az acr list --query '[].name' -o tsv)
export AKS=$(az aks list --query '[].name' -o tsv)
export RG=$(az aks list --query '[].resourceGroup' -o tsv)
echo $RG $AKS $ACR

az aks get-credentials -n $AKS -g $RG --admin --overwrite-existing
az aks install-cli  

echo FROM tvdvoorde/php5000:2>Dockerfile

az acr build -t php5000:2 -r $ACR .

kubectl create deployment test --image=$ACR.azurecr.io/php5000:2
kubectl expose deployment test --type=LoadBalancer --port=80 --target-port=5000
kubectl get service -w



helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts

helm install kube-system aad-pod-identity/aad-pod-identity --set nmi.priorityClassName="system-cluster-critical" --set mic.priorityClassName="system-cluster-critical" 

export IDENTITY_RESOURCE_GROUP="rg-id"
export IDENTITY_NAME="application-identity"

az group create -g ${IDENTITY_RESOURCE_GROUP} -l westeurope

az identity create --resource-group ${IDENTITY_RESOURCE_GROUP} --name ${IDENTITY_NAME}

export IDENTITY_CLIENT_ID="$(az identity show -g rg-id -n ${IDENTITY_NAME} --query clientId -otsv)"
export IDENTITY_RESOURCE_ID="$(az identity show -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME} --query id -otsv)"

export NODE_GROUP=$(az aks show -g $RG -n $AKS --query nodeResourceGroup -o tsv)
export NODES_RESOURCE_ID=$(az group show -n $NODE_GROUP -o tsv --query "id")
echo $NODE_GROUP
echo $NODES_RESOURCE_ID

az role assignment create --role "Virtual Machine Contributor" --assignee "$IDENTITY_CLIENT_ID" --scope $NODES_RESOURCE_ID



az aks command invoke -n $AKS -g $RG -c 'kubectl get pods'

export IDENTITY_NAME="my-pod-identity"

cat <<EOF>podid.yaml
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: ${IDENTITY_NAME}
spec:
  type: 0
  resourceID: ${IDENTITY_RESOURCE_ID}
  clientID: ${IDENTITY_CLIENT_ID}
EOF

cat podid.yaml



az aks command invoke -n $AKS -g $RG  -f podid.yaml -c 'kubectl apply -f podid.yaml'

cat <<EOF>binding.yaml
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: ${IDENTITY_NAME}-binding
spec:
  azureIdentity: ${IDENTITY_NAME}
  selector: ${IDENTITY_NAME}
EOF

cat binding.yaml

az aks command invoke -n $AKS -g $RG  -f binding.yaml -c 'kubectl apply -f binding.yaml'






cat<<EOF>demo.yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo
  labels:
    aadpodidbinding: ${IDENTITY_NAME}
spec:
  containers:
  - name: demo
    image: mcr.microsoft.com/oss/azure/aad-pod-identity/demo:v1.6.3
    args:
      - --subscriptionid=5053b074-62e4-469e-91a2-f56553bdfebb
      - --clientid=${IDENTITY_CLIENT_ID}
      - --resourcegroup=${IDENTITY_RESOURCE_GROUP}
    env:
      - name: MY_POD_NAME
        valueFrom:
          fieldRef:
            fieldPath: metadata.name
      - name: MY_POD_NAMESPACE
        valueFrom:
          fieldRef:
            fieldPath: metadata.namespace
      - name: MY_POD_IP
        valueFrom:
          fieldRef:
            fieldPath: status.podIP
  nodeSelector:

    kubernetes.io/os: linux
EOF

az aks command invoke -n $AKS -g $RG  -f demo.yaml -c 'kubectl apply -f demo.yaml'

1 main.go:73] failed list all vm, error: compute.VirtualMachinesClient#List: 

Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: 
Service returned an error. 
Status=403 
Code="AuthorizationFailed" 
Message="The client 'be5ee36c-6143-44ec-99d8-f9f70061cf75' 
with object id 'be5ee36c-6143-44ec-99d8-f9f70061cf75' 
does not have authorization to perform action 
'Microsoft.Compute/virtualMachines/read' over scope 
'/subscriptions/5053b074-62e4-469e-91a2-f56553bdfebb/resourceGroups/rg-spoke6385b445/providers/Microsoft.Compute' 






cat<<EOF|kubectl apply -f -
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kvname-podid
spec:
  provider: azure
  secretObjects:
  - secretName: testsecret
    type: Opaque                              
    data: 
    - objectName: mysecret
      key: datafield
  parameters:
    usePodIdentity: "true"               
    keyvaultName: ${KEYVAULT}    
    cloudName: ""                        
    objects:  |
      array:
        - |
          objectName: mysecret
          objectType: secret             
          objectVersion: ""              
    tenantId: ${TENANT}              
EOF

cat<<EOF|kubectl apply -f -
kind: Pod
apiVersion: v1
metadata:
  name: php
  labels:
    aadpodidbinding: $IDENTITY_NAME
spec:
  containers:
    - name: php
      image: tvdvoorde/php5000:2
      volumeMounts:
      - name: secrets-store01-inline
        mountPath: "/mnt/secrets-store"
        readOnly: true
      env:
      - name: SECRETVALUEFROMKEYVAULT
        valueFrom:
          secretKeyRef:
            name: testsecret
            key: datafield
  volumes:
    - name: secrets-store01-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "azure-kvname-podid"
EOF























































#######

https://azure.github.io/aad-pod-identity/docs/getting-started/role-assignment/


export RG=rg5
export AKS=aks5
export SUB=$(az account show --query "id" -o tsv)

echo $RG $AKS $SUB

az group create -g $RG -l westeurope
az aks create -n $AKS -g $RG --network-plugin=azure --network-policy=calico -c 3
az aks get-credentials -n $AKS -g $RG --overwrite-existing


export ID=$(az aks show -g $RG -n $AKS --query identityProfile.kubeletidentity.clientId -o tsv)
export NODE_RESOURCE_GROUP="$(az aks show -g ${RG} -n ${AKS} --query nodeResourceGroup -otsv)"

echo $ID $NODE_RESOURCE_GROUP

az role assignment create --role "Managed Identity Operator" --assignee $ID --scope /subscriptions/$SUB/resourcegroups/$NODE_RESOURCE_GROUP
az role assignment create --role "Virtual Machine Contributor" --assignee $ID --scope /subscriptions/$SUB/resourcegroups/$NODE_RESOURCE_GROUP


export IDENTITY_RESOURCE_GROUP=$RG-id
export IDENTITY_NAME=demo1138

echo $IDENTITY_RESOURCE_GROUP $IDENTITY_NAME

az group create -g ${IDENTITY_RESOURCE_GROUP} -l westeurope

az identity create -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME}

az role assignment create --role "Managed Identity Operator" --assignee $ID --scope /subscriptions/$SUB/resourcegroups/$IDENTITY_RESOURCE_GROUP


####

***IN TF UP TO HERE







export IDENTITY_CLIENT_ID="$(az identity show -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME} --query clientId -otsv)"
export IDENTITY_RESOURCE_ID="$(az identity show -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME} --query id -otsv)"

echo $IDENTITY_CLIENT_ID $IDENTITY_RESOURCE_ID

cat <<EOF | kubectl apply -f -
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: ${IDENTITY_NAME}
spec:
  type: 0
  resourceID: ${IDENTITY_RESOURCE_ID}
  clientID: ${IDENTITY_CLIENT_ID}
EOF

cat <<EOF | kubectl apply -f -
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: ${IDENTITY_NAME}-binding
spec:
  azureIdentity: ${IDENTITY_NAME}
  selector: ${IDENTITY_NAME}
EOF


cat<<EOF>demo.yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo
  labels:
    aadpodidbinding: $IDENTITY_NAME
spec:
  containers:
  - name: demo
    image: mcr.microsoft.com/oss/azure/aad-pod-identity/demo:v1.8.4
    args:
      - --subscription-id=${SUB}
      - --resource-group=${IDENTITY_RESOURCE_GROUP}
      - --identity-client-id=${IDENTITY_CLIENT_ID}
  nodeSelector:
    kubernetes.io/os: linux
EOF

kubectl apply -f demo.yaml

kubectl logs demo -f



export KEYVAULT_GROUP=$RG-key
export KEYVAULT=${RG}thx932920123

echo $KEYVAULT_GROUP $KEYVAULT

az group create -g $KEYVAULT_GROUP -l westeurope
az keyvault create --name $KEYVAULT -g $KEYVAULT_GROUP
az keyvault secret set --name MYSECRET --vault-name $KEYVAULT --value MYVALUE

az keyvault set-policy -n $KEYVAULT  --secret-permissions get list --object-id $IDENTITY_CLIENT_ID

az keyvault set-policy -n $KEYVAULT --secret-permissions get --spn $IDENTITY_CLIENT_ID

export TENANT=$(az account show --query "tenantId" -o tsv)


az aks enable-addons --addons azure-keyvault-secrets-provider --name $AKS  --resource-group $RG


cat<<EOF|kubectl apply -f -
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kvname-podid
spec:
  provider: azure
  secretObjects:
  - secretName: testsecret
    type: Opaque                              
    data: 
    - objectName: mysecret
      key: datafield
  parameters:
    usePodIdentity: "true"               
    keyvaultName: ${KEYVAULT}    
    cloudName: ""                        
    objects:  |
      array:
        - |
          objectName: mysecret
          objectType: secret             
          objectVersion: ""              
    tenantId: ${TENANT}              
EOF

cat<<EOF|kubectl apply -f -
kind: Pod
apiVersion: v1
metadata:
  name: php
  labels:
    aadpodidbinding: $IDENTITY_NAME
spec:
  containers:
    - name: php
      image: tvdvoorde/php5000:2
      volumeMounts:
      - name: secrets-store01-inline
        mountPath: "/mnt/secrets-store"
        readOnly: true
      env:
      - name: SECRETVALUEFROMKEYVAULT
        valueFrom:
          secretKeyRef:
            name: testsecret
            key: datafield
  volumes:
    - name: secrets-store01-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "azure-kvname-podid"
EOF






# Warning  SyncLoadBalancerFailed  2s (x3 over 18s)  service-controller  Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"AuthorizationFailed","message":"The client 'e84813c7-479f-4411-9918-ee85c8a9246b' with object id 'e84813c7-479f-4411-9918-ee85c8a9246b' does not have authorization to perform action 'Microsoft.Network/virtualNetworks/subnets/read' over scope '/subscriptions/c3ac18d2-bfb0-48fa-b91a-8c0570545869/resourceGroups/rg-spoke850e2d91/providers/Microsoft.Network/virtualNetworks/spoke850e2d91/subnets/spoke-subnet' or the scope is invalid. If access was recently granted, please refresh your credentials."}}
