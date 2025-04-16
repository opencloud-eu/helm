# OpenCloud Development Helm Chart

This Helm chart deploys a development version of OpenCloud using a single Docker container. It's designed for testing and development purposes, not for production use.

## Overview

This chart provides a simplified deployment of OpenCloud based on the Docker setup described in the [official documentation](https://docs.opencloud.eu/docs/admin/getting-started/docker). It offers:

- Simple, single-container deployment
- Persistent storage for OpenCloud data
- Minimal configuration requirements

## Prerequisites

- Kubernetes 1.16+
- Helm 3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

```bash
# Basic installation
helm install opencloud -n opencloud --create-namespace ./charts/opencloud-dev

# Custom installation with specific admin password and URL
helm install opencloud -n opencloud --create-namespace ./charts/opencloud-dev \
  --set adminPassword="securePassword" \
  --set url="https://cloud.example.com"
```

## Accessing OpenCloud

For local testing with default settings, use port-forwarding:

```bash
kubectl port-forward -n opencloud svc/opencloud-service 9200:443
```

Then access OpenCloud at: https://localhost:9200

Default login credentials: admin / admin

## Configuration

See the [values.yaml](values.yaml) file for configuration options. The main parameters are:

- `image`: OpenCloud image (repository and tag)
- `adminPassword`: Admin user password
- `url`: Public URL for OpenCloud
- `insecure`: Allow self-signed certificates
- `pvcSize`: Size of the persistent volume claim

## More Information

For more detailed information, please refer to the [main repository README](../../README.md).