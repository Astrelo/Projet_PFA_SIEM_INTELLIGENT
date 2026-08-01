#!/bin/bash
# ===========================================
# Script de test des attaques
# Usage : bash test_attacks.sh <IP_CIBLE>
# Exécuter depuis Kali Linux
# ===========================================

TARGET=${1:-192.168.152.128}
echo "============================================"
echo "  SIEM PFA — Test des scénarios d'attaque"
echo "  Cible : $TARGET"
echo "============================================"

echo ""
echo "[1/5] Scan de ports TCP (nmap SYN)..."
nmap -sS -p 1-1000 --min-rate 5000 $TARGET
echo "→ Vérifier : journalctl -u ml-detection -f"

echo ""
echo "[2/5] Scan agressif OS detection..."
nmap -A -T4 $TARGET
echo "→ Vérifier : tail -f /var/log/snort/alert_fast.txt"

echo ""
echo "[3/5] Ping Flood ICMP (5 secondes)..."
timeout 5 hping3 --icmp --flood $TARGET 2>/dev/null || true
echo "→ Vérifier : journalctl -u ml-detection -f"

echo ""
echo "[4/5] SYN Flood port 22 (5 secondes)..."
timeout 5 hping3 -S --flood -p 22 $TARGET 2>/dev/null || true
echo "→ Vérifier : journalctl -u ml-detection -f"

echo ""
echo "[5/5] Trafic légitime HTTP..."
curl -s --connect-timeout 3 http://$TARGET > /dev/null \
  && echo "HTTP OK — aucune alerte attendue" \
  || echo "HTTP non disponible — normal si pas de serveur web"

echo ""
echo "============================================"
echo "  Tests terminés"
echo "  Kibana : http://$TARGET:5601"
echo "  Login  : elastic / wazuh123"
echo "============================================"
