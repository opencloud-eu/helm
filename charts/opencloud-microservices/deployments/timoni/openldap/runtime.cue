runtime: {
	apiVersion: "v1alpha1"
	name: "openldap"
	values: [
		{
			query: "k8s:v1:Secret:openldap:opencloud-ldap-secrets"
			for: {
				"LDAP_ADMIN_PASSWORD":    "obj.data.adminPassword"
				"LDAP_CONFIG_PASSWORD":   "obj.data.configPassword"
			}
		},
		{
			query: "k8s:v1:ConfigMap:openldap:opencloud-config"
			for: {
				"OPENLDAP_LTB_PASSWD_ENABLED": "obj.data.OPENLDAP_LTB_PASSWD_ENABLED"
				"OPENLDAP_REPLICATION_ENABLED": "obj.data.OPENLDAP_REPLICATION_ENABLED"
				"OPENLDAP_REPLICA_COUNT": "obj.data.OPENLDAP_REPLICA_COUNT"
				"LDAP_GLOBAL_DOMAIN": "obj.data.LDAP_GLOBAL_DOMAIN"
			}
		}
	]
	defaults: {
		LDAP_ADMIN_PASSWORD: "admin"
		LDAP_CONFIG_PASSWORD: "config"
		OPENLDAP_LTB_PASSWD_ENABLED: false
		OPENLDAP_REPLICATION_ENABLED: false
		OPENLDAP_REPLICA_COUNT: 1
		LDAP_GLOBAL_DOMAIN: "opencloud.eu"
	}
}
