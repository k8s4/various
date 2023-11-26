eval $(minikube docker-env)
docker build . --tag "test"
kubectl apply -f test.yml

kubectl expose deployment test --type=NodePort --port 5000
minikube service test --url

