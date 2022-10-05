docker run -it ubuntu bash

apt update -y
apt upgrade -y
apt install -y curl sudo jq
curl -sL https://aka.ms/InstallAzureCLIDeb | bash
sudo az aks install-cli

az login --use-device-code

export SUB=38861233-ed40-4746-b283-1cce97377342

az account set -s $SUB
az account show -o table

export AKS=$(az aks list --query '[].name' -o tsv)
export RG=$(az aks list --query '[].resourceGroup' -o tsv)

az aks get-credentials -n $AKS -g $RG --admin --overwrite-existing

kubectl get pods -A

kubectl get pods -A|grep -v -i "running"

kubectl get constrainttemplate

kubectl get AzureIdentity -A

kubectl logs deployment/application-gateway-kubernetes-ingress-ingress-azure -n agic-system

kubectl create namespace smoketest

kubectl create deployment nginx --image=nginx -n smoketest

kubectl expose deployment nginx --port=80 --type=ClusterIP -n smoketest

cat<<EOF >ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: smoketest
  labels:
    app.kubernetes.io/name: app
  annotations:
    appgw.ingress.kubernetes.io/backend-path-prefix: /
    appgw.ingress.kubernetes.io/connection-draining: "true"
    appgw.ingress.kubernetes.io/connection-draining-timeout: "30"
    appgw.ingress.kubernetes.io/ssl-redirect: "false"
    appgw.ingress.kubernetes.io/use-private-ip: "true"
    appgw.ingress.kubernetes.io/override-frontend-port: "80"
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  rules:
    - host: nginx.smoketest.local
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

kubectl delete AzureIngressProhibitedTarget prohibit-all-targets -n agic-system

# install AGIC 1.5.2
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash
helm ls -A
helm get values application-gateway-kubernetes-ingress -n agic-system -o yaml > values.yaml
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/ 
helm repo update 
helm upgrade application-gateway-kubernetes-ingress --install -n agic-system -f values.yaml application-gateway-kubernetes-ingress/ingress-azure --version 1.5.2

kubectl logs deployment/application-gateway-kubernetes-ingress-ingress-azure -n agic-system -f

kubectl apply -f ingress.yaml

kubectl logs deployment/application-gateway-kubernetes-ingress-ingress-azure -n agic-system -f

IP=$(kubectl get ingress nginx -n smoketest -o json|jq -r ".status.loadBalancer.ingress[0].ip")

kubectl run -it --rm test --image=nginx -- bash -c "curl http://${IP} -H 'Host: nginx.smoketest.local'"

cat <<EOF >ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: smoketest
  labels:
    app.kubernetes.io/name: app
  annotations:
    appgw.ingress.kubernetes.io/backend-path-prefix: /
    appgw.ingress.kubernetes.io/connection-draining: "true"
    appgw.ingress.kubernetes.io/connection-draining-timeout: "30"
    appgw.ingress.kubernetes.io/ssl-redirect: "false"
    appgw.ingress.kubernetes.io/use-private-ip: "false"
    appgw.ingress.kubernetes.io/override-frontend-port: "8080"
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  rules:
    - host: nginx.smoketest.local
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

kubectl apply -f ingress.yaml

kubectl logs deployment/application-gateway-kubernetes-ingress-ingress-azure -n agic-system -f

kubectl get ingress -A

openssl req -x509 -nodes -days 10 -newkey rsa:2048 -keyout cert.key -out cert.crt -subj "/C=NL/ST=Utrecht/L=Utrecht/O=IT/CN=smoketest.domain.local"
openssl pkcs12 -export -out cert.pfx -inkey cert.key -in cert.crt -password pass:Welcome1
kubectl create secret tls smoketest --cert=cert.crt --key=cert.key -n smoketest

cat <<EOF >ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: smoketest
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
      - nginx.smoketest.local
    secretName: smoketest
  rules:
    - host: nginx.smoketest.local
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

kubectl apply -f ingress.yaml

kubectl logs deployment/application-gateway-kubernetes-ingress-ingress-azure -n agic-system -f

kubectl run -it --rm test --image=nginx -- bash -c "curl -v -k https://${IP} -H 'Host: nginx.smoketest.local'"

export KVNAME=$(az keyvault list --query '[].name' -o tsv)
export KVRG=$(az keyvault list --query '[].resourceGroup' -o tsv)
export ID=$(az ad signed-in-user show --query 'id' -o tsv)

az keyvault set-policy --name $KVNAME --object-id $ID --secret-permissions all --key-permissions all --certificate-permissions all

az keyvault certificate import --file cert.pfx --name keyvaultcert --vault-name $KVNAME  --password Welcome1

export VSID=$(az keyvault certificate show -n keyvaultcert --vault-name  $KVNAME --query "sid" -o tsv)
export SID=$(echo $VSID | cut -d'/' -f-5) 
export IDP=$(az identity list --query "[?contains(name,'appgw')].principalId" -o tsv)

az keyvault set-policy -n $KVNAME -g $KVRG --object-id $IDP --secret-permissions get --certificate-permissions get

export GWNAME=$(az network application-gateway list --query '[].name' -o tsv)
export GWRG=$(az network application-gateway list --query '[].resourceGroup' -o tsv)

az network application-gateway ssl-cert create --resource-group $GWRG --gateway-name $GWNAME -n keyvaultcert --key-vault-secret-id $SID

cat<<EOF >ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: smoketest
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
    appgw.ingress.kubernetes.io/appgw-ssl-certificate: keyvaultcert
spec:
  rules:
    - host: nginx.smoketest.local
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

kubectl apply -f ingress.yaml

kubectl logs deployment/application-gateway-kubernetes-ingress-ingress-azure -n agic-system -f

kubectl run -it --rm test --image=nginx -- bash -c "curl -v -k https://${IP} -H 'Host: nginx.smoketest.local'"

az keyvault secret set --name keyvsecret --vault-name $KVNAME --value keyvsecretvalue

export AKSCLIENTID=$(az identity list -o table -g $RG --query '[].clientId' -o tsv)
export AKSID=$(az identity list -o table -g $RG --query '[].id' -o tsv)
export TENANTID=$(az account show --query 'tenantId' -o tsv)

cat <<EOF >ai.yaml
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: smoketest
  namespace: smoketest
spec:
  type: 0
  resourceID: ${AKSID}
  clientID: ${AKSCLIENTID}
EOF

cat <<EOF >aib.yaml
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: smoketest-binding
  namespace: smoketest
spec:
  azureIdentity: smoketest
  selector: smoketest
EOF

cat <<EOF >spc.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: smoketest-class
  namespace: smoketest
spec:
  provider: azure
  secretObjects:
  - secretName: akssecret
    type: Opaque                              
    data: 
    - objectName: keyvsecret
      key: datafield
  parameters:
    usePodIdentity: "true"               
    keyvaultName: ${KVNAME}
    cloudName: ""                        
    objects:  |
      array:
        - |
          objectName: keyvsecret
          objectType: secret             
          objectVersion: ""              
    tenantId: ${TENANTID}
EOF

cat <<EOF >pod.yaml
kind: Pod
apiVersion: v1
metadata:
  name: secrettest
  namespace: smoketest
  labels:
    aadpodidbinding: smoketest
spec:
  containers:
    - name: secrettest
      image: nginx
      volumeMounts:
      - name: secrets-store01-inline
        mountPath: "/mnt/secrets-store"
        readOnly: true
      env:
      - name: ENVAKSSECRET
        valueFrom:
          secretKeyRef:
            name: akssecret
            key: datafield
  volumes:
    - name: secrets-store01-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "smoketest-class"
EOF

kubectl apply -f ai.yaml

kubectl apply -f aib.yaml

kubectl apply -f spc.yaml

kubectl apply -f pod.yaml

kubectl get secrets -n smoketest

kubectl get secrets akssecret -n smoketest -o jsonpath='{.data.datafield}'|base64 -d

kubectl exec secrettest -it -n smoketest -- bash -c 'echo $ENVAKSSECRET'

kubectl exec secrettest -it -n smoketest -- bash -c 'cat /mnt/secrets-store/keyvsecret'

# clean up

kubectl delete -f pod.yaml
kubectl delete -f spc.yaml
kubectl delete -f aib.yaml
kubectl delete -f ai.yaml
kubectl delete ingress nginx -n smoketest
kubectl delete service nginx -n smoketest
kubectl delete deployment nginx -n smoketest
kubectl delete secret smoketest -n smoketest
kubectl delete namespace smoketest
az network application-gateway ssl-cert delete --resource-group $GWRG --gateway-name $GWNAME -n keyvaultcert
az keyvault certificate delete --name keyvaultcert --vault-name $KVNAME
az keyvault secret delete --name keyvsecret --vault-name $KVNAME
az keyvault delete-policy --name $KVNAME --object-id $ID 
az keyvault delete-policy --name $KVNAME --object-id $IDP 
