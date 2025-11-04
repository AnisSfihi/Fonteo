import 'package:animate_do/animate_do.dart';
import 'package:aqua_sense/methods/db_mineraux.dart';
import 'package:aqua_sense/methods/format_duree.dart';
import 'package:aqua_sense/methods/latest_mesure.dart';
import 'package:aqua_sense/methods/manager.dart';
import 'package:aqua_sense/methods/potability_water.dart';
import 'package:aqua_sense/models/mesures.dart';
import 'package:aqua_sense/models/status.dart';
import 'package:aqua_sense/widgets/blue_infos.dart';
import 'package:aqua_sense/widgets/avis_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:latlong2/latlong.dart';

// Popup d'information — fiche détaillée d'une source d'eau
//
// Ce composant affiche une fenêtre modale (Dialog) contenant :
// - le nom et la distance jusqu'à la source,
// - le statut de potabilité calculé automatiquement,
// - les dernières mesures (pH, TDS, turbidité, etc.) et les minéraux associés,
// - des actions utilisateur (itinéraire, laisser un avis, ajouter aux favoris).
//
// Objectif : fournir une fiche synthétique, lisible et actionnable depuis la carte.
// Les commentaires dans ce fichier expliquent brièvement chaque section UI et
// la finalité des principaux états et méthodes.
class PopupInfoWidget extends StatefulWidget {
  // ===========================
  // Paramètres du widget
  // ===========================
  final Function() onClose;
  final String sourceName;
  final LatLng userLocation;
  final LatLng sourceLocation;
  final String Function(double) formatDuration;
  final Future<double> Function(LatLng, LatLng) calculateDistance;
  final Future<Mesures?> Function(LatLng) fetchLastMesure;
  final Future<void> Function(LatLng, LatLng)? onStartNavigation;

  final bool showItineraireButton;
  final bool showAvisButton;

  const PopupInfoWidget({
    super.key,
    required this.onClose,
    required this.sourceName,
    required this.userLocation,
    required this.sourceLocation,
    required this.calculateDistance,
    required this.formatDuration,
    required this.fetchLastMesure,
    required this.showItineraireButton,
    required this.showAvisButton,
    this.onStartNavigation,
  });

  @override
  State<PopupInfoWidget> createState() => _PopupInfoWidgetState();
}

class _PopupInfoWidgetState extends State<PopupInfoWidget> {
  // Label affichant la date/heure de la dernière mesure disponible
  String? lastUpdateLabel;

  // Indicateurs d'état UI
  // - isCalculatingRoute : bouton itinéraire en cours de calcul
  // - isLoadingMinerals / isLoadingParametres : loaders pour les données
  bool isCalculatingRoute = false;
  bool isLoadingMinerals = true;
  bool isLoadingParametres = true;

  // Données récupérées depuis la DB/local : minéraux et paramètres mesurés
  Map<String, dynamic>? mineralData;

  // Résultat d'analyse simplifiée de potabilité (status + problèmes détectés)
  WaterPotabilityResult potabilityStatus = WaterPotabilityResult(
    status: "",
    problems: [],
  );

  // Paramètres mesurés (peuvent être null si non disponibles)
  double? phValue;
  double? tdsValue;
  double? turbiditeValue;
  double? temperatureValue;
  double? debitValue;

  @override
  void initState() {
    super.initState();
    fetchAllDataAndFavoris();
  }
  // Indique si la source est ajoutée aux favoris de l'utilisateur
  bool isInFavoris = false;

  // Récupère toutes les données nécessaires pour la fiche :
  // 1) minéraux via la DB locale (fetchMineralDataByName)
  // 2) dernière mesure disponible (fetchLastMesure)
  // 3) liste des favoris pour savoir si la source y figure
  // Met à jour l'état UI en conséquence (chargements, label de mise à jour,
  // valeurs mesurées et évaluation de potabilité).
  Future<void> fetchAllDataAndFavoris() async {
    final mineral = await fetchMineralDataByName(widget.sourceLocation);
    final mesure = await fetchLastMesure(widget.sourceLocation);
    final favoris = await FavorisManager.getFavoris();
    final key =
        "${widget.sourceName}\n${widget.sourceLocation.latitude.toStringAsFixed(5)} | ${widget.sourceLocation.longitude.toStringAsFixed(5)}";

    if (!mounted) return;

    setState(() {
      mineralData = mineral;
      tdsValue = mesure?.tds.toDouble();
      phValue = mesure?.ph.toDouble();
      if (mesure?.time != null) {
        lastUpdateLabel = formatDurationFromDate(mesure!.time);
      } else {
        lastUpdateLabel = "Donnée indisponible";
      }
      isLoadingMinerals = false;
      isLoadingParametres = false;

      potabilityStatus = evaluateWaterPotability(
        pH: phValue,
        tds: tdsValue,
        turbidity: turbiditeValue,
        temperature: temperatureValue,
        calcium: mineralData?['Calcium']?.toDouble(),
        magnesium: mineralData?['Magnésium']?.toDouble(),
        potassium: mineralData?['Potassium']?.toDouble(),
        sodium: mineralData?['Sodium']?.toDouble(),
        bicarbonates: mineralData?['Bicarbonates']?.toDouble(),
        sulfates: mineralData?['Sulfates']?.toDouble(),
        chlorures: mineralData?['Chlorures']?.toDouble(),
        nitrates: mineralData?['Nitrates']?.toDouble(),
        nitrites: mineralData?['Nitrites']?.toDouble(),
        residusSecs: mineralData?['Résidus secs']?.toDouble(),
      );

      isInFavoris = favoris.contains(key);
    });
    print(temperatureValue);
  }

  @override
  Widget build(BuildContext context) {
    // ===========================
    // Dialog principal
    // ===========================
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Visibility(
        visible: true,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fond_popup_p.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===========================
                // Bouton de fermeture
                // ===========================
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 40,
                    height: 35,
                    child: IconButton(
                      onPressed: widget.onClose,
                      icon: Icon(Icons.close, size: 30, color: Colors.red),
                    ),
                  ),
                ),

                // ===========================
                // Titre de la source
                // ===========================
                Text(
                  widget.sourceName,
                  style: const TextStyle(
                    fontFamily: "MontserratBold",
                    fontSize: 25,
                  ),
                ),

                // ===========================
                // Distance
                // ===========================
                // Affiche la distance calculée entre l'utilisateur et la source.
                // Un bouton contextuel (CustomPopup) permet d'afficher les
                // coordonnées GPS précises (latitude / longitude).
                Row(
                  children: [
                    FutureBuilder<double>(
                      future: widget.calculateDistance(
                        widget.userLocation,
                        widget.sourceLocation,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text("Erreur");
                        } else {
                          final distance = snapshot.data!;
                          return Text(
                            "Distance : ${formatDistance(distance)}",
                            style: const TextStyle(
                              fontFamily: "MontSerratBold",
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          );
                        }
                      },
                    ),
                    CustomPopup(
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "📍 Lat: ${widget.sourceLocation.latitude.toStringAsFixed(5)}  ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontFamily: "Raleway",
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "📍 Lon: ${widget.sourceLocation.longitude.toStringAsFixed(5)}  ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontFamily: "Raleway",
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                      child: Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ===========================
                // Statut de la source
                // ===========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Statut : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'MontSerratBold',
                            ),
                          ),
                          TextSpan(
                            text: potabilityStatus.status,
                            style: TextStyle(
                              color:
                                  potabilityStatus.status == "POTABLE"
                                      ? Colors.green
                                      : potabilityStatus.status == "NON POTABLE"
                                      ? Colors.red
                                      : Colors.grey,
                              fontSize: 18,
                              fontFamily: 'MontSerratBold',
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (potabilityStatus.status == "NON POTABLE")
                      CustomPopup(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Problèmes détectés",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "MontSerratBold",
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),

                            const SizedBox(height: 8),

                            ...potabilityStatus.problems.map(
                              (problem) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        problem,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Raleway",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),

                // ===========================
                // Mise à jour
                // ===========================
                Center(
                  child: Text(
                    lastUpdateLabel != null
                        ? lastUpdateLabel!
                        : "Mise à jour en cours...",
                    style: TextStyle(
                      fontFamily: "MontSerratBold",
                      fontSize: 10,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                // ===========================
                // Carrousel d'informations
                // ===========================
                // Widget `InfosBleu` : présente les mesures et minéraux sous forme
                // de cartes informatives (chargement géré via isLoading*).
                FadeIn(
                  child: InfosBleu(
                    sourceLocation: widget.sourceLocation,
                    isLoadingMinerals: isLoadingMinerals,
                    isLoadingParametres: isLoadingParametres,
                    ph: phValue?.toString(),
                    tds: tdsValue?.toString(),
                    turbidite: turbiditeValue?.toString(),
                    temperature: temperatureValue?.toString(),
                    debit: debitValue?.toString(),
                    calcium: mineralData?['Calcium']?.toString(),
                    magnesium: mineralData?['Magnésium']?.toString(),
                    potassium: mineralData?['Potassium']?.toString(),
                    sodium: mineralData?['Sodium']?.toString(),
                    bicarbonates: mineralData?['Bicarbonates']?.toString(),
                    sulfates: mineralData?['Sulfates']?.toString(),
                    chlorures: mineralData?['Chlorures']?.toString(),
                    nitrates: mineralData?['Nitrates']?.toString(),
                    nitrites: mineralData?['Nitrites']?.toString(),
                    residusSecs: mineralData?['Résidus secs']?.toString(),
                  ),
                ),

                const SizedBox(height: 10),

                // ===========================
                // Actions (itinéraire & avis)
                // ===========================
                if (widget.showItineraireButton == true &&
                    widget.showAvisButton)
                  Row(
                    children: [
                      SizedBox(width: 3),
                      Column(
                        children: [
                          ZoomIn(
                            child: SizedBox(
                              width: 55,
                              height: 55,
                              child: StatefulBuilder(
                                builder: (context, setStateInfoPopup) {
                                  return FloatingActionButton(
                                    heroTag: "itineraireButton",
                                    elevation: 3,
                                    onPressed:
                                        isCalculatingRoute
                                            ? null
                                            : () async {
                                              setStateInfoPopup(() {
                                                isCalculatingRoute = true;
                                              });
                                              LatLng start =
                                                  widget.userLocation;
                                              LatLng end =
                                                  widget.sourceLocation;
                                              if (widget.onStartNavigation !=
                                                  null) {
                                                await widget.onStartNavigation!(
                                                  start,
                                                  end,
                                                );
                                              }

                                              if (!mounted) return;

                                              setStateInfoPopup(() {
                                                isCalculatingRoute = false;
                                              });

                                              Navigator.of(context).pop();
                                            },
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.green,
                                    child:
                                        isCalculatingRoute
                                            ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                            : Icon(
                                              Icons.near_me_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Itinéraire",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      //AVIS
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 175,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              label: Text(
                                "Laisser un avis",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              icon: Icon(
                                Icons.rate_review,
                                color: Colors.blue,
                                size: 20,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PopupAvisWidget(
                                      sourceName: widget.sourceName,
                                      sourceLocation: widget.sourceLocation,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          StatefulBuilder(
                            builder: (context, setStateStar) {
                              return IconButton(
                                onPressed: () async {
                                  final key =
                                      "${widget.sourceName}\n${widget.sourceLocation.latitude.toStringAsFixed(5)} | ${widget.sourceLocation.longitude.toStringAsFixed(5)}";
                                  if (isInFavoris) {
                                    await FavorisManager.removeFromFavoris(key);
                                  } else {
                                    await FavorisManager.addToFavoris(key);
                                  }
                                  setStateStar(() {
                                    isInFavoris = !isInFavoris;
                                  });
                                },
                                icon: Icon(
                                  isInFavoris ? Icons.star : Icons.star_outline,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                if (widget.showItineraireButton == false &&
                    widget.showAvisButton == false)
                  Center(
                    child: Text(
                      "Itinéraire et avis uniquement disponibles sur la carte principale.",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontFamily: "Raleway",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
