# 📖 Guide d'Installation Complet

## Prérequis Système

| Composant | Version | Machine |
|-----------|---------|---------|
| Debian | 13 | Serveur SIEM |
| Python | 3.11+ | Serveur SIEM |
| Wazuh | 4.x | Serveur SIEM |
| Elasticsearch | 8.x | Serveur SIEM |
| Kibana | 8.x | Serveur SIEM |
| Snort | 2.9+ | Serveur SIEM |
| pmacctd | 1.7+ | Serveur SIEM |
| Filebeat | 8.x | Serveur SIEM |

## Étape 1 — Environnement Python

```bash
# Créer l'environnement virtuel
python3 -m venv /opt/wazuh-ml/wazuh-ml-env
source /opt/wazuh-ml/wazuh-ml-env/bin/activate

# Installer les dépendances
pip install -r ml/requirements.txt
```

## Étape 2 — Dataset CICIDS2017

Télécharger depuis le site officiel :
https://www.unb.ca/cic/datasets/ids-2017.html

Fichiers nécessaires :
- Friday-WorkingHours-Afternoon-PortScan.pcap_ISCX.csv
- Friday-WorkingHours-Morning.pcap_ISCX.csv
- Thursday-WorkingHours-Morning-WebAttacks.pcap_ISCX.csv
- Monday-WorkingHours.pcap_ISCX.csv

Placer dans : `/home/user/datasets/CICIDS2017/CSVs/`

## Étape 3 — Entraîner le modèle

```bash
cd /opt/wazuh-ml
source wazuh-ml-env/bin/activate
python3 ml/train_model.py
```

Les modèles sont sauvegardés dans `/opt/wazuh-ml/models/`

## Étape 4 — Configurer Filebeat

```bash
cp config/filebeat.yml /etc/filebeat/filebeat.yml
systemctl restart filebeat
systemctl status filebeat
```

## Étape 5 — Configurer Snort

```bash
cp config/snort/local.rules /etc/snort/rules/local.rules
systemctl restart snort
```

## Étape 6 — Activer le service ML

```bash
cp config/systemd/ml-detection.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable ml-detection
systemctl start ml-detection
```

## Étape 7 — Vérification

```bash
# Vérifier tous les services
systemctl status ml-detection elasticsearch kibana filebeat

# Voir les détections ML en temps réel
journalctl -u ml-detection -f

# Voir les alertes Snort
tail -f /var/log/snort/alert_fast.txt

# Accéder à Kibana
# http://192.168.152.128:5601
# Login : elastic / wazuh123
```

## Tester le système

```bash
# Depuis Kali Linux
bash scripts/test_attacks.sh 192.168.152.128
```
