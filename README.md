# Fonteo 🌊

**Fonteo** is an intelligent water source tracking and mapping application. It collects and displays IoT data from water sources in real time, offers an interactive map, and allows users to analyze the mineral characteristics of the water. Users can filter and explore the information based on various criteria to better select reliable sources.

---

## 🔹 Concept

The idea behind Fonteo is to centralize information about water sources in order to: 

- Identify reliable water points.
- Provide accurate, real-time data.
- Offer an intuitive interface to explore and compare sources.
- Allow users to contribute and report new sources.

---

## 🔹 Features

- **Interactive mapping**
- **Search and filtering**
- **Detailed information on each source**
- **Suggestion of new sources**
- **Intelligent validation of source names**

---

## 🔹 Technologies Used

- **Flutter / Dart** for the mobile application.  
- **HTTP & JSON** for fetching data from the Overpass API.  
- **Latlong2** for managing geographic coordinates.
- **Firebase** (Realtime Database and Firestore) to store and synchronize data in real time.
- **Lottie** for interactive animations.
- **OpenRouteService (OPM)** to calculate routes.  
- **IoT sensors (Temperature, pH, TDS, etc.)** to collect real-time water's parameters.
- **External React interface** to catalog and input mineral data (calcium, potassium, sodium, etc.) from analysis laboratories linked to each water source.

---

## 🔹 Project Structure

```
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
│ │ └─ home.dart # Home page
│ │ └─ map_page.dart # Interactive map
│ │ └─ proposer_page.dart # Water source suggestion page
│ │ └─ infos.dart # Information page
│ ├─ widgets
│ └─ main.dart # Application entry point
├─ .env
├─ pubspec.yaml # Flutter dependencies and configuration
└─ README.md
```

---

## 🔹 Running the Application

1. Clone the repo:  
```bash
git clone https://github.com/AnisSfihi/Fonteo.git
cd Fonteo
