import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:latlong2/latlong.dart';

// Popup pour proposer un emplacement
// Affiche un petit popup montrant les coordonnées sélectionnées,
// la distance depuis l'utilisateur et deux actions :
// - accepter l'emplacement (retourne le `LatLng` via Navigator.pop)
// - calculer l'itinéraire vers cet emplacement (appel à onStartNavigation)
// Les commentaires ajoutés sont minimaux et n'altèrent pas la logique.

class ProposeLocationMarker extends StatefulWidget {
  final LatLng tempPoint;
  final LatLng userLocation;
  final Future<void> Function(LatLng, LatLng) onStartNavigation;
  final Future<double> Function(LatLng, LatLng) onCalculateDistance;
  final String Function(double) onFormatDistance;

  const ProposeLocationMarker({
    super.key,
    required this.tempPoint,
    required this.userLocation,
    required this.onStartNavigation,
    required this.onCalculateDistance,
    required this.onFormatDistance,
  });

  @override
  State<ProposeLocationMarker> createState() => _ProposeLocationMarkerState();
}

class _ProposeLocationMarkerState extends State<ProposeLocationMarker> {
  bool isCalculatingRouteProposed = false;

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
      content: Container(
        constraints: BoxConstraints(maxWidth: 255),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Emplacement sélectionné",
                  style: TextStyle(fontFamily: "MontSerratBold", fontSize: 13),
                ),

                // Affiche la distance calculée (FutureBuilder)
                // Le Future est fourni par `onCalculateDistance` passé depuis le parent
                FutureBuilder<double>(
                  future: widget.onCalculateDistance(
                    widget.userLocation,
                    widget.tempPoint,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text("Erreur");
                    } else {
                      final distance = snapshot.data!;
                      return Text(
                        "Distance : ${widget.onFormatDistance(distance)}",
                        style: const TextStyle(
                          fontFamily: "MontSerratBold",
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: 10),

                // Coordonnées affichées (arrondies à 5 décimales)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.my_location, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      "Latitude : ${widget.tempPoint.latitude.toStringAsFixed(5)}",
                      style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5),

                // Longitude affichée (arrondie)
                Row(
                  children: [
                    Icon(Icons.my_location, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      "Longitude : ${widget.tempPoint.longitude.toStringAsFixed(5)}",
                      style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Text(
                  "Confirmer cet emplacement ?",
                  style: TextStyle(fontFamily: "Raleway", fontSize: 12),
                ),

                SizedBox(height: 10),

                // Actions : Accepter ou calculer itinéraire
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: "acceptButton",
                      mini: true,
                      elevation: 1,
                      onPressed: () {
                        // Ferme le popup courant puis renvoie `tempPoint` au parent
                        Navigator.pop(context);
                        Navigator.pop(context, widget.tempPoint);
                      },
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      child: Icon(Icons.check, color: Colors.green, size: 30),
                    ),

                    const SizedBox(width: 130),

                    // Bouton itinéraire : utilise StatefulBuilder pour gérer un loader local
                    StatefulBuilder(
                      builder: (context, setStatePopup){
                      return FloatingActionButton(
                        heroTag: "itinieraireButtonPropose",
                        mini: true,
                        elevation: 1,
                        onPressed:
                            isCalculatingRouteProposed
                                ? null
                                : () async {
                                  // Indique l'état de calcul localement, appelle la fonction
                                  setStatePopup(() {
                                    isCalculatingRouteProposed = true;
                                  });
                                  await widget.onStartNavigation(
                                    widget.userLocation,
                                    widget.tempPoint,
                                  );

                                  if (!context.mounted) return;

                                  // Réinitialise le loader local puis ferme le popup
                                  setStatePopup(() {
                                    isCalculatingRouteProposed = false;
                                  });

                                  Navigator.pop(context);
                                },
                      
                        shape: const CircleBorder(),
                        backgroundColor: Colors.green,
                        child:
                            isCalculatingRouteProposed
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
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
                      }
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      child: Icon(Icons.location_on, size: 50, color: Colors.blue),
    );
  }
}
