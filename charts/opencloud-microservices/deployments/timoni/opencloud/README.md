# Install/Upgrade
kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/opencloud && \
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/opencloud/opencloud.cue --runtime ./charts/opencloud-microservices/deployments/timoni/opencloud/runtime.cue


