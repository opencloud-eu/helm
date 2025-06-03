<img src="https://helm.sh/img/helm.svg" width="100px" heigth="100px">

# OpenCloud Development Helm Chart

This Helm chart deploys a lightweight development version of OpenCloud using a single Docker container.

## 📑 Table of Contents

- [About](#-about)
- [Prerequisites](#prerequisites)
- [Installation](#-installation)
- [Configuration](#configuration)
- [Port Forwarding](#port-forwarding)
- [License](#-license)

## 🚀 About

This development chart provides a simplified OpenCloud deployment for testing and development purposes. 
It uses a single Docker container that includes all necessary OpenCloud services bundled together.

**Note:** This chart is NOT intended for production use. For production deployments, 
please use the main [OpenCloud Helm Chart](../opencloud/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## 📦 Installation

To install the chart with the release name `opencloud`:

```bash
# Navigate to the chart directory first
cd /path/to/helm-repo/charts/opencloud-dev

# Then run the installation command
helm install opencloud . \
  --namespace opencloud \
  --create-namespace \
  --set adminPassword="<MY-SECURE-PASSWORD>" \
  --set url="<PUBLIC-URL>"
```

Alternatively, from the repository root:

```bash
helm install opencloud ./charts/opencloud-dev \
  --namespace opencloud \
  --create-namespace \
  --set adminPassword="<MY-SECURE-PASSWORD>" \
  --set url="<PUBLIC-URL>"
```

**Important Notes:**
- The `url` parameter must be reachable and forwarded to the backend service on port 443
- If `url` is not properly configured, login will fail with "missing or invalid config" message

## Configuration

The following table lists the configurable parameters of the OpenCloud Development chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image` | OpenCloud image repository | `opencloudeu/opencloud-rolling` |
| `tag` | OpenCloud image tag | `2.0.0` |
| `adminPassword` | Admin password | `admin` |
| `insecure` | Insecure mode (for self-signed certificates) | `true` |
| `proxyHttpAddr` | Proxy HTTP address | `0.0.0.0:9200` |
| `url` | Public URL for OpenCloud | `https://localhost:9200` |
| `pvcSize` | Persistent volume size | `10Gi` |

## Port Forwarding

For local testing with default settings, you can use port-forwarding:

```bash
# After installation
kubectl port-forward -n opencloud svc/opencloud-service 9200:443
```

Then access OpenCloud at [https://localhost:9200](https://localhost:9200) and login with:
- Username: admin
- Password: admin (or your custom password if set)

You will need to accept the self-signed certificate warning in your browser.

## Upgrading

To change the public URL or other settings, you can upgrade the deployment:

```bash
helm upgrade opencloud . \
  --namespace opencloud \
  --set url="<NEW-PUBLIC-URL>"
```

## Uninstalling

To uninstall OpenCloud:

```bash
helm uninstall -n opencloud opencloud
```

**Note:** The data PVC is configured to be kept, so it will survive uninstall and reinstall of the chart.

## 📜 License

This project is licensed under the **AGPLv3** license. See the [LICENSE](../../LICENSE) file for more details.