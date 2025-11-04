import 'package:flutter/material.dart';

// Bloc "Le saviez-vous" — slider d'information
// Présente des cartes d'information courtes destinées à expliquer
// le fonctionnement et les objectifs de l'application (qualité de l'eau,
// analyse des données, interface). Commentaires brefs et explicatifs seulement.

class LeSaviezVousSlider extends StatelessWidget {
  const LeSaviezVousSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titre principal
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              "💧 Le saviez-vous ? 💧",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "MontserratBold",
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
      
          // Bloc d'information : système intelligent
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "🌍 Un système intelligent au service de l’eau",
                    style: TextStyle(
                      fontFamily: "MontserratBold",
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Notre application utilise des capteurs et des cartes intelligentes pour détecter les sources d'eau autour de vous. Elle recueille des données comme le pH, la température, ou encore la turbidité pour évaluer la qualité de l’eau.",
                    style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
      
          // Bloc d'information : analyse et présentation des données
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "📊 Des données pour mieux comprendre",
                    style: TextStyle(
                      fontFamily: "MontserratBold",
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Les résultats sont analysés automatiquement et présentés de manière simple. Vous pouvez consulter les minéraux présents, l’origine potentielle des polluants, et obtenir des conseils sur la potabilité.",
                    style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
      
          // Bloc d'information : interface et carte interactive
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "📱 Une interface intuitive",
                    style: TextStyle(
                      fontFamily: "MontserratBold",
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Grâce à une carte interactive, vous pouvez localiser facilement les sources autour de vous, consulter les mesures en temps réel, et accéder à une fiche complète pour chaque point d’eau.",
                    style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
      
          SizedBox(height: 20),
      
          // Phrase finale résumant l'objectif
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "L’objectif : rendre accessible à tous une eau de qualité, en alliant technologie, écologie et simplicité.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "MontserratBold",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
      
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
