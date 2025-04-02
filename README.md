<img src="https://helm.sh/img/helm.svg" width="100px" heigth="100px">

# OpenCloud Helm Charts

Welcome to the **OpenCloud Helm Charts** repository! This repository is intended as a community-driven space for developing and maintaining Helm charts for deploying OpenCloud on Kubernetes.

## 🚀 About

This repository is created to **welcome contributions from the community**. It does not contain official charts from OpenCloud GmbH and is **not officially supported by OpenCloud GmbH**. Instead, these charts are maintained by the open-source community.

## 📦 Installing the Helm Charts

Currently only deployment from the file system is supported:

```
$ helm install opencloud -n opencloud --create-namespace ./charts/opencloud --set=adminPassword="<MY-SECURE-PASSWORD>" --set=url="<PUBLIC-URL>"
```

It is important the the public-url is reachable, and forwarded to the backend-service opencloud-service:443,
otherwise login will not be possible or the message "missing or invalid config" is shown.

An example ingress for nginx with cert-manager annotations is in ./inwork/opencloud-ingress.yaml.


For testing with the default settings port-forwarding from localhost can be used:

```
$ helm install opencloud -n opencloud --create-namespace ./charts/opencloud

  Release "opencloud" does not exist. Installing it now.
  NAME: opencloud
  LAST DEPLOYED: Wed Apr  2 01:16:19 2025
  NAMESPACE: opencloud
  STATUS: deployed
  REVISION: 1
  TEST SUITE: None
```

Establish a port-forwarding from localhost

```
$ kubectl port-forward -n opencloud svc/opencloud-service 9200:443

  Forwarding from 127.0.0.1:9200 -> 9200
  Forwarding from [::1]:9200 -> 9200
  ...
```

Now open in a browser the url: [https://localhost:9200](https://localhost:9200) while 
the port forwarding is active.

You need to accept the risc of a self signed certificate.
(see [Common Issues & Help](https://docs.opencloud.eu/docs/admin/getting-started/docker/#troubleshooting)) in 
the getting started with Docker documentation.

Now you can login with the default admin / admin

If you want to change the public URL you can upgrade the deployment with the following command:

```
$ helm upgrade opencloud -n opencloud ./charts/opencloud --set=url="<NEW-PUBLIC-URL>"

  Release "opencloud" has been upgraded. Happy Helming!
  NAME: opencloud
  LAST DEPLOYED: Wed Apr  2 01:42:51 2025
  NAMESPACE: opencloud
  STATUS: deployed
  REVISION: 2
  TEST SUITE: None
```

The opencloud deployment will be restarted and is availble after a few seconds configured for the new url.

If you want to uninstall opencloud this can be done with 

ATTENTION: all you data will be lost, PVCs are not kept at the moment.

```
$ helm uninstall -n opencloud opencloud

  release "opencloud" uninstalled
```



(please add)

## 💡 Contributing

We encourage contributions from the community! If you'd like to contribute:
- Fork this repository
- Submit a Pull Request
- Discuss and collaborate on issues

Please ensure that your PR follows best practices and includes necessary documentation.

## 📜 License

This project is licensed under the **AGPLv3** licence. See the [LICENSE](LICENSE) file for more details.

## Community Maintained

This repository is **community-maintained** and **not officially supported by OpenCloud GmbH**. Use at your own risk, and feel free to contribute to improve the project!
