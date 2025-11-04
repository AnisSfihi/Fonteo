import 'package:aqua_sense/methods/wifi_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Page de signalement
// Formulaire pour signaler un problème (source introuvable, bug, etc.)
// - collecte nom, mail, motif et commentaire
// - envoie vers la collection 'signalement' dans Firestore
// Les commentaires ajoutés sont concis et n'altèrent pas la logique.

class SignalerPage extends StatefulWidget {
  const SignalerPage({super.key});

  @override
  State<SignalerPage> createState() => _SignalerPageState();
}

class _SignalerPageState extends State<SignalerPage> {
  bool loadingValidation = false;

  // Clé du formulaire et controllers des champs
  final _formSignalKey = GlobalKey<FormState>();
  final userFullNameController = TextEditingController();
  final mailController = TextEditingController();
  final userCommentController = TextEditingController();

  String? selectedMotif;

  @override
  void dispose() {
    userFullNameController.dispose();
    mailController.dispose();
    userCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white, size: 34),
        title: const Text(
          "Signaler",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "MontserratBold",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/signal_fond.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 115),
              // Header non scrollable
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Merci de contribuber à l'amélioration de Fonteo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "MontserratBold",
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 7,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 25),
              // Formulaire scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formSignalKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Champ Nom
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Nom complet",
                                  hintText: "Entrez votre nom",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Ce champ est requis";
                                  }
                                  return null;
                                },
                                controller: userFullNameController,
                              ),
                              const SizedBox(height: 16),
                              // Champ Email
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Adresse mail",
                                  hintText: "exemple@email.com",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  // Vérification basique de la présence et du format d'email
                                  if (value == null || value.isEmpty) {
                                    return "Ce champ est requis";
                                  }
                                  // regex simple : vérifie la présence d'un '@' et d'un suffixe
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(value)) {
                                    return 'Adresse mail invalide';
                                  }
                                  return null;
                                },
                                controller: mailController,
                              ),
                              const SizedBox(height: 16),
                              // Champ Motif
                              DropdownButtonFormField<String>(
                                value: selectedMotif,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Motif du signalement",
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "notFoundSource",
                                    child: Text("Source introuvable"),
                                  ),
                                  DropdownMenuItem(
                                    value: "falseDataSource",
                                    child: Text(
                                      "Données incorrectes sur une source",
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "errorGPS",
                                    child: Text("Problème de localisation/GPS"),
                                  ),
                                  DropdownMenuItem(
                                    value: "errorCnx",
                                    child: Text("Problème de connexion"),
                                  ),
                                  DropdownMenuItem(
                                    value: "bugApp",
                                    child: Text("Bug de l’application"),
                                  ),
                                  DropdownMenuItem(
                                    value: "other",
                                    child: Text("Autre"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedMotif = value;
                                  });
                                },
                                validator: (value) {
                                  // Le motif est obligatoire pour catégoriser le signalement
                                  if (value == null || value.isEmpty) {
                                    return "Merci de choisir un motif";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Champ Commentaire (optionnel sauf si "Autre")
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Commentaire",
                                  hintText: "Exprimez-vous",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 4,
                                validator: (value) {
                                  // Si l'utilisateur choisit 'Autre', le commentaire devient requis
                                  if (selectedMotif == 'other' &&
                                      (value == null || value.isEmpty)) {
                                    return "Merci de préciser votre problème";
                                  }
                                  return null;
                                },
                                controller: userCommentController,
                              ),
                              const SizedBox(height: 16),

                              // Bouton Envoyer
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Validation du formulaire puis envoi
                                    if (_formSignalKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        loadingValidation = true;
                                      });

                                      // Vérifie la connexion avant d'envoyer
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

                                      // Récupère les valeurs du formulaire
                                      final userFullNameValue =
                                          userFullNameController.text;
                                      final mailValue = mailController.text;
                                      final commentValue =
                                          userCommentController.text;

                                      // Référence collection Firestore
                                      CollectionReference signalRef =
                                          FirebaseFirestore.instance.collection(
                                            "signalement",
                                          );

                                      try {
                                        // Envoi du document de signalement
                                        await signalRef.add({
                                          'nom': userFullNameValue,
                                          'mail': mailValue,
                                          'motif': selectedMotif,
                                          'date': DateTime.now(),
                                          'commentaire': commentValue,
                                        });

                                      if (mounted) {
                                        // Réinitialise le formulaire après succès
                                        setState(() {
                                          loadingValidation = false;
                                          userFullNameController.clear();
                                          mailController.clear();
                                          userCommentController.clear();
                                          selectedMotif = null;
                                        });

                                        Fluttertoast.showToast(
                                          msg: "Votre signalement a bien été envoyé",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                      } catch (e) {
                                        if (mounted) {
                                          setState(() {
                                            loadingValidation = false;
                                          });
                                          Fluttertoast.showToast(
                                            msg:
                                                "Erreur lors de l’envoi du signalement.",
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
                                    backgroundColor: const Color(0xFF72BAF4),
                                    elevation: 2,
                                  ),
                                  child:
                                      loadingValidation
                                          ? const CircularProgressIndicator(
                                            strokeWidth: 4,
                                            color: Colors.white,
                                          )
                                          : const Text(
                                            "Envoyer",
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
