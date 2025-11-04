import 'package:flutter/material.dart';

// Slider des paramètres physico-chimiques
//
// Présente des cartes déroulantes pour chaque paramètre (pH, TDS, turbidité,
// température, ...). Chaque carte contient :
// - une valeur de référence,
// - une courte description de l'impact sur la qualité de l'eau,
// - un encart conseil/avertissement.
//
// Style : commentaires courts et sections clairement séparées pour rester
// cohérent avec les autres widgets d'information.
/// Widget affichant les paramètres physico-chimiques de l'eau dans des cartes déroulantes
/// Chaque carte présente une valeur de référence, une description et un conseil
class ParametreInfosSlider extends StatelessWidget {
  const ParametreInfosSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // Cartes des paramètres avec valeurs de référence et infos importantes
        children: [
          // pH : plage idéale 6.5-8.5, impact sur les canalisations et le goût
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.science, color: Colors.blue, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "pH de l'eau",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Affichage de la valeur de référence avec icône
                          Row(
                            children: [
                              Icon(Icons.water_drop, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                "Valeur idéale : entre 6.5 et 8.5",
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Le pH mesure l'acidité de l'eau. Un pH trop acide peut corroder les canalisations, tandis qu’un pH trop basique peut affecter le goût et la digestion.",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Zone d'info/conseil avec fond coloré et icône
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "💡 L’eau du robinet en Algérie a un pH moyen de 7.5",
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          // TDS : minéraux dissous, max 500mg/L, indicateur de pollution si élevé
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.speed, color: Colors.orange, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "TDS",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.water, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                "Valeur idéale : < 500 mg/L",
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Le TDS correspond à la quantité de minéraux, sels et métaux dissous dans l’eau. Un niveau modéré est bon, mais trop élevé peut signaler une pollution.",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "💡 Une eau très minéralisée (>1000 mg/L) peut être mauvaise pour les reins à long terme.",
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          // Turbidité : <5 NTU, mesure clarté et particules, risque si élevée
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.blur_on, color: Colors.deepPurple, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Turbidité",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.visibility, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                "Valeur idéale : < 5 NTU",
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "La turbidité mesure la clarté de l’eau. Une eau trouble peut indiquer la présence de particules, bactéries ou pollution récente.",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.deepPurple,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "💡 Une turbidité élevée rend les traitements de potabilisation moins efficaces.",
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
          // Température : 10-25°C idéal, influence croissance bactérienne et oxygène
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.thermostat, color: Colors.redAccent, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Température",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.thermostat_outlined, color: Colors.teal),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Valeur idéale : entre 10°C et 25°C",
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "La température influe sur la croissance des micro-organismes, la solubilité de l’oxygène et le goût de l’eau. Trop chaude, elle peut favoriser les bactéries.",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.redAccent),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "💡 L’eau à température modérée garde mieux l’oxygène et est plus agréable à boire.",
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}
