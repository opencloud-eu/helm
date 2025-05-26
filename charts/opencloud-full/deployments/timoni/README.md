# Install

kubectl apply -f ./charts/opencloud-full/deployments/timoni/ && \
timoni bundle apply -f ./charts/opencloud-full/deployments/timoni/opencloud.cue --runtime ./charts/opencloud-full/deployments/timoni/runtime.cue


