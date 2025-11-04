import 'package:aqua_sense/methods/manager.dart';
import 'package:flutter/material.dart';

// favoris.dart
// Page affichant les fontaines favorites de l'utilisateur.
// UI simple : liste de favoris, suppression individuelle ou purge totale.

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  List<String> favoris = [];

  @override
  void initState() {
    super.initState();
    loadFavoris();
  }

  // --- Chargement des favoris depuis le stockage local
  Future<void> loadFavoris() async {
    final data = await FavorisManager.getFavoris();
    setState(() {
      favoris = data;
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
          "Favoris",
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
              image: AssetImage("assets/images/favorite.png"),
              fit: BoxFit.cover,
            ),
          ),
        child: favoris.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border,
                    color: Colors.white,
                    size: 40,
                    ),
                    SizedBox(height: 15,),
                    Align(
                      child: SizedBox(
                        width: 350,
                        child: Text(
                          "Découvrez des sources d'eau à ajouter en favoris",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "MontSerratBold",
                            color: Colors.white
                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 24),
                itemCount: favoris.length,
                itemBuilder: (context, index) {
                  final item = favoris[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      //ACTION
                    }, 
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white.withOpacity(0.92),
                      child: ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber, size: 32),
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
                            await FavorisManager.removeFromFavoris(item);
                            loadFavoris();
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
  // --- Bouton flottant : vider tous les favoris
  floatingActionButton: favoris.isNotEmpty
          ? SizedBox(
              width: 65,
              height: 65,
              child: FloatingActionButton(
                elevation: 8,
                onPressed: () async {
                  await FavorisManager.clearFavoris();
                  loadFavoris();
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.delete_forever, color: Colors.red, size: 35),
              ),
            )
          : null,
    );
  }
}
