import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';

// Popup d'avis utilisateur
// Ce widget affiche un petit formulaire pour laisser un avis sur une source :
// - nom de l'utilisateur
// - commentaire
// - envoi vers Firestore (collection 'aviss')
// Les commentaires ajoutés sont brefs et visent à clarifier les parties clés.

class PopupAvisWidget extends StatefulWidget {
  final String sourceName;
  final LatLng sourceLocation;

  const PopupAvisWidget({
    super.key,
    required this.sourceName,
    required this.sourceLocation,
    });

  @override
  State<PopupAvisWidget> createState() => _PopupAvisWidget();
}

class _PopupAvisWidget extends State<PopupAvisWidget> {
  // Clé du formulaire et état de chargement
  final _formNoteKey = GlobalKey<FormState>();
  bool loadingValidation = false;

  // Controllers pour les champs du formulaire
  final nameNoteController = TextEditingController();
  final commentNoteController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameNoteController.dispose();
    commentNoteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400, // Largeur personnalisée
        constraints: BoxConstraints(
          minHeight: 350, // Hauteur minimale
          maxWidth: 500,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fond_popup_p.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  SizedBox(height: 6),
                  Center(
                    child: Icon(
                      Icons.rate_review,
                      color: Colors.blue,
                      size: 60,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Form(
                key: _formNoteKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nom Complet",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.water_drop_outlined),
                        ),
                        validator: (value) {
                          // Vérifie la présence d'un nom
                          if (value == null || value.isEmpty) {
                            return "Tu dois compléter ce texte";
                          }
                          return null;
                        },
                        controller: nameNoteController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Commentaire",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.water_drop_outlined),
                        ),
                        maxLines: 6,
                        validator: (value) {
                          // Commentaire requis pour valider l'avis
                          if (value == null || value.isEmpty) {
                            return "Tu dois compléter ce texte";
                          }
                          return null;
                        },
                        controller: commentNoteController,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Fermer", style: TextStyle(color: Colors.blue)),
                  ),

                  const SizedBox(width: 70),

                  SizedBox(
                    height: 50,
                    width: 122,
                    child: ElevatedButton(
                      onPressed: () {
                          if (_formNoteKey.currentState!.validate()) {
                          final nameNote = nameNoteController.text;
                          final commentNote = commentNoteController.text;

                          // Indique que l'envoi est en cours
                          setState(() {
                            loadingValidation = true;
                          });

                          // Prépare la référence Firestore
                          CollectionReference avisRef = FirebaseFirestore
                              .instance
                              .collection("aviss");

                          // Ajout du document : on formate les coordonnées en String réduite
                          // (raison: compatibilité / affichage) et on inclut la date.
                          avisRef
                              .add({
                                'sourceName': widget.sourceName,
                                'sourceLatLon': {
                                          'latitude': widget.sourceLocation.latitude.toStringAsFixed(5),
                                          'longitude': widget.sourceLocation.longitude.toStringAsFixed(5),
                                        },
                                'userName': nameNote,
                                'userComment': commentNote,
                                'dateAvis': DateTime.now(),
                              })
                              .then((_) {
                                // Réinitialise les champs après succès
                                setState(() {
                                  loadingValidation = false;
                                  nameNoteController.clear();
                                  commentNoteController.clear();
                                });
                                Fluttertoast.showToast(
                                  msg: "Merci pour votre contribution",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              });

                          // Ferme le focus clavier
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 2,
                      ),
                      child:
                          loadingValidation == true
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                "Envoyer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "MontserratBold",
                                  fontSize: 15,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
