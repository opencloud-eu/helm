# Install/Upgrade
This are the cli commands to install with timoni (fluxcd) the opencloud, openldap and clamav

## Install opencloud
kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/opencloud && \
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/opencloud/opencloud.cue --runtime ./charts/opencloud-microservices/deployments/timoni/opencloud/runtime.cue

## Install openldap
kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/openldap && \
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/openldap/openldap.cue --runtime ./charts/opencloud-microservices/deployments/timoni/openldap/runtime.cue

## Install clamav
kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/clamav && \
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/clamav/clamav.cue --runtime ./charts/opencloud-microservices/deployments/timoni/clamav/runtime.cue


