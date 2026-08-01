# 🏗️ Architecture Détaillée

## Vue d'ensemble

Le système repose sur deux pipelines de détection parallèles
qui s'envoient vers un backend Elasticsearch commun.

## Pipeline 1 — Snort IDS (Signatures)

Trafic réseau entrant
│
▼
Snort IDS
(analyse paquets vs règles local.rules)
│
▼
/var/log/snort/alert_fast.txt
│
▼
Filebeat
(input type: log)
│
▼
Elasticsearch index: snort-logs-YYYY.MM.DD
│
▼
Kibana


## Pipeline 2 — Random Forest (ML)

Trafic réseau entrant
│
▼
pmacctd
(capture flux CSV toutes les 10s)
│
▼
detect_netflow_fixed.py
(construit 78 features par flux)
│
▼
ids_model.joblib
(Random Forest 200 arbres)
│
▼
Alerte → journal systemd (ml-detection)
│
▼
Filebeat
(input type: journald)
│
▼
Elasticsearch index: ml-detection-YYYY.MM.DD
│
▼
Kibana


## Fichiers clés

| Fichier | Rôle |
|---------|------|
| `ml/train_model.py` | Entraînement one-shot du modèle |
| `ml/detect_netflow_fixed.py` | Détection temps réel en production |
| `models/ids_model.joblib` | Modèle Random Forest sérialisé |
| `models/scaler.joblib` | StandardScaler pour normalisation |
| `models/label_encoder.joblib` | Encodeur des classes |
| `models/feature_names.joblib` | Liste des 78 features |
| `config/filebeat.yml` | Collecte Snort + ML → Elasticsearch |
| `config/snort/local.rules` | Règles Snort personnalisées |
| `config/systemd/ml-detection.service` | Auto-démarrage du service ML |
| `config/pmacct/pmacctd.conf` | Capture flux réseau |
