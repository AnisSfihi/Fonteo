import 'package:aqua_sense/methods/wifi_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';

// Popup trajet — fenêtre décrivant les durées de trajet vers une source
//
// Ce widget affiche un Dialog proposant :
// - la durée estimée pour se rendre à la source à pied et en voiture,
// - un indicateur de chargement pendant la récupération des durées,
// - des actions pour démarrer la navigation (marche / conduite),
// - des informations contextuelles (accessibilité, avertissements si le
//   trajet à pied est très long).
//
// Les commentaires dans ce fichier expliquent brièvement chaque section UI
// et les étapes principales de récupération des durées (vérification
// de connexion, appel à l'API de durée, gestion des erreurs).
class PopupTrajetWidget extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onStartWalk;
  final VoidCallback onStartDrive;
  final LatLng userLocation;
  final LatLng sourceLocation;
  final String selectedMode;
  final Future<double?> Function(LatLng, LatLng, String) getTravelDuration;
  final String Function(double) formatDuration;

  const PopupTrajetWidget({
    super.key,
    required this.onClose,
    required this.userLocation,
    required this.sourceLocation,
    required this.selectedMode,
    required this.getTravelDuration,
    required this.formatDuration,
    required this.onStartWalk,
    required this.onStartDrive,
  });

  @override
  State<PopupTrajetWidget> createState() => _PopupTrajetWidgetState();
}

class _PopupTrajetWidgetState extends State<PopupTrajetWidget> {
  // Durée estimée en secondes (ou minutes selon format) pour la marche.
  // Peut être null si la donnée n'est pas disponible ou en cas d'erreur.
  double? walkingDuration;

  // Durée estimée pour la conduite (nullable pour les mêmes raisons).
  double? drivingDuration;

  // Indicateur de chargement général pendant la récupération des durées.
  // true : on affiche des spinners, false : résultats (ou message d'erreur).
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDurations();
  }

// Récupère les durées de trajet pour les différents modes (marche / voiture).
// Étapes :
// 1) Vérifie qu'une connexion Internet est active (sinon message toast).
// 2) Met l'indicateur isLoading = true et appelle la fonction passée en
//    propriété (`getTravelDuration`) pour chaque mode.
// 3) En cas d'erreur, affiche un toast et positionne les valeurs à null.
// 4) Enfin remet isLoading à false (si le widget est toujours monté).
Future<void> loadDurations() async {
  if (!await hasActiveInternet()) {
    Fluttertoast.showToast(
      msg: "Pas de connexion Internet.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // Demande la durée pour la marche (mode "foot-walking")
    walkingDuration = await widget.getTravelDuration(
      widget.userLocation,
      widget.sourceLocation,
      "foot-walking",
    );

    // Demande la durée pour la voiture (mode "driving-car")
    drivingDuration = await widget.getTravelDuration(
      widget.userLocation,
      widget.sourceLocation,
      "driving-car",
    );
  } catch (e) {
    // Erreur réseau / API : avertir l'utilisateur et remettre les valeurs à null
    Fluttertoast.showToast(
      msg: "Erreur lors du calcul des trajets.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    walkingDuration = null;
    drivingDuration = null;
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===========================
              // Bouton de fermeture (croix)
              // ===========================
              // Permet de fermer le Dialog et de revenir à la carte.
              // Positionnée en haut à droite via un SizedBox + Row.
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    const SizedBox(width: 234),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        onPressed: widget.onClose,
                        icon: Icon(Icons.close_rounded, color: Colors.blue,size: 28,),
                      ),
                    ),
                  ],
                ),
              ),
              // ===========================
              // Section : À pied
              // ===========================
              // Affiche :
              // - icône de marche,
              // - durée estimée (ou état "Non accessible"),
              // - indicateurs contextuels (warnings si le trajet est long),
              // - bouton pour démarrer la navigation si ce mode est sélectionné.
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.directions_walk, size: 30, color: Colors.blue),
                      const SizedBox(width: 10),
                      Container(
                        width: 140,
                        alignment: Alignment.centerLeft,
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                              )
                            : (walkingDuration == null 
                                ? const Text(
                                    "Non accessible",
                                    style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: "Raleway"),
                                  )
                                : Row(
                                  children: [
                                    Text(
                                        widget.formatDuration(walkingDuration!),
                                        style: const TextStyle(fontSize: 12, fontFamily: "Raleway"),
                                      ),
                                    const SizedBox(width: 5,),    
                                if (walkingDuration! >= 120 && walkingDuration! <300) 
                                  const CustomPopup(
                                  content: Text("⚠️ Ce trajet est peut-être trop long pour être fait à pied.",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 12),),
                                  child: Icon(Icons.info_outline, color: Color(0xFFFFB300), size: 20,)),

                                if (walkingDuration! >= 300)
                                  const CustomPopup(
                                  content: Text("🚫 Trajet non adapté à la marche",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 12),),
                                  child: Icon(Icons.info_outline, color: Color(0xFFFFB300), size: 20,))

                                  ],
                                )),
                      ),
                      isLoading
                          ? const SizedBox(width: 30, height: 30)
                          : (walkingDuration == null
                              ? Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: const Icon(Icons.near_me_disabled_outlined, color: Colors.grey, size: 30),
                              )
                              : widget.selectedMode == "foot-walking"
                              ?   IconButton(
                                  onPressed: widget.onStartWalk,
                                  icon: Icon(
                                    Icons.near_me,
                                    color: Colors.green
                                  ),
                                  iconSize: 30,
                                )
                                :  IconButton(
                                  onPressed: widget.onStartWalk,
                                  icon: Icon(
                                    Icons.near_me_outlined,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 30,
                                )),
                    ],
                  ),
                ),
              // ===========================
              // Section : Voiture
              // ===========================
              // Similaire à la section marche mais pour le mode voiture :
              // icône, durée, état "Non accessible" et bouton de démarrage.
                SizedBox(
                  height: 53,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.drive_eta, size: 30, color: Colors.blue),
                      const SizedBox(width: 10),
                      Container(
                        width: 140,
                        alignment: Alignment.centerLeft,
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                              )
                            : (drivingDuration == null
                                ? const Text(
                                    "Non accessible",
                                    style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: "Raleway"),
                                  )
                                : Text(
                                    widget.formatDuration(drivingDuration!),
                                    style: const TextStyle(fontSize: 12, fontFamily: "Raleway"),
                                  )),
                      ),
                      isLoading
                          ? const SizedBox(width: 30, height: 30)
                          : (drivingDuration == null
                              ? Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: const Icon(Icons.near_me_disabled_outlined, color: Colors.grey, size: 30),
                              )
                              : widget.selectedMode == "driving-car"
                              ?   IconButton(
                                  onPressed: widget.onStartDrive,
                                  icon: Icon(
                                    Icons.near_me,
                                    color: Colors.green
                                  ),
                                  iconSize: 30,
                                )
                                :  IconButton(
                                  onPressed: widget.onStartDrive,
                                  icon: Icon(
                                    Icons.near_me_outlined,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 30,
                                )),
                    ],
                  ),
                ),
          
            ],
          ),
    );
  }
}