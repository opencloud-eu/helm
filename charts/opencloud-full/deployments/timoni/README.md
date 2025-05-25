# Install

kubectl apply -f ./charts/opencloud-full/deployment/timoni/ && \
timoni bundle apply -f ./charts/opencloud-full/deployment/timoni/opencloud.cue --runtime ./charts/opencloud-full/deployment/timoni/runtime.cue


