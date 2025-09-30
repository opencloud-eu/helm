# Install/Upgrade
kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/clamav && \
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/clamav/clamav.cue --runtime ./charts/opencloud-microservices/deployments/timoni/clamav/runtime.cue


