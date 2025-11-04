import 'package:animate_do/animate_do.dart';
import 'package:aqua_sense/methods/wifi_location.dart';
import 'package:aqua_sense/models/app_state.dart';
import 'package:aqua_sense/pages/map_proposer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

// Page de proposition (formulaire)
// Fichier qui contient l'interface pour proposer une fontaine :
// - form fields (nom, région)
// - sélection d'un emplacement via la carte
// - envoi de la proposition vers Firestore
// Les modifications sont uniquement des commentaires concis.

class ProposerPage extends StatefulWidget {
  const ProposerPage({super.key});

  @override
  State<ProposerPage> createState() => _ProposerPageState();
}

class _ProposerPageState extends State<ProposerPage> {
  bool loadingValidation = false;
  final _formkey = GlobalKey<FormState>();

  final sourceNameController = TextEditingController();
  final sourceRegionController = TextEditingController();
  final sourceLatitudeController = TextEditingController();
  final sourceLongitudeController = TextEditingController();

  void setCoordinates(LatLng coords) {
    sourceLatitudeController.text = coords.latitude.toString();
    sourceLongitudeController.text = coords.longitude.toString();
  }

  @override
  void dispose() {
    super.dispose();
    sourceNameController.dispose();
    sourceRegionController.dispose();
    sourceLatitudeController.dispose();
    sourceLongitudeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fond_app_icones.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Proposer",
                      style: TextStyle(
                        fontFamily: "MontserratBold",
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  Container(
                    height: 7,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "Veuillez renseigner les informations relatives à la fontaine soumise",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "MontserratBold",
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Champs Nom Source
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Nom",
                                hintText: "Entrez votre source",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.water_drop_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tu dois compléter ce texte";
                                }
                                return null;
                              },
                              controller: sourceNameController,
                            ),
                          ),

                          //Champs Région
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Région",
                                hintText: "Entrez la région",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.location_city),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tu dois compléter ce texte";
                                }
                                return null;
                              },
                              controller: sourceRegionController,
                            ),
                          ),

                          SizedBox(height: 10),

                          //Champs Emplecement Coordonnées
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Text(
                                  "Choisir sur la carte :",
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    color: Colors.blueGrey,
                                  ),
                                ),

                                SizedBox(width: 70),

                                FloatingActionButton(
                                  heroTag: 'proposerMapButton',
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const ProposerMap(),
                                      ),
                                    );

                                    if (result != null && result is LatLng) {
                                      appState.setProposedLocation(result);
                                    }
                                  },
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    114,
                                    186,
                                    244,
                                  ),
                                  elevation: 1,
                                  child: Icon(
                                    Icons.zoom_in,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          //Container à afficher
                          if (appState.proposedLocation != null)
                            ZoomIn(
                              child: Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 320,
                                        minWidth: 220,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.92),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(
                                              0.10,
                                            ),
                                            blurRadius: 18,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.blue.shade100,
                                          width: 2,
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                        20,
                                        3,
                                        20,
                                        12,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.place,
                                            color: Colors.blue,
                                            size: 32,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Emplacement proposé : ",
                                            style: TextStyle(
                                              fontFamily: "MontserratBold",
                                              color: Colors.blue,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.my_location_outlined,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Latitude : ${appState.proposedLocation?.latitude.toStringAsFixed(5)}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.my_location_outlined,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Longitude : ${appState.proposedLocation?.longitude.toStringAsFixed(5)}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          appState.setProposedLocation(null);
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Color.fromARGB(
                                            255,
                                            114,
                                            186,
                                            244,
                                          ),
                                          size: 28,
                                        ),
                                        splashRadius: 18,
                                        tooltip: "Fermer",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          Padding(padding: EdgeInsets.only(bottom: 20)),

                          //Champs Bouton "Valider"
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  if (appState.proposedLocation == null) {
                                    Fluttertoast.showToast(
                                      msg: "Vous devez indiquer un emplacement",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    return;
                                  }

                                  setState(() {
                                    loadingValidation = true;
                                  });

                                      if (!await hasActiveInternet()) {
                                        if (mounted) {
                                          setState(() {
                                            loadingValidation = false;
                                          });
                                          Fluttertoast.showToast(
                                            msg: "Pas de connexion Internet.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                        return;
                                      }

                                  final sourceNameValue =
                                      sourceNameController.text;
                                  final sourceRegionValue =
                                      sourceRegionController.text;
                                  final latitudeValue = double.parse(
                                    appState.proposedLocation!.latitude.toStringAsFixed(6),
                                  );

                                  final longitudeValue = double.parse(
                                    appState.proposedLocation!.longitude.toStringAsFixed(6),
                                  );

                                  CollectionReference eventsRef =
                                      FirebaseFirestore.instance.collection(
                                        "proposed",
                                      );

                                  try {
                                    await eventsRef
                                      .add({
                                        'nom': sourceNameValue,
                                        'region': sourceRegionValue,
                                        'position': {
                                          'latitude': latitudeValue,
                                          'longitude': longitudeValue,
                                        },
                                      });

                                        if(mounted){
                                        setState(() {
                                          loadingValidation = false;
                                          sourceNameController.clear();
                                          sourceRegionController.clear();
                                          sourceLatitudeController.clear();
                                          sourceLongitudeController.clear();
                                        });
                                        appState.setProposedLocation(null);
                                        Fluttertoast.showToast(
                                          msg:
                                              "L’emplacement a bien été proposé !",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }

                                }catch(e){
                                        if (mounted) {
                                          setState(() {
                                            loadingValidation = false;
                                          });
                                          Fluttertoast.showToast(
                                            msg:
                                                "Erreur lors de l’envoi de la proposition.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  114,
                                  186,
                                  244,
                                ),
                                elevation: 2,
                              ),
                              child:
                                  loadingValidation == true
                                      ? CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: Colors.white,
                                      )
                                      : Text(
                                        "Valider",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "MontserratBold",
                                          fontSize: 20,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
