# Fonteo 🌊

**Fonteo** est une application intelligente de suivi et de cartographie des sources d'eau. Elle récupère et affiche en temps réel les données IoT des sources, propose une cartographie interactive et permet d’analyser les caractéristiques minérales de l’eau. Les utilisateurs peuvent filtrer et explorer les informations selon différents critères pour mieux sélectionner les sources fiables.

---

## 🔹 Concept

L'idée de Fonteo est de centraliser les informations sur les sources d'eau pour :  

- Identifier les points d'eau fiables.
- Fournir des données précises et en temps réel.
- Offrir une interface intuitive pour explorer et comparer les sources.
- Permettre aux utilisateurs de contribuer et de signaler de nouvelles sources.

---

## 🔹 Fonctionnalités

- **Cartographie interactive**
- **Recherche et filtrage**
- **Informations détaillées sur chaque source**
- **Proposition de nouvelles sources**
- **Validation intelligente des noms de sources**

---

## 🔹 Technologies utilisées

- **Flutter / Dart** pour l'application mobile.  
- **HTTP & JSON** pour la récupération des données depuis Overpass API.  
- **Latlong2** pour la gestion des coordonnées géographiques.
- **Firebase** (Realtime Database et Firestore) pour stocker et synchroniser les données en temps réel.
- **Lottie** pour les animations interactives.
- **OpenRouteService (OPM)** pour calculer les itinéraires. 
- **Git & GitHub** pour le versioning.  
- **Capteurs IoT (température, pH, TDS…)** pour collecter les paramètres en temps réel.
- **Interface React externe** pour répertorier et insérer les données minérales (calcium, potassium, sodium…) des laboratoires d’analyse liées à chaque source d’eau.

---

## 🔹 Structure du projet

``
aqua_sense/
│
├─ assets/
│ ├─ animations
│ ├─ fonts
│ ├─ images
├─ lib/
│ ├─ methods
│ ├─ models/
│ │ └─ mesures.dart # Classe Mesures
│ │ └─ water_source.dart # Classe WaterSource
│ ├─ pages/
│ │ └─ home.dart # Page d'accueil
│ │ └─ map_page.dart # Carte interactive
│ │ └─ proposer_page.dart # Proposition de sources d'eau
│ │ └─ infos.dart # Page informative
│ ├─ widgets
│ └─ main.dart # Point d'entrée de l'application
├─ .env
├─ pubspec.yaml # Dépendances et configuration Flutter
└─ README.md
``

---

## 🔹 Lancer l'application

1. Cloner le repo :  
```bash
git clone https://github.com/AnisSfihi/Fonteo.git
cd Fonteo
