# 🛡️ SIEM Intelligent avec détection d'intrusion par Machine Learning

> **Projet de Fin d'Année (PFA)**  
> Développement d'un SIEM intelligent combinant un IDS basé sur les signatures (Snort) et un modèle de Machine Learning (Random Forest) pour améliorer la détection des attaques réseau.

---

## 📖 Présentation

Ce projet a pour objectif de concevoir une plateforme de supervision de sécurité capable de détecter les cyberattaques en combinant deux approches :

- **Snort IDS** pour détecter les attaques connues grâce à des signatures.
- **Random Forest** pour identifier les comportements anormaux grâce au Machine Learning.

Les événements de sécurité sont centralisés avec **Wazuh**, envoyés vers **Elasticsearch** et visualisés dans **Kibana**.

---

## 🎯 Objectifs

- Détecter les attaques réseau en temps réel.
- Comparer les performances de Snort et du Machine Learning.
- Centraliser les alertes dans un SIEM.
- Fournir une visualisation des événements dans Kibana.

---

## 🏗️ Architecture

```text
                Kali Linux (Attaquant)
                        │
                        ▼
              +----------------------+
              |  Serveur Debian 13   |
              |----------------------|
              | Snort IDS            |
              | pmacctd              |
              | Random Forest        |
              | Wazuh Manager        |
              | Elasticsearch        |
              | Kibana              |
              +----------------------+
                  ▲              ▲
                  │              │
        Windows Agent      Debian Agent
```

---

## 🛠️ Technologies utilisées

- Wazuh
- Elasticsearch
- Kibana
- Snort
- Filebeat
- pmacct
- Python
- Scikit-learn
- Random Forest
- VMware

---

## 📊 Résultats obtenus

- Détection des attaques réseau en moins de **10 secondes**.
- Accuracy du modèle : **100 %** sur le jeu de données de test.
- Détection des attaques :
  - Port Scan
  - SYN Flood
  - Ping Flood
  - Brute Force SSH

---

## 📂 Structure du projet

```text
Projet_PFA_SIEM_INTELLIGENT/
│
├── README.md
├── LICENSE
├── .gitignore
├── ml/
├── config/
├── docs/
└── scripts/
```

---

## 🚀 Installation

Le guide complet est disponible dans :

```
docs/installation.md
```

---

## 👨‍💻 Auteur

**Astrel ZALLA**

Master – Systèmes d'Information & Big Data

SupMTI

---

## 📄 Licence

Ce projet est distribué sous licence MIT.
