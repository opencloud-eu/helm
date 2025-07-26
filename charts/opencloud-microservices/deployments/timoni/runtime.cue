runtime: {
    apiVersion: "v1alpha1"
    name: "opencloud"
    values: [
        {
            query: "k8s:v1:Secret:opencloud:opencloud-ldap-secrets"
            for: {
                "LDAP_ADMIN_PASSWORD":    "obj.data.adminPassword"
                "LDAP_CONFIG_PASSWORD":   "obj.data.configPassword"
            }
        },
        {
            query: "k8s:v1:Secret:opencloud:opencloud-keycloak-admin-secrets"
            for: {
                "KEYCLOAK_ADMIN_PASSWORD": "obj.data.adminPassword"
            }
        },
        {
            query: "k8s:v1:Secret:opencloud:opencloud-amqp-secret"
            for: {
                "AMQP_URL":          "obj.data.amqpUrl"
            }
        },
        {
            query: "k8s:v1:Secret:opencloud:opencloud-onlyoffice-secrets"
            for: {
                "ONLYOFFICE_INBOX":   "obj.data.inbox"
                "ONLYOFFICE_OUTBOX":  "obj.data.outbox"
                "ONLYOFFICE_SESSION": "obj.data.session"
            }
        },
        {
            query: "k8s:v1:Secret:opencloud:opencloud-minio-secrets"
            for: {
                "MINIO_ROOT_PASSWORD": "obj.data.rootPassword"
            }
        },
        {
            query: "k8s:v1:Secret:opencloud:opencloud-keycloak-postgresql-secrets"
            for: {
                "KEYCLOAK_POSTGRESQL_PASSWORD": "obj.data.postgresqlPassword"
            }
        },
        {
            query: "k8s:v1:ConfigMap:opencloud:opencloud-config"
            for: {
                "EXTERNAL_DOMAIN":           "obj.data.EXTERNAL_DOMAIN"
                "KEYCLOAK_DOMAIN":           "obj.data.KEYCLOAK_DOMAIN"
                "MINIO_DOMAIN":              "obj.data.MINIO_DOMAIN"
                "MINIO_PERSISTENCE_SIZE":    "obj.data.MINIO_PERSISTENCE_SIZE"
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
                "OPENCLOUD_LOGGING_LEVEL": "obj.data.OPENCLOUD_LOGGING_LEVEL"
                "KEYCLOAK_ENABLED": "obj.data.KEYCLOAK_ENABLED"
                "MINIO_ENABLED": "obj.data.MINIO_ENABLED"
                "INGRESS_ENABLED": "obj.data.INGRESS_ENABLED"
                "INGRESS_CLASS_NAME": "obj.data.INGRESS_CLASS_NAME"
                "INGRESS_PROXY_BODY_SIZE": "obj.data.INGRESS_PROXY_BODY_SIZE"
                "GATEWAY_HTTPROUTE_ENABLED": "obj.data.GATEWAY_HTTPROUTE_ENABLED"
                "EXTERNAL_USER_MANAGEMENT_ENABLED": "obj.data.EXTERNAL_USER_MANAGEMENT_ENABLED"
                "EXTERNAL_USER_MANAGEMENT_ADMIN_UUID": "obj.data.EXTERNAL_USER_MANAGEMENT_ADMIN_UUID"
                "AUTOPROVISION_ACCOUNTS_ENABLED": "obj.data.AUTOPROVISION_ACCOUNTS_ENABLED"
                "AUTOPROVISION_ACCOUNTS_CLAIM_USER_NAME": "obj.data.AUTOPROVISION_ACCOUNTS_CLAIM_USER_NAME"
                "OIDC_USER_ID_CLAIM": "obj.data.OIDC_USER_ID_CLAIM"
                "OIDC_USER_ID_CLAIM_ATTRIBUTE_MAPPING": "obj.data.OIDC_USER_ID_CLAIM_ATTRIBUTE_MAPPING"
                "OIDC_ROLE_ASSIGNMENT_CLAIM": "obj.data.OIDC_ROLE_ASSIGNMENT_CLAIM"
                "LDAP_WRITEABLE": "obj.data.LDAP_WRITEABLE"
                "LDAP_INSECURE": "obj.data.LDAP_INSECURE"
                "LDAP_BIND_DN": "obj.data.LDAP_BIND_DN"
                "LDAP_USER_NAME_MATCH": "obj.data.LDAP_USER_NAME_MATCH"
                "LDAP_USER_SCHEMA_ID": "obj.data.LDAP_USER_SCHEMA_ID"
                "LDAP_GROUP_SCHEMA_ID": "obj.data.LDAP_GROUP_SCHEMA_ID"
                "APPS_INTEGRATION_ENABLED": "obj.data.APPS_INTEGRATION_ENABLED"
                "COLLABORA_ENABLED": "obj.data.COLLABORA_ENABLED"
                "COLLABORA_INSECURE": "obj.data.COLLABORA_INSECURE"
                "COLLABORA_DISABLE_PROOF": "obj.data.COLLABORA_DISABLE_PROOF"
                "COLLABORA_INGRESS_ENABLED": "obj.data.COLLABORA_INGRESS_ENABLED"
                "COLLABORA_INGRESS_CLASS_NAME": "obj.data.COLLABORA_INGRESS_CLASS_NAME"
                "COLLABORA_INGRESS_PROXY_BODY_SIZE": "obj.data.COLLABORA_INGRESS_PROXY_BODY_SIZE"
                "ONLYOFFICE_ENABLED": "obj.data.ONLYOFFICE_ENABLED"
                "ONLYOFFICE_DOMAIN": "obj.data.ONLYOFFICE_DOMAIN"
                "ONLYOFFICE_INSECURE": "obj.data.ONLYOFFICE_INSECURE"
                "ONLYOFFICE_DISABLE_PROOF": "obj.data.ONLYOFFICE_DISABLE_PROOF"
                "ONLYOFFICE_INGRESS_ENABLED": "obj.data.ONLYOFFICE_INGRESS_ENABLED"
                "SEARCH_EXTRACTOR_TYPE": "obj.data.SEARCH_EXTRACTOR_TYPE"
                "STORAGE_USERS_BACKEND_DRIVER": "obj.data.STORAGE_USERS_BACKEND_DRIVER"
                "WEB_OIDC_WEB_CLIENT_ID": "obj.data.WEB_OIDC_WEB_CLIENT_ID"
                "IDM_PERSISTENCE_ENABLED": "obj.data.IDM_PERSISTENCE_ENABLED"
                "IDM_PERSISTENCE_SIZE": "obj.data.IDM_PERSISTENCE_SIZE"
                "OCM_PERSISTENCE_ENABLED": "obj.data.OCM_PERSISTENCE_ENABLED"
                "OCM_PERSISTENCE_SIZE": "obj.data.OCM_PERSISTENCE_SIZE"
                "OPENLDAP_LTB_PASSWD_ENABLED": "obj.data.OPENLDAP_LTB_PASSWD_ENABLED"
                "OPENLDAP_REPLICATION_ENABLED": "obj.data.OPENLDAP_REPLICATION_ENABLED"
                "OPENLDAP_REPLICA_COUNT": "obj.data.OPENLDAP_REPLICA_COUNT"
                "OIDC_IDP_INSECURE": "obj.data.OIDC_IDP_INSECURE"
                "OC_HTTP_API_INSECURE": "obj.data.OC_HTTP_API_INSECURE"
                "NATS_PERSISTENCE_ENABLED": "obj.data.NATS_PERSISTENCE_ENABLED"
                "NATS_PERSISTENCE_SIZE": "obj.data.NATS_PERSISTENCE_SIZE"
                "SEARCH_PERSISTENCE_ENABLED": "obj.data.SEARCH_PERSISTENCE_ENABLED"
                "SEARCH_PERSISTENCE_SIZE": "obj.data.SEARCH_PERSISTENCE_SIZE"
                "STORAGE_SYSTEM_PERSISTENCE_ENABLED": "obj.data.STORAGE_SYSTEM_PERSISTENCE_ENABLED"
                "STORAGE_SYSTEM_PERSISTENCE_SIZE": "obj.data.STORAGE_SYSTEM_PERSISTENCE_SIZE"
                "STORAGE_USERS_PERSISTENCE_ENABLED": "obj.data.STORAGE_USERS_PERSISTENCE_ENABLED"
                "STORAGE_USERS_PERSISTENCE_SIZE": "obj.data.STORAGE_USERS_PERSISTENCE_SIZE"
                "THUMBNAILS_PERSISTENCE_ENABLED": "obj.data.THUMBNAILS_PERSISTENCE_ENABLED"
                "THUMBNAILS_PERSISTENCE_SIZE": "obj.data.THUMBNAILS_PERSISTENCE_SIZE"
                "WEB_PERSISTENCE_ENABLED": "obj.data.WEB_PERSISTENCE_ENABLED"
                "WEB_PERSISTENCE_SIZE": "obj.data.WEB_PERSISTENCE_SIZE"
                "ONLYOFFICE_PERSISTENCE_SIZE": "obj.data.ONLYOFFICE_PERSISTENCE_SIZE"
            }
        }
    ]
    defaults: {
        LDAP_ADMIN_PASSWORD: "admin"
        LDAP_CONFIG_PASSWORD: "config"
        AMQP_URL: "amqp://guest:Dd0SXIe1k9osdfjkmA0TK1bb1B1d38OFSb@localhost"
        MINIO_ROOT_PASSWORD: "opencloud-secret-key"
        ONLYOFFICE_INBOX: "Dd0SXIe1k9oCfdffgrfNmA0TK1bb1B1d38OFSb"
        ONLYOFFICE_OUTBOX: "Dd0SXIe1k9oCfdffgrfNmA0TK1bb1B1d38OFSb"
        ONLYOFFICE_SESSION: "Dd0SXIe1k9oCfdffgrfNmA0TK1bb1B1d38OFSb"
        KEYCLOAK_POSTGRESQL_PASSWORD: "keycloak"
        KEYCLOAK_ADMIN_PASSWORD: "admin"

        EXTERNAL_DOMAIN: "cloud.opencloud.test"
        KEYCLOAK_DOMAIN: "keycloak.opencloud.test"
        MINIO_DOMAIN: "minio.opencloud.test"
        LDAP_URI: "ldap://openldap.openldap.svc.cluster.local:389"
        OIDC_ISSUER_URI: "https://keycloak.opencloud.test/realms/openCloud"
        COLLABORA_URI: "https://collabora.opencloud.test"
        COLLABORA_ICON_URI: "https://collabora.opencloud.test/favicon.ico"
        WOPI_INGRESS_DOMAIN: "wopi.opencloud.test"
        WOPI_COLLABORA_TLS_HOST: "wopi-collabora.kube.opencloud.test"
        ONLYOFFICE_URI: "https://onlyoffice.opencloud.test"
        ONLYOFFICE_ICON_URI: "https://onlyoffice.opencloud.test/web-apps/apps/documenteditor/main/resources/img/favicon.ico"
        OPENCLOUD_WEB_URL: "https://www.opencloud.eu"
        LDAP_GLOBAL_DOMAIN: "opencloud.eu"

        OPENCLOUD_LOGGING_LEVEL: "debug"
        KEYCLOAK_ENABLED: true
        MINIO_ENABLED: true
        MINIO_PERSISTENCE_SIZE: "40Gi"
        ONLYOFFICE_DOMAIN: ""
        INGRESS_ENABLED: false
        INGRESS_CLASS_NAME: "nginx"
        INGRESS_PROXY_BODY_SIZE: "1024m"
        GATEWAY_HTTPROUTE_ENABLED: true
        EXTERNAL_USER_MANAGEMENT_ENABLED: true
        EXTERNAL_USER_MANAGEMENT_ADMIN_UUID: "0ab77e6d-23b4-4ba3-9843-a3b3efdcfc53"
        AUTOPROVISION_ACCOUNTS_ENABLED: true
        AUTOPROVISION_ACCOUNTS_CLAIM_USER_NAME: "sub"
        OIDC_USER_ID_CLAIM: "sub"
        OIDC_USER_ID_CLAIM_ATTRIBUTE_MAPPING: "username"
        OIDC_ROLE_ASSIGNMENT_CLAIM: "roles"
        LDAP_WRITEABLE: true
        LDAP_INSECURE: true
        LDAP_BIND_DN: "cn=admin,dc=opencloud,dc=eu"
        LDAP_USER_NAME_MATCH: "none"
        LDAP_USER_SCHEMA_ID: "openCloudUUID"
        LDAP_GROUP_SCHEMA_ID: "openCloudUUID"
        APPS_INTEGRATION_ENABLED: true
        COLLABORA_ENABLED: false
        COLLABORA_INSECURE: true
        COLLABORA_DISABLE_PROOF: false
        COLLABORA_INGRESS_ENABLED: false
        COLLABORA_INGRESS_CLASS_NAME: "nginx"
        COLLABORA_INGRESS_PROXY_BODY_SIZE: "1024m"
        ONLYOFFICE_ENABLED: true
        ONLYOFFICE_INSECURE: true
        ONLYOFFICE_DISABLE_PROOF: false
        ONLYOFFICE_INGRESS_ENABLED: false
        SEARCH_EXTRACTOR_TYPE: "tika"
        STORAGE_USERS_BACKEND_DRIVER: "decomposeds3"
        WEB_OIDC_WEB_CLIENT_ID: "web"
        IDM_PERSISTENCE_ENABLED: false
        OPENLDAP_LTB_PASSWD_ENABLED: false
        OPENLDAP_REPLICATION_ENABLED: false
        OPENLDAP_REPLICA_COUNT: 1

        OIDC_IDP_INSECURE: true
        OC_HTTP_API_INSECURE: true
        NATS_PERSISTENCE_ENABLED: true
        SEARCH_PERSISTENCE_ENABLED: true
        STORAGE_SYSTEM_PERSISTENCE_ENABLED: true
        STORAGE_USERS_PERSISTENCE_ENABLED: true
        THUMBNAILS_PERSISTENCE_ENABLED: true
        WEB_PERSISTENCE_ENABLED: true
        IDM_PERSISTENCE_SIZE: "10Gi"
        OCM_PERSISTENCE_ENABLED: false
        OCM_PERSISTENCE_SIZE: "1Gi"
        NATS_PERSISTENCE_SIZE: "10Gi"
        SEARCH_PERSISTENCE_SIZE: "10Gi"
        STORAGE_SYSTEM_PERSISTENCE_SIZE: "5Gi"
        STORAGE_USERS_PERSISTENCE_SIZE: "50Gi"
        THUMBNAILS_PERSISTENCE_SIZE: "10Gi"
        WEB_PERSISTENCE_SIZE: "1Gi"
        ONLYOFFICE_PERSISTENCE_SIZE: "2Gi"

        LDAP_ENABLED: true
        TIKA_ENABLED: true
        AUTOSCALING_ENABLED: false
        PERSISTENCE_ENABLED: true
        LOG_COLOR: false
        OIDC_INSECURE: true
        OC_HTTP_INSECURE: true
        REPLICAS: 1
        REPLICATION_ENABLED: false
        RESOURCES_CPU_REQUEST: "100m"
        RESOURCES_MEM_REQUEST: "128Mi"
        RESOURCES_CPU_LIMIT: "500m"
        RESOURCES_MEM_LIMIT: "512Mi"
    }
}
