Preconfigures the nats kv streams used by opencloud:

1. `main-queue`
General-purpose message bus with unlimited messages, no max size, persistent (file), for long-term async communication.

2. `kv-*` JetStream Key-Value buckets for:
   * `kv-cache-userinfo` – short-lived in-memory cache
   * `kv-userlog`, `kv-eventhistory`, `kv-activitylog` – long-lived file-backed data
   * `kv-service-registry` – volatile service discovery info
   * `kv-proxy` – for sensitive key material (short-lived, memory storage)