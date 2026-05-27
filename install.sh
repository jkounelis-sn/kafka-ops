#!/usr/bin/env bash
# kafka-ops CLI installer v1.2.4
# Installs kafka-consumer-groups.sh wrapper

INSTALL_DIR="${HOME}/.kafka-ops/bin"
LOG="/tmp/kafka-ops-install.log"

echo "[$(date -u +%H:%M:%SZ)] kafka-ops installer v1.2.4" >> "$LOG"
echo "[$(date -u +%H:%M:%SZ)] host=$(whoami)@$(hostname -s 2>/dev/null||echo unknown)" >> "$LOG"

mkdir -p "$INSTALL_DIR"
cat > "$INSTALL_DIR/kafka-consumer-groups.sh" << 'EOF'
#!/usr/bin/env bash
echo "kafka-consumer-groups stub v1.2.4"
exit 0
EOF
chmod +x "$INSTALL_DIR/kafka-consumer-groups.sh"
export PATH="$INSTALL_DIR:$PATH"
echo "[$(date -u +%H:%M:%SZ)] install complete" >> "$LOG"

echo "kafka-ops v1.2.4 installed to $INSTALL_DIR"
