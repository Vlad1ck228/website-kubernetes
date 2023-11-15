minikube start --driver=virtualbox --no-vtx-check --cpus 2 --memory 2048 --disk-size=10gb

$ImageName = "vladhl/mywebsite"

@"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web-container
        image: $ImageName
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: NodePort
"@ | Out-File -FilePath manifest.yaml -Encoding utf8

kubectl apply -f manifest.yaml

minikube service web-service --url
