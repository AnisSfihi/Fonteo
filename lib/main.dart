import 'package:aqua_sense/methods/notif_methods.dart';
import 'package:aqua_sense/models/app_state.dart';
import 'package:aqua_sense/pages/infos_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aqua_sense/pages/home_page.dart';
import 'package:aqua_sense/pages/map_page.dart';
import 'package:aqua_sense/pages/proposer_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

// Ce fichier contient :
// - l'initialisation Firebase et des notifications locales,
// - la demande de permission de notification (Android 13+),
// - le widget racine `MyApp` avec son gestionnaire d'état et la barre de
//   navigation principale.

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); 

Future<void> _requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

// ===========================
// Point d'entrée : main()
// ===========================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  // Initialiser les notifications locales
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('ic_stat_source_colored'); 

  const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings();

  final InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
     iOS: iosInitSettings
  );    

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await _requestNotificationPermission();

  runApp( 
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

// ===========================
// Widget racine : MyApp
// ===========================

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      // Lorsque l'application passe en arrière-plan (paused), on planifie
      // l'envoi d'une notification informant l'utilisateur (après un délai
      // court). Comportement existant conservé.
      if (state == AppLifecycleState.paused) {
        Future.delayed(const Duration(seconds: 20), () {
          showNotificationDesactivation();
        });
      }
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index); 
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
      extendBody: true,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index; 
            });
          },
          children: [
            HomePage(
                onDiscoverSources: () {
                  _pageController.jumpToPage(1);
                },
            ),
            MapPage(),
            ProposerPage(),
            InfosPage(),
          ],
        ),

        // ===========================
        // Barre de navigation inférieure
        // ===========================
        // Icones : Accueil, Carte, Proposer, Infos
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          color: Colors.white,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 350),
          index: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          items: const [
            //Accueil
            Icon(Icons.water_damage_rounded, size: 35, color: Colors.blue,),

            //Map
            Icon(Icons.map_outlined, size: 35, color: Colors.blue),

            //Proposer
            Icon(Icons.water_drop_outlined, size: 35, color: Colors.blue,),

            //Infos
            Icon(Icons.menu_book_outlined, size: 35, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}