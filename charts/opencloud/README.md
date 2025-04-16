# OpenCloud Helm Chart

This Helm chart deploys OpenCloud with optional components like Keycloak, MinIO, and document editors (OnlyOffice and Collabora).

## Overview

OpenCloud is a cloud collaboration platform that provides file sync and share, document collaboration, and more. 
This chart deploys a complete OpenCloud environment with the following components:

- OpenCloud Core
- Keycloak for authentication
- PostgreSQL database for Keycloak and OnlyOffice
- MinIO for S3-compatible object storage
- Document editors (OnlyOffice and/or Collabora)
- Collaboration service for document editing

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- Gateway API controller for routing traffic (compatible with Gateway API v1beta1)

## Installing the Chart

```bash
helm install opencloud -n opencloud ./charts/opencloud \
  --set global.domain.opencloud=cloud.example.com \
  --set global.domain.keycloak=keycloak.example.com \
  --set httproute.gateway.name=my-gateway \
  --set httproute.gateway.namespace=gateway-system
```

## Configuration

See the [values.yaml](values.yaml) file for detailed configuration options.

### Important Security Note

This chart comes with default credentials that **MUST be changed** for production environments:

- Keycloak admin: `admin/admin`
- OpenCloud admin: `admin/admin`
- PostgreSQL: `keycloak/keycloak`
- MinIO: `opencloud/opencloud-secret-key`
- OnlyOffice Secret Keys

## More Information

For more detailed information, please refer to the [main repository README](../../README.md).