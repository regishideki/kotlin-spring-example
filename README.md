# Simple example using Kotlin and Sprinng

## Running locally
```bash
docker-compose build && docker-compose up
```

## Running in Kubernetes
Building image. It is also possible to build with docker only but you need to provide the image name
```bash
TAG=v2
bash -c "docker build -t regishattori/kotlin-spring-example:$TAG ."
```

Testing if your image is working.
```bash
bash -c "docker run -p 80:8080 $(docker images | grep kotlin-spring-example | grep $TAG | awk '{print $3}')"
// in another shell
curl http://localhost/health
```
Pushing image to Docker Hub
```bash
bash -c "docker push regishattori/kotlin-spring-example:$TAG"
```
Making sure Minikube is runnning
```bash
minikube start
```
Changing image tag in deployments:
cp -a deploy/deployment.yaml deploy/deployment-tmp.yaml
bash -c "sed \"s/kotlin-spring-example:.*/kotlin-spring-example:$TAG/g\" deploy/deployment-tmp.yaml" > deploy/deployment.yaml
rm deploy/deployment-tmp.yaml

Running deployment
```bash
kubectl apply -f deploy/deployment.yaml --record
```

Analysing the deployment
```bash
kubectl rollout status deployment kotlin-spring-example-deployment
//or
kubectl get pod
```

Showing ingresses
```bash
kubectl get ingress | grep kotlin-spring-example-ingress
```

Configuring /etc/hosts (only the first time)
```bash
export host=$(kubectl get ingress | grep kotlin-spring-example-ingress | awk '{print $3}')
export address=$(kubectl get ingress | grep kotlin-spring-example-ingress | awk '{print $4}')
sudo sh -c "echo \"$address $host\" >> /etc/hosts"
```

Acessing the endpoint in Kubernets:
```bash
curl $host/health
```

## Troubleshooting
Listing pods
```bash
kubectl get pod
```

Showing pod logs
```bash
kubectl logs {pod-name}
```

Describing ingres
```bash
kubectl describe ingress kotlin-spring-example-ingress
```

Deleting everything
```bash
kubectl delete all --all && kubectl delete ingress kotlin-spring-example-ingress
```

