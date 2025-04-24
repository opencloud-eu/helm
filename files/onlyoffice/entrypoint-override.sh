#!/bin/sh
set -e

# Create a writable directory for the configuration
mkdir -p /tmp/onlyoffice/documentserver


exec /app/ds/run-document-server.sh
