import 'package:aqua_sense/methods/manager.dart';
import 'package:flutter/material.dart';

// historique.dart
// Page affichant l'historique des fontaines consultées.
// UI simple : liste des visites, suppression individuelle ou purge totale.

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<String> historique = [];

  @override
  void initState() {
    super.initState();
    loadHistorique();
  }
  // --- Chargement de l'historique
  // Lit la liste depuis le stockage local et met à jour l'état
  Future<void> loadHistorique() async {
    final data = await HistoriqueManager.getHistorique();
    setState(() {
      historique = data;
    });
  }

  // --- UI principale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white, size: 34),
        title: const Text(
          "Historique",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "MontserratBold",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          ),
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/history_fond.png"),
              fit: BoxFit.cover,
            ),
          ),
        child: historique.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off,
                    color: Colors.white,
                    size: 40,
                    ),
                    SizedBox(height: 15,),
                    Text(
                      "Aucun historique pour le moment",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "MontSerratBold",
                        color: Colors.white
                        ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 24),
                itemCount: historique.length,
                itemBuilder: (context, index) {
                  final item = historique[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {}, // Ajouter une action ici si besoin
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white.withOpacity(0.92),
                      child: ListTile(
                        leading: const Icon(Icons.history, color: Colors.blue, size: 32),
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontFamily: "MontserratBold",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 28),
                          splashRadius: 22,
                          onPressed: () async {
                            await HistoriqueManager.removeFromHistorique(item);
                            loadHistorique();
                          },
                        ),
                        tileColor: Colors.transparent,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 16),
              ),
      ),
    // --- Bouton flottant : vider tout l'historique
    floatingActionButton: historique.isNotEmpty
          ? SizedBox(
              width: 65,
              height: 65,
              child: FloatingActionButton(
                elevation: 8,
                onPressed: () async {
                  await HistoriqueManager.clearHistorique();
                  loadHistorique();
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
               child: const Icon(Icons.delete_forever_outlined, color: Colors.red, size: 35),
              ),
            )
          : null,
    );
  }
}
