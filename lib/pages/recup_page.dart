import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:aqua_sense/models/mesures.dart';

// Page de récupération des mesures
// Affiche les mesures reçues depuis la Realtime Database
// - écoute un flux Firebase Realtime pour la collection 'mesures'
// - affiche la liste des mesures et un dialogue de détails
// Les annotations ajoutées sont concises et ne modifient pas la logique.

class RecupPage extends StatefulWidget {
  const RecupPage({super.key});

  @override
  State<RecupPage> createState() => RecupPageState();
}

class RecupPageState extends State<RecupPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> showEventDetailsDialog(Mesures mesuresData) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Mesure ajoutée"),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('pH : ${mesuresData.ph}'),
                  Text("TDS : ${mesuresData.tds}"),
                  Text('Date : ${DateFormat.yMd().add_jm().format(mesuresData.time)}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder(
      stream: FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dotenv.env['FIREBASE_DB_URL'],
    ).ref("mesures/Tizi-Ouzou").onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Lottie.asset(
                'assets/animations/Animation - 1744818970292.json',
                width: 70,
                height: 70,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text("Aucune donnée.", style: TextStyle(color: Colors.grey),));
        }

        Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>; //On reçoit les données as Map et on les met dans data qui est du même type 

        List<Mesures> mesures = data.values.map<Mesures>((e) => Mesures.fromMap(e as Map<dynamic, dynamic>)).toList();
          
        return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fond_app_icones.png"),
              fit: BoxFit.cover,
            ),
        ),
          child: ListView.builder(
            itemCount: mesures.length,
            itemBuilder: (context, index) {
              final mesure = mesures[index];
              DateFormat.yMd().add_jm().format(mesure.time);
          
              return Card(
                child: ListTile(
                  title: const Text("Mesure"),
                  subtitle: Text("pH: ${mesure.ph}  |  TDS: ${mesure.tds}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline_rounded),
                    onPressed: () => showEventDetailsDialog(mesure),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
