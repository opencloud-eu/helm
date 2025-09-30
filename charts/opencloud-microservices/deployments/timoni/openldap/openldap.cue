bundle: {
	apiVersion: "v1alpha1"
	name:       "openldap"
	instances: {
		"openldap": {
			module: {
				url:     "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
				version: "latest"
			}
			namespace: "openldap"
			values: {
				repository: {
					url: "https://jp-gouin.github.io/helm-openldap/"
				}
				chart: {
					name:    "openldap-stack-ha"
					version: "4.3.3"
				}
				sync: {
					timeout: 5
					createNamespace: true
				}
				helmValues: {
					"ltb-passwd": {
						enabled: bool @timoni(runtime:bool:OPENLDAP_LTB_PASSWD_ENABLED)
					}
					replication: {
						enabled: bool @timoni(runtime:bool:OPENLDAP_REPLICATION_ENABLED)
					}
					replicaCount: string @timoni(runtime:string:OPENLDAP_REPLICA_COUNT)
					global: {
						ldapDomain: string @timoni(runtime:string:LDAP_GLOBAL_DOMAIN)
						adminPassword: string @timoni(runtime:string:LDAP_ADMIN_PASSWORD)
						configPassword: string @timoni(runtime:string:LDAP_CONFIG_PASSWORD)
					}
					customLdifFiles: {
						"opencloud_root.ldif": """
							dn: dc=opencloud,dc=eu
							objectClass: organization
							objectClass: dcObject
							dc: opencloud
							o: openCloud

							dn: ou=users,dc=opencloud,dc=eu
							objectClass: organizationalUnit
							ou: users

							dn: cn=admin,dc=opencloud,dc=eu
							objectClass: inetOrgPerson
							objectClass: person
							cn: admin
							sn: admin

							dn: ou=groups,dc=opencloud,dc=eu
							objectClass: organizationalUnit
							ou: groups

							dn: ou=custom,ou=groups,dc=opencloud,dc=eu
							objectClass: organizationalUnit
							ou: custom
							"""
						"users.ldif": """
							"""
						"groups.ldif": """
							dn: cn=users,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: users
							dn: cn=chess-lovers,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: chess-lovers
							description: Chess lovers

							dn: cn=machine-lovers,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: machine-lovers
							description: Machine Lovers

							dn: cn=bible-readers,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: bible-readers
							description: Bible readers

							dn: cn=apollos,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: apollos
							description: Contributors to the Appollo mission

							dn: cn=unix-lovers,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: unix-lovers
							description: Unix lovers

							dn: cn=basic-haters,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: basic-haters
							description: Haters of the Basic programming language

							dn: cn=vlsi-lovers,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: vlsi-lovers
							description: Lovers of VLSI microchip design

							dn: cn=programmers,ou=groups,dc=opencloud,dc=eu
							objectClass: groupOfNames
							objectClass: top
							cn: programmers
							description: Computer Programmers
							"""
					}
					customSchemaFiles: {
						"10_opencloud_schema.ldif": """
							dn: cn=opencloud,cn=schema,cn=config
							objectClass: olcSchemaConfig
							cn: opencloud
							olcObjectIdentifier: openCloudOid 1.3.6.1.4.1.63016
							# We'll use openCloudOid:1 subarc for LDAP related stuff
							#   openCloudOid:1.1 for AttributeTypes and openCloudOid:1.2 for ObjectClasses
							olcAttributeTypes: ( openCloudOid:1.1.1 NAME 'openCloudUUID'
							  DESC 'A non-reassignable and persistent account ID)'
							  EQUALITY uuidMatch
							  SUBSTR caseIgnoreSubstringsMatch
							  SYNTAX 1.3.6.1.1.16.1 SINGLE-VALUE )
							olcAttributeTypes: ( openCloudOid:1.1.2 NAME 'openCloudExternalIdentity'
							  DESC 'A triple separated by "$" representing the objectIdentity resource type of the Graph API ( signInType $ issuer $ issuerAssignedId )'
							  EQUALITY caseIgnoreMatch
							  SUBSTR caseIgnoreSubstringsMatch
							  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
							olcAttributeTypes: ( openCloudOid:1.1.3 NAME 'openCloudUserEnabled'
							  DESC 'A boolean value indicating if the user is enabled'
							  EQUALITY booleanMatch
							  SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE)
							olcAttributeTypes: ( openCloudOid:1.1.4 NAME 'openCloudUserType'
							  DESC 'User type (e.g. Member or Guest)'
							  EQUALITY caseIgnoreMatch
							  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )
							olcAttributeTypes: ( openCloudOid:1.1.5 NAME 'openCloudLastSignInTimestamp'
							  DESC 'The timestamp of the last sign-in'
							  EQUALITY generalizedTimeMatch
							  ORDERING generalizedTimeOrderingMatch
							  SYNTAX  1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE )
							olcObjectClasses: ( openCloudOid:1.2.1 NAME 'openCloudObject'
							  DESC 'OpenCloud base objectclass'
							  AUXILIARY
							  MAY ( openCloudUUID ) )
							olcObjectClasses: ( openCloudOid:1.2.2 NAME 'openCloudUser'
							  DESC 'OpenCloud User objectclass'
							  SUP openCloudObject
							  AUXILIARY
							  MAY ( openCloudExternalIdentity $ openCloudUserEnabled $ openCloudUserType $ openCloudLastSignInTimestamp) )
							"""
					}
				}
			}
		},
	}
}
