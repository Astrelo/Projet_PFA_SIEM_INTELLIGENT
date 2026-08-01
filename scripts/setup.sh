#!/bin/bash
# ===========================================
# Script d'installation automatique
# Exécuter sur le serveur SIEM (Debian 13)
# ===========================================

echo "=== Installation SIEM Intelligent PFA ==="

# Créer les dossiers
mkdir -p /opt/wazuh-ml/models
mkdir -p /opt/wazuh-ml/pmacct

# Environnement Python
echo "→ Création environnement Python..."
python3 -m venv /opt/wazuh-ml/wazuh-ml-env
source /opt/wazuh-ml/wazuh-ml-env/bin/activate
pip install -r ml/requirements.txt --quiet

# Copier les fichiers ML
echo "→ Copie des fichiers ML..."
cp ml/train_model.py /opt/wazuh-ml/
cp ml/detect_netflow_fixed.py /opt/wazuh-ml/

# Configurer Filebeat
echo "→ Configuration Filebeat..."
cp config/filebeat.yml /etc/filebeat/filebeat.yml
systemctl restart filebeat

# Configurer Snort
echo "→ Configuration Snort..."
cp config/snort/local.rules /etc/snort/rules/local.rules

# Configurer pmacctd
echo "→ Configuration pmacctd..."
cp config/pmacct/pmacctd.conf /opt/wazuh-ml/pmacct/

# Activer service ML
echo "→ Activation service ML..."
cp config/systemd/ml-detection.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable ml-detection

echo ""
echo "=== Installation terminée ==="
echo "Entraîner le modèle : python3 /opt/wazuh-ml/train_model.py"
echo "Démarrer le service : systemctl start ml-detection"
echo "Voir les logs       : journalctl -u ml-detection -f"
