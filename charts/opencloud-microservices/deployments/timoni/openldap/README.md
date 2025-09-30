# Install/Upgrade
kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/openldap && \
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/openldap/openldap.cue --runtime ./charts/opencloud-microservices/deployments/timoni/openldap/runtime.cue


