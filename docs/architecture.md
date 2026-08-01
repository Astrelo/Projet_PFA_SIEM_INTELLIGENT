# 🏗️ Architecture du système

## Vue d'ensemble

L'architecture du projet repose sur deux mécanismes complémentaires de détection des intrusions :

- **Pipeline 1 : Snort IDS**, qui détecte les attaques connues grâce à des règles de signatures.
- **Pipeline 2 : Machine Learning (Random Forest)**, qui identifie les comportements anormaux à partir des flux réseau.

Les événements générés par ces deux pipelines sont centralisés dans **Elasticsearch** puis visualisés à travers **Kibana**, offrant une plateforme unique de supervision et d'analyse des incidents de sécurité.

---

## Pipeline 1 — Détection par signatures (Snort IDS)

Le premier pipeline repose sur **Snort**, un système de détection d'intrusion (IDS) basé sur des signatures. Les paquets réseau sont analysés en temps réel et comparés aux règles définies dans `local.rules`. Les alertes générées sont collectées par Filebeat puis envoyées vers Elasticsearch afin d'être consultées dans Kibana.

```text
Trafic réseau
      │
      ▼
  Snort IDS
(Analyse des paquets)
      │
      ▼
alert_fast.txt
      │
      ▼
   Filebeat
      │
      ▼
Elasticsearch
(snort-logs-*)
      │
      ▼
    Kibana
```

---

## Pipeline 2 — Détection par Machine Learning

Le second pipeline est basé sur un modèle **Random Forest** entraîné à partir du jeu de données **CICIDS2017**.

Les flux réseau sont capturés par **pmacctd**, transformés en caractéristiques (features), puis analysés par le modèle afin de déterminer si le trafic est légitime ou malveillant. Les résultats sont enregistrés dans les journaux système, collectés par Filebeat et transmis à Elasticsearch pour être visualisés dans Kibana.

```text
Trafic réseau
      │
      ▼
   pmacctd
(Capture des flux)
      │
      ▼
detect_netflow_fixed.py
(Extraction des features)
      │
      ▼
Random Forest
(ids_model.joblib)
      │
      ▼
Journal systemd
(ml-detection)
      │
      ▼
   Filebeat
      │
      ▼
Elasticsearch
(ml-detection-*)
      │
      ▼
    Kibana
```

---

# 📁 Fichiers principaux

| Fichier | Description |
|---------|-------------|
| `ml/train_model.py` | Entraîne le modèle Random Forest à partir du jeu de données CICIDS2017. |
| `ml/detect_netflow_fixed.py` | Analyse les flux réseau en temps réel et applique le modèle entraîné. |
| `models/ids_model.joblib` | Modèle Random Forest sérialisé utilisé pour la détection. |
| `models/scaler.joblib` | Objet `StandardScaler` utilisé pour normaliser les données d'entrée. |
| `models/label_encoder.joblib` | Encodeur des différentes classes d'attaques détectées. |
| `models/feature_names.joblib` | Liste des caractéristiques (features) utilisées par le modèle. |
| `config/filebeat.yml` | Configuration de Filebeat pour la collecte et l'envoi des journaux vers Elasticsearch. |
| `config/snort/local.rules` | Ensemble des règles personnalisées utilisées par Snort. |
| `config/systemd/ml-detection.service` | Service systemd permettant de lancer automatiquement le module de détection au démarrage. |
| `config/pmacct/pmacctd.conf` | Configuration de pmacctd pour la capture des flux réseau. |

---

## Flux global du système

```text
                    Trafic réseau
                          │
             ┌────────────┴────────────┐
             │                         │
             ▼                         ▼
        Snort IDS                 pmacctd
             │                         │
             ▼                         ▼
     Alertes Snort          Module Machine Learning
             │                         │
             └────────────┬────────────┘
                          ▼
                      Filebeat
                          │
                          ▼
                   Elasticsearch
                          │
                          ▼
                       Kibana
```
