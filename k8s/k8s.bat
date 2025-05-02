kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl create configmap promtail-config --from-file=promtail-config.yml
kubectl apply -f promtail-deployment.yaml
kubectl get all