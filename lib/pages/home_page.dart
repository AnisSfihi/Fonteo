import 'package:animate_do/animate_do.dart';
import 'package:aqua_sense/models/app_state.dart';
import 'package:aqua_sense/pages/favoris.dart';
import 'package:aqua_sense/pages/historique.dart';
import 'package:aqua_sense/pages/signalement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// home_page.dart
// Écran d'accueil de l'app : saisit l'attention, présente l'état
// et donne accès au menu (favoris, historique, signalement, etc.).
// Commentaires courts et naturels pour structurer les sections.

class HomePage extends StatefulWidget {
  final VoidCallback? onDiscoverSources;

  const HomePage({super.key, this.onDiscoverSources});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Fonteo",
          style: TextStyle(fontFamily: "MontSerratBold", color: Colors.white),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
        ],
      ),

      // --- Menu latéral (drawer)
      // Accès rapide : favoris, historique, signalement, infos
      endDrawer: Drawer(
        child: ListView(
          children: [
            // ===========================
            // Header du drawer
            // Petite carte d'identité / aide
            // ===========================
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.blue,
                  ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                  )
                ),
                
              child: Column(
                children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          "assets/images/fond_splash.png",
                        ),
                      ),
                    ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "Aide & Infos",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "MontserratItalic",
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                ],
              ),
            ),

            // Favoris — ouvre la page des favoris
            // ===========================
            ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Favoris'
              ),
              subtitle: Text('Retrouvez vos fontaines préférées',
              style: TextStyle(
                fontSize: 12
              ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavorisPage()),
                );
              },
            ),
            Divider(),

            // Historique — liste des recherches précédentes
            // ===========================
            ListTile(
              leading: Icon(Icons.history, color: Colors.indigo),
              title: Text('Historique'
              ),
              subtitle: Text('Consultez les fontaines déjà recherchées',
              style: TextStyle(
                fontSize: 12
              ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoriquePage()),
                );
              },
            ),
            Divider(),

            // Signaler un problème — formulaire de signalement
            // ===========================
            ListTile(
              leading: Icon(Icons.report_problem, color: Colors.orange),
              title: Text('Signaler un problème'
              ),
              subtitle: Text('Aidez-nous à améliorer Fonteo',
              style: TextStyle(
                fontSize: 12
              ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignalerPage()),
                );
              },
            ),
            Divider(),

            // À propos — version et contact
            // ===========================
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.blue),
              title: Text('À propos'),
              subtitle: Text('Version, équipe, contact...',
              style: TextStyle(
                fontSize: 12
              ),
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Fonteo',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2025 Fonteo Team',
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Fonteo est une application qui facilite l’accès à l’eau potable en localisant les fontaines publiques autour de vous. Elle permet de surveiller leur état, de choisir les points d’eau les plus fiables, et encourage une consommation plus écologique en limitant l’usage des bouteilles en plastique.",
                    ),
                    const SizedBox(height: 20),
                    Text('Contact : contact@fonteo.com'),
                  ],
                );
              },
            ),
            Divider(),

            // Notre équipe — courte présentation
            // ===========================
            ListTile(
              leading: Icon(Icons.group, color: Colors.purple),
              title: Text('Qui sommes-nous ?'),
              subtitle: Text('Découvrez l’équipe derrière Fonteo',
              style: TextStyle(
                fontSize: 12
              ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Notre équipe'),
                        content: Text(
                          'Fonteo est développée par une équipe passionnée de technologie et d’environnement, engagée pour un accès durable à l’eau potable.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Fermer'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
      // --- Corps principal
      // Animation d'accueil, résumé du nombre de sources et bouton
      // principal pour découvrir les sources.
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fond_app_icones.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 38),
              Lottie.asset(
                'assets/animations/Animation - 1745597269868.json',
                width: 140,
                height: 140,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    "Bienvenue sur Fonteo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "MontserratBold",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),





              Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(18),
                        ),
                child: Consumer<AppState>(
                  builder: (context, appState, child) {
                    if (appState.waterSources.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Trouvez l’eau la plus saine autour de vous",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: "MontserratItalic",
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                    return FadeIn(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Il y'a ${appState.waterSources.length} sources d'eau autour de vous !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: "MontserratItalic",
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),




              const SizedBox(height: 20),

                  Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  height: 220,
                  child: Stack(
                    children: [
                      RotatedBox(
                        quarterTurns: 1,
                        child: Image.asset("assets/images/map_non_floue.png"),
                      ),
                
                      // Icônes popup sur la carte (exemples visuels)
                      Positioned(
                        top: 75,
                        left: 160,
                        child: CustomPopup(
                          content: Text("Votre santé, notre priorité",  style: TextStyle(fontFamily: "Raleway", fontSize: 13)),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.red.shade400,
                            size: 35,
                          ),
                        ),
                      ),
                
                      Positioned(
                        top: 120,
                        left: 250,
                        child: CustomPopup(
                          content: Text("Buvez une eau de qualité", style: TextStyle(fontFamily: "Raleway", fontSize: 13)),
                          child: Icon(
                            Icons.water_drop_rounded,
                            color: Colors.blue.shade300,
                            size: 35,
                          ),
                        ),
                      ),
                
                      Positioned(
                        right: 150,
                        top: 16,
                        left: 80,
                        child: CustomPopup(
                          content: Text("Trouvez les sources à proximité", style: TextStyle(fontFamily: "Raleway", fontSize: 13)),
                          child: Icon(
                            Icons.water_drop_rounded,
                            color: Colors.blue.shade300,
                            size: 35,
                          ),
                        ),
                      ),
                
                      Positioned(
                        top: 70,
                        left: 30,
                        child: CustomPopup(
                          content: Text("Consultez l’état de l’eau", style: TextStyle(fontFamily: "Raleway", fontSize: 13)),
                          child: Icon(
                            Icons.water_drop_rounded,
                            color: Colors.blue.shade300,
                            size: 35,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 150,
                        left: 110,
                        child: CustomPopup(
                          content: Text("Proposez de nouvelles fontaines", style: TextStyle(fontFamily: "Raleway", fontSize: 13)),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.blue.shade300,
                            size: 35,
                          ),
                        ),
                      ),
                
                    ],
                  ),
                ),



              ElevatedButton(
                onPressed: () {
                  if (widget.onDiscoverSources != null) {
                    widget.onDiscoverSources!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  "Découvrir les sources",
                  style: TextStyle(
                    fontFamily: "MontserratBold",
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
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
