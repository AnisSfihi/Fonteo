import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// Carte d'informations bleue
// Affiche un carrousel léger avec :
// - propriétés mesurées (pH, TDS, turbidité, température, débit)
// - composition minérale (Ca, Mg, K, Na, etc.)
// Les loaders `isLoadingParametres` / `isLoadingMinerals` contrôlent
// l'affichage d'un petit indicateur de chargement à la place des valeurs.

class InfosBleu extends StatefulWidget {
  final LatLng sourceLocation;
  final String? ph;
  final String? tds;
  final String? turbidite;
  final String? temperature;
  final String? debit;
  final String? calcium;
  final String? magnesium;
  final String? potassium;
  final String? sodium;
  final String? bicarbonates;
  final String? sulfates;
  final String? chlorures;
  final String? nitrates;
  final String? nitrites;
  final String? residusSecs;
  final bool isLoadingMinerals;
  final bool isLoadingParametres;

  const InfosBleu({
    super.key,
    required this.sourceLocation,
    required this.ph,
    required this.tds,
    required this.turbidite,
    required this.temperature,
    required this.debit,
    required this.calcium,
    required this.magnesium,
    required this.potassium,
    required this.sodium,
    required this.bicarbonates,
    required this.sulfates,
    required this.chlorures,
    required this.nitrates,
    required this.nitrites,
    required this.residusSecs,
    required this.isLoadingMinerals,
    required this.isLoadingParametres,
  });

  @override
  State<InfosBleu> createState() => _InfosBleuState();
}

class _InfosBleuState extends State<InfosBleu> {
  // Index courant du carousel (0 = Propriétés, 1 = Minéralité)
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          // Carrousel : un slide par groupe d'informations
          child: CarouselSlider(
            options: CarouselOptions(
              height: 220,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              // Met à jour l'indicateur de page quand l'utilisateur change de slide
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: [
              // ===========================
              // Slide 1 : Propriétés mesurées
              // - `isLoadingParametres` remplace les valeurs par un loader si vrai
              // ===========================
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 9),
                  Text(
                    "Propriétés",
                    style: TextStyle(
                      fontFamily: "MontSerratBold",
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),
                  // ===========================
                  // PH
                  // ===========================
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/images/ph.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "pH :     ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Raleway",
                          fontSize: 12,
                        ),
                      ),
                      widget.isLoadingParametres
                          ? SizedBox(
                            height: 12,
                            width: 12,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            widget.ph ?? '-',
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // ===========================
                  // TDS
                  // ===========================
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/images/tds.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "TDS :     ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Raleway",
                          fontSize: 12,
                        ),
                      ),
                      widget.isLoadingParametres
                          ? SizedBox(
                            height: 12,
                            width: 12,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            widget.tds ?? '-',
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                      Text(
                        "  mg/L",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 11,
                          color: Colors.white
                        ),
                        )
                    ],
                  ),

                  const SizedBox(height: 2),

                  // ===========================
                  // Turbidité
                  // ===========================
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      ClipOval(
                        child: Image.asset(
                          "assets/images/turbidite.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Turbidité :     ",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      widget.isLoadingParametres
                          ? SizedBox(
                            height: 12,
                            width: 12,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            widget.turbidite ?? '-',
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                      Text(
                        "  NTU",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 11,
                          color: Colors.white
                        ),
                        )
                    ],
                  ),

                  const SizedBox(height: 2),

                  // ===========================
                  // Température
                  // - `isLoadingMinerals` utilisé ici (données plus lourdes)
                  // ===========================
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      ClipOval(
                        child: Image.asset(
                          "assets/images/temperature.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Température :     ",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),


                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.temperature ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),


                      Text(
                        "  °C",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // ===========================
                  // Débit
                  // ===========================
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      ClipOval(
                        child: Image.asset(
                          "assets/images/debit.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Débit :     ",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      widget.isLoadingParametres
                          ? SizedBox(
                            height: 12,
                            width: 12,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            widget.debit ?? '-',
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                      Text(
                        "  L/min",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 11,
                          color: Colors.white
                        ),
                        )
                    ],
                  ),
                ],
              ),

              // ===========================
              // Slide 2 : Composition minérale
              // - `isLoadingMinerals` remplace chaque valeur par un loader si vrai
              // ===========================
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 9),
                      Text(
                        "Minéralité",
                        style: TextStyle(
                          fontFamily: "MontSerratBold",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ===========================
                      // Calcium
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/calcium.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Calcium:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.calcium ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Magnesium
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/magnesium.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Magnésium:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.magnesium ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Potassium
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/potassium.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Potassium:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.potassium ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Sodium
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/sodium.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Sodium:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.sodium ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Bicarbonate
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/bicarbonate.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Bicarbonates:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.bicarbonates ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Sulfates
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/sulfate.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Sulfates:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.sulfates ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Chlorures
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/chlorure.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Chlorures:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.chlorures ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Nitrates
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/nitrate.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Nitrates:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.nitrates ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Nitrites
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/nitrite.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Nitrites:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.nitrites ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // ===========================
                      // Résidus secs
                      // ===========================
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/dr.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Résidus secs:     ",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),

                          widget.isLoadingMinerals
                              ? SizedBox(
                                height: 12,
                                width: 12,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                widget.residusSecs ?? '-',
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),

                          Text(
                            "  mg/L",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Indicateur de page (petits points)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) => Container(
              width: 7,
              height: 7,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }
}