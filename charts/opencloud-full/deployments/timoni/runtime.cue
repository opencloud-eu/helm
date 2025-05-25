runtime: {
    apiVersion: "v1alpha1"
    name: "opencloud"
    values: [
        {
            query: "k8s:v1:ConfigMap:opencloud:opencloud-config"
            for: {
                "EXTERNAL_DOMAIN":           "obj.data.EXTERNAL_DOMAIN"
                "KEYCLOAK_DOMAIN":           "obj.data.KEYCLOAK_DOMAIN"
                "MINIO_DOMAIN":              "obj.data.MINIO_DOMAIN"
                "LDAP_URI":                  "obj.data.LDAP_URI"
                "OIDC_ISSUER_URI":           "obj.data.OIDC_ISSUER_URI"
                "COLLABORA_URI":             "obj.data.COLLABORA_URI"
                "COLLABORA_ICON_URI":        "obj.data.COLLABORA_ICON_URI"
                "WOPI_INGRESS_DOMAIN":       "obj.data.WOPI_INGRESS_DOMAIN"
                "WOPI_COLLABORA_TLS_HOST":   "obj.data.WOPI_COLLABORA_TLS_HOST"
                "ONLYOFFICE_URI":            "obj.data.ONLYOFFICE_URI"
                "ONLYOFFICE_ICON_URI":       "obj.data.ONLYOFFICE_ICON_URI"
                "OPENCLOUD_WEB_URL":         "obj.data.OPENCLOUD_WEB_URL"
                "LDAP_GLOBAL_DOMAIN":        "obj.data.LDAP_GLOBAL_DOMAIN"
            }
        }
    ]
    defaults: {
        "EXTERNAL_DOMAIN": "cloud.opencloud.test"
        "KEYCLOAK_DOMAIN": "keycloak.opencloud.test"
        "MINIO_DOMAIN": "minio.opencloud.test"
        "LDAP_URI": "ldap://openldap.openldap.svc.cluster.local:389"
        "OIDC_ISSUER_URI": "https://keycloak.opencloud.test/realms/openCloud"
        "COLLABORA_URI": "https://collabora.opencloud.test"
        "COLLABORA_ICON_URI": "https://collabora.opencloud.test/favicon.ico"
        "WOPI_INGRESS_DOMAIN": "wopi.opencloud.test"
        "WOPI_COLLABORA_TLS_HOST": "wopi-collabora.kube.opencloud.test"
        "ONLYOFFICE_URI": "https://onlyoffice.opencloud.test"
        "ONLYOFFICE_ICON_URI": "https://onlyoffice.opencloud.test/web-apps/apps/documenteditor/main/resources/img/favicon.ico"
        "OPENCLOUD_WEB_URL": "https://www.opencloud.com"
        "LDAP_GLOBAL_DOMAIN": "opencloud.eu"
    }
}
