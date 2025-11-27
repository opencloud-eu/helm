Addressed all action items from this issue in PR #102:

**Documentation added:**
- OC_EXCLUDE_RUN_SERVICES=idp,idm configuration for HA deployments
- External NATS configuration with TLS options
- Storage requirements (RWX volumes or external S3)
- Complete HA configuration example
- Prerequisites section listing all HA requirements

**Key findings:**
- `excludeServices` in values.yaml already supports this use case (defaults to ["idp"])
- External NATS configuration was already implemented but undocumented
- Updated misleading `opencloud.replicas` description

**Follow-up:**
- Created issue #101 to discuss auto-disabling embedded services when replicas > 1

Closing as documentation is complete.