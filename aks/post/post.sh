az login
az account set -s "e2c1b56d-a413-43fc-b1e2-f73e153c05ad"
az aks get-credentials --resource-group aks-resources --name aks-test1
kubelogin convert-kubeconfig -l azurecli
kubectl get no

cat <<EOF >/tmp/nginx.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 6
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
      tolerations:
      - key: "CriticalAddonsOnly"
        operator: "Exists"
        effect: "NoSchedule"
EOF

kubectl apply -f /tmp/nginx.yaml
kubectl get pods