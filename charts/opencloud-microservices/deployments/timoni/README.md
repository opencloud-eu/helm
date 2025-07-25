# Install

kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/ && \
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/opencloud.cue --runtime ./charts/opencloud-microservices/deployments/timoni/runtime.cue


