# Using OpenCloud DEV Helm Charts with Rancher Desktop on macOS

This guide shows you how to set up a local Kubernetes environment on macOS using Rancher Desktop for developing and testing the OpenCloud DEV Helm chart.

## Prerequisites

1. A macOS system (tested on macOS Sequoia 15.4)
2. Homebrew package manager

## Local Kubernetes Options for macOS

There are several options for running Kubernetes locally on macOS:

- **Rancher Desktop**: Recommended for its simplicity and good performance (this guide)
- **Docker Desktop**: Works well but requires a paid subscription for business use
- **minikube**: Good alternative, slightly more resource-intensive
- **k3d**: Lightweight option, excellent for limited resources

## Setting Up Rancher Desktop

```bash
# Install Rancher Desktop using Homebrew
brew install --cask rancher
```

1. Launch Rancher Desktop
2. In Preferences:
   - Choose Kubernetes version (tested with 1.32.3)
   - Set Container Engine to "moby" (Docker API compatible)
   - Enable Kubernetes
   - Allow Kubernetes to start completely

## Installing OpenCloud DEV Chart

```bash
# Create namespace for OpenCloud
kubectl create namespace opencloud

# Install the OpenCloud DEV chart
helm install opencloud -n opencloud ./opencloud-dev

# Watch the pod status until it's ready
kubectl get pods -n opencloud -w
```

## Accessing OpenCloud

Set up port forwarding to access the OpenCloud instance:

```bash
kubectl port-forward -n opencloud svc/opencloud-service 9200:443
```

Now access OpenCloud at [https://localhost:9200](https://localhost:9200) in your browser.
You'll need to accept the security risk from the self-signed certificate.

Login with:
- Username: `admin`
- Password: `admin`

## Monitoring and Debugging

```bash
# View logs from the OpenCloud pod
kubectl logs -n opencloud -l app=opencloud -f

# See the pod details
kubectl describe pod -n opencloud -l app=opencloud

# Access Kubernetes dashboard through Rancher Desktop UI
# (Click Dashboard button in Rancher Desktop)
```

## Clean Up

```bash
# Uninstall OpenCloud
helm uninstall -n opencloud opencloud

# Delete namespace (optional - PVCs with keep policy will survive)
kubectl delete namespace opencloud
```

## Tested Configuration

This guide has been tested with:
- macOS Sequoia 15.4
- Rancher Desktop 1.18.2
- Kubernetes 1.32.3
- Container Engine: moby
- OpenCloud DEV chart version 0.1.0
- OpenCloud version 2.0.0

## Troubleshooting

- **TLS/Certificate Issues**: The self-signed certificates will show warnings in browsers. This is expected in development environments.
- **Port Conflicts**: If port 9200 is already in use, change the port-forward command to use a different local port.
- **Performance**: For better performance, consider adjusting the resources allocated to Rancher Desktop in its preferences.
- **Dashboard Access**: Rancher Desktop provides a built-in Kubernetes dashboard for easier debugging.
- **Log Collection**: If you encounter issues, collect logs with `kubectl logs -n opencloud -l app=opencloud > opencloud.log`

## Comparison with Other Local Kubernetes Options

| Feature | Rancher Desktop | Docker Desktop | minikube | k3d |
|---------|----------------|----------------|----------|-----|
| Installation | Simple | Simple | Simple | Simple |
| Resource Usage | Moderate | Moderate | High | Low |
| Dashboard | Built-in | Needs add-on | Needs add-on | Needs add-on |
| Docker API | Yes | Yes | Via plugin | Via plugin |
| Cost | Free | Paid for business | Free | Free |
| ARM Mac support | Good | Good | Good | Good |
| Intel Mac support | Good | Good | Good | Good |

For most users developing with OpenCloud DEV helm charts, Rancher Desktop provides the best balance of features, performance, and ease of use.