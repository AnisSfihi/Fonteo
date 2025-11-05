import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:animate_do/animate_do.dart';
import 'package:aqua_sense/methods/manager.dart';
import 'package:aqua_sense/methods/latest_mesure.dart';
import 'package:aqua_sense/methods/get_route_polyline.dart';
import 'package:aqua_sense/methods/wifi_location.dart';
import 'package:aqua_sense/models/app_state.dart';
import 'package:aqua_sense/models/water_source.dart';
import 'package:aqua_sense/methods/format_duree.dart';
import 'package:aqua_sense/widgets/popup_trajet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:aqua_sense/methods/api_water_source.dart';
import 'package:aqua_sense/widgets/popup_info_widget.dart';
import 'package:provider/provider.dart';

// Page carte — affichage et interaction
// Ce fichier gère l'écran principal de la carte :
// - localisation utilisateur (GPS / Wi‑Fi)
// - affichage des sources d'eau (markers)
// - affichage d'itinéraires (polylines) et durées
// - recherche d'emplacements et popups d'information
// Les commentaires ajoutés sont concis et n'altèrent pas la logique.

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with WidgetsBindingObserver {
  // ===========================
  // Variables
  // ===========================
  final mapTilerKey = dotenv.env['MAPTILER_KEY'];

  bool isRadiusSliderVisible = false;
  double searchRadius = 10;

  Timer? connectivityTimer;

  bool showOnlySelectedSource = false;
  bool isPopupOpen = false;

  StreamSubscription<Position>? positionStream; 

  final ValueNotifier<double> zoomNotifier = ValueNotifier(18.0);

  double zoomLevel = 17;

  bool isSliderVisible = false;

  bool isLoading = true;
  bool isFetchingSources = false;
  bool polylineExist = false;

  bool hasInternet = true;
  bool hasLocationPermission = true;

  String selectedMode = "foot-walking";

  LatLng? userLocation;
  LatLng? selectedLocation;
  LatLng? tempPoint;

  final MapController _mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  List<LatLng> tempPolylinePoints = [];
  List<LatLng> polylinePoints = [];
  List<WaterSource> waterSources = [];

  WaterSource? selectedSource;
  WaterSource? selectedPopupSource;

  // ===========================
  // Initialisation
  // ===========================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeLocation();

    startConnectivityWatcher();
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMove || event is MapEventMoveEnd) {
        zoomNotifier.value = _mapController.camera.zoom;
      }
    });
  }

  // ===========================
  //  Initialisation GPS + WI-FI
  // ===========================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // L’app revient au premier plan → vérifier localisation
      bool locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (locationEnabled && !hasLocationPermission) {
        setState(() {
          isLoading = true;
        });
        _initializeLocation();
      }
    }
  }

  // ===========================
  //  Détruire l'Observer et le connectivityTimer
  // ===========================
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectivityTimer?.cancel();
    super.dispose();
  }

  void startConnectivityWatcher() {
    connectivityTimer?.cancel();

    connectivityTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      bool internetActive = await hasActiveInternet();
      bool locationActive = await Geolocator.isLocationServiceEnabled();

      if (internetActive && !hasInternet) {
        setState(() {
          hasInternet = true;
        });

        if (locationActive) {
          setState(() {
            hasLocationPermission = true;
            isLoading = true;
          });
          _initializeLocation();
        } else {
          setState(() {
            hasLocationPermission = false;
          });
        }
      }
    });
  }

  // ===========================
  //  Initialisation GPS + WI-FI
  // ===========================
  Future<void> _initializeLocation() async {
    try {
      bool isConnected = await hasActiveInternet();
      if (!isConnected) {
        setState(() {
          hasInternet = false;
          isLoading = false;
          userLocation = null;
        });
        return;
      }

      // Vérification localisation
      bool locationOk = await checkLocation();
      if (!locationOk) {
        setState(() {
          hasInternet = true;
          hasLocationPermission = false;
          isLoading = false;
          userLocation = null;
        });
        return;
      }

      // Si tout est bon
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        hasInternet = true;
        hasLocationPermission = true;
        isLoading = false;
      });

      //EXCEPTION EN PLUS PROBLEME
    } on LocationServiceDisabledException {
      if (!mounted) return;
      setState(() {
        userLocation = null;
        isLoading = false;
        hasInternet = true;
        hasLocationPermission = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        userLocation = null;
        isLoading = false;
        hasInternet = false;
        hasLocationPermission = false;
      });
    }
  }

  // ===========================
  // Méthode de cache
  // ===========================
  Future<double?> getCachedTravelDuration(
    LatLng start,
    LatLng end,
    String mode,
  ) async {
    if (!await hasActiveInternet()) {
      Fluttertoast.showToast(
        msg: "Pas de connexion Internet.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }

    final key =
        "${start.latitude},${start.longitude}-${end.latitude},${end.longitude}-$mode";

    if (!mounted) return null;
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.travelDurationCache.containsKey(key)) {
      return appState.travelDurationCache[key];
    }

    try {
      final result = await getTravelDuration(start, end, mode);
      appState.setTravelDuration(key, result); // Mets à jour le cache global
      return result;
    } catch (e) {
      return null;
    }
  }

  // ===========================
  //  Suggestions
  // ===========================
  Future<List<dynamic>> fetchSuggestions(String query) async {
    if (!await hasActiveInternet()) {
      Fluttertoast.showToast(
        msg: "Pas de connexion Internet.",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return [];
    }

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'aqua_sense_app'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data;
      } else {
        Fluttertoast.showToast(
          msg: "Erreur serveur : ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return [];
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur réseau lors de la recherche.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  }

  // ===========================
  //  Méthode pour rechercher un emplacement via une API
  // ===========================
  Future<void> _searchLocation(String query) async {
    if (!await hasActiveInternet()) {
      Fluttertoast.showToast(
        msg: "Pas de connexion Internet.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);
          _mapController.move(
            LatLng(lat, lon),
            17.0,
          ); // Déplacement de la carte
        } else {
          Fluttertoast.showToast(
            msg: "Emplacement introuvable",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur lors de la recherche",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // ===========================
  //  Méthode calculateDistance
  // ===========================
  Future<double> _calculateDistance(
    LatLng userLocation,
    LatLng sourceLocation,
  ) async {
    double distanceInMeters = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      sourceLocation.latitude,
      sourceLocation.longitude,
    );
    return distanceInMeters;
  }

  // ===========================
  //  Méthode startFirstNavigation
  // ===========================
  Future<void> _startFirstNavigation(LatLng start, LatLng end) async {
    if (!await hasActiveInternet()) {
      Fluttertoast.showToast(
        msg: "Pas de connexion Internet.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      //Tentative WALK
      List<LatLng> polylineFoot = await getRoutePolyline(
        start,
        end,
        "foot-walking",
      );

      if (!isPopupOpen) return;

      if (polylineFoot.isNotEmpty) {
        setState(() {
          polylinePoints = polylineFoot;
          polylineExist = true;
          selectedMode = "foot-walking";
          showOnlySelectedSource = true;
        });
        var bounds = LatLngBounds.fromPoints(polylinePoints);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.only(
              bottom: 235,
              top: 130,
              right: 50,
              left: 50,
            ),
            maxZoom: 18,
          ),
        );
        return;
      }

      //Tentative DRIVE
      List<LatLng> polylineCar = await getRoutePolyline(
        start,
        end,
        "driving-car",
      );

      if (polylineCar.isNotEmpty) {
        setState(() {
          polylinePoints = polylineCar;
          polylineExist = true;
          selectedMode = "driving-car";
          showOnlySelectedSource = true;
        });
        var bounds = LatLngBounds.fromPoints(polylinePoints);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.only(
              bottom: 235,
              top: 130,
              right: 50,
              left: 50,
            ),
            maxZoom: 18,
          ),
        );
        return;
      }

      //Aucun itinéraire trouvé
      Fluttertoast.showToast(
        msg: "Impossible d'accès à l'itinéraire !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      //Capture de l'exception réseau
      Fluttertoast.showToast(
        msg: "Erreur de connexion pendant le calcul de l'itinéraire.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }

  // ===========================
  //  Méthode startNavigation FOOT + DRIVE
  // ===========================
  Future<void> _startNavigation(LatLng start, LatLng end, String mode) async {
    if (!await hasActiveInternet()) {
      Fluttertoast.showToast(
        msg: "Pas de connexion Internet.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      tempPolylinePoints = await getRoutePolyline(start, end, mode);

      if (tempPolylinePoints.isEmpty) {
        Fluttertoast.showToast(
          msg: "Impossible d'accès !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      setState(() {
        polylinePoints = tempPolylinePoints;
        polylineExist = true;
        showOnlySelectedSource = true;
      });

      var bounds = LatLngBounds.fromPoints(polylinePoints);

      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.only(
            bottom: 235,
            top: 130,
            right: 50,
            left: 50,
          ),
          maxZoom: 18,
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur lors du tracé de l'itinéraire.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // ===========================
  //  Méthode appState
  // ===========================
  void fetchDataSource(List<WaterSource> result) async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setWaterSources(result);
  }

  // ===========================
  // Construction de l'interface utilisateur
  // ===========================
  @override
  Widget build(BuildContext context) {
    // Affichage d'une animation de chargement si la localisation est en cours
    if (isLoading) {
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
    // Message si la localisation est désactivée

    // Cas 1 : Pas de localisation
    if (!hasLocationPermission) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_off, color: Colors.grey, size: 50),
                const SizedBox(height: 20),
                Text(
                  "Localisation désactivée.\nVeuillez activer la localisation pour afficher la carte.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Geolocator.openLocationSettings();
                  },
                  child: Text(
                    "Activer la localisation",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Cas 2 : Pas d'Internet
    if (!hasInternet) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, color: Colors.grey, size: 50),
              const SizedBox(height: 20),
              Text(
                "Aucune connexion Internet.\nVeuillez activer le Wi-Fi ou les données mobiles.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Affichage principal de la carte
    return Scaffold(
      body: Stack(
        children: [
          // ===========================
          // Carte principale (FlutterMap)
          // ===========================
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: userLocation!,
              initialZoom: 18,
              maxZoom: 20.0,
              minZoom: 3.0,
              interactionOptions: flutter_map.InteractionOptions(
                flags:
                    flutter_map.InteractiveFlag.all &
                    ~flutter_map.InteractiveFlag.rotate,
              ),
              onTap: (_, __) {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  selectedSource = null;
                });
              },
            ),
            children: [
              // Couche de tuiles pour la carte
              TileLayer(
                urlTemplate:
                    "https://api.maptiler.com/maps/topo/{z}/{x}/{y}.png?key=$mapTilerKey",
                userAgentPackageName: 'com.example.app',
              ),
              // ===========================
              // Dessins des polylignes
              // ===========================
              if (polylinePoints.isNotEmpty)
                FadeIn(
                  child: PolylineLayer(
                    polylines: [
                      Polyline(
                        points: polylinePoints,
                        strokeWidth: 7.0,
                        color: Colors.red.shade500,
                      ),
                      Polyline(
                        points: polylinePoints,
                        strokeWidth: 2.0,
                        color: Colors.red.shade300,
                      ),
                    ],
                  ),
                ),

              // ===========================
              // Marqueurs sur la carte
              // ===========================
              MarkerLayer(
                markers: [
                  // Marqueur pour la position de l'utilisateur
                  flutter_map.Marker(
                    point: userLocation!,
                    width: 50,
                    height: 50,
                    child: Stack(
                      children: [
                        ZoomIn(
                          child: CustomPopup(
                            content: Text(
                              "Je suis là !",
                              style: TextStyle(fontFamily: 'Raleway'),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Marqueurs pour les positions des fontaines
                  ...waterSources
                      .where(
                        ((source) =>
                            !showOnlySelectedSource ||
                            source == selectedPopupSource),
                      )
                      .map(
                        (source) => flutter_map.Marker(
                          point: source.location,
                          width: 50,
                          height: 50,
                          child: Stack(
                            children: [
                              // Icône de la source d'eau
                              CustomPopup(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      source.name,
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5),

                                    // Distance entre l'utilisateur et la source
                                    FutureBuilder<double>(
                                      future: _calculateDistance(
                                        userLocation!,
                                        source.location,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text("Erreur");
                                        } else {
                                          final distance = snapshot.data!;
                                          return Text(
                                            "Distance: ${formatDistance(distance)}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Raleway",
                                              color: Colors.blue,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.water_drop,
                                  color: Colors.blue,
                                  size: 50,
                                ),
                              ),

                              // Bouton "Information" pour afficher la popup WIDGET PopupInfoWidget
                              Positioned(
                                left: 30,
                                bottom: 30,
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      selectedPopupSource = source;
                                      isPopupOpen = true;
                                    });

                                    await HistoriqueManager.addToHistorique(
                                      "${source.name}\n${source.location.latitude.toStringAsFixed(5)} | ${source.location.longitude.toStringAsFixed(5)}",
                                    );

                                    if (!mounted) return;

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return PopupInfoWidget(
                                          onClose: () {
                                            setState(() {
                                              isPopupOpen = false;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          sourceName:
                                              selectedPopupSource?.name ??
                                              "Source d'eau",
                                          userLocation: userLocation!,
                                          sourceLocation:
                                              selectedPopupSource!.location,
                                          showItineraireButton: true,
                                          showAvisButton: true,
                                          calculateDistance: _calculateDistance,
                                          formatDuration: formatDuration,
                                          fetchLastMesure: fetchLastMesure,

                                          onStartNavigation: (
                                            start,
                                            end,
                                          ) async {
                                            await _startFirstNavigation(
                                              userLocation!,
                                              selectedPopupSource!.location,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 10,
                                    child: const Icon(
                                      Icons.info,
                                      color: Colors.white,
                                      size: 20,
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
            ],
          ),

          // ===========================
          // Durée de trajet
          // ===========================
          if (polylineExist == true)
            Positioned(
              top: 582,
              right: 60,
              child: ZoomIn(
                child: PopupTrajetWidget(
                  onClose: () {
                    setState(() {
                      polylinePoints.clear();
                      polylineExist = false;
                      showOnlySelectedSource = false;
                    });
                  },
                  onStartWalk: () {
                    setState(() {
                      selectedMode = "foot-walking";
                      polylinePoints.clear();
                    });
                    _startNavigation(
                      userLocation!,
                      selectedPopupSource!.location,
                      "foot-walking",
                    );
                  },
                  onStartDrive: () {
                    setState(() {
                      selectedMode = "driving-car";
                      polylinePoints.clear();
                    });
                    _startNavigation(
                      userLocation!,
                      selectedPopupSource!.location,
                      "driving-car",
                    );
                  },
                  userLocation: userLocation!,
                  sourceLocation: selectedPopupSource!.location,
                  selectedMode: selectedMode,
                  getTravelDuration: getCachedTravelDuration,
                  formatDuration: formatDuration,
                ),
              ),
            ),

          // ===========================
          // Barre de recherche
          // ===========================
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TypeAheadField(
                controller: searchController,
                decorationBuilder: (context, child) {
                  return Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.85, // Réduit la largeur
                    decoration: BoxDecoration(
                      color: Colors.white, // Change la couleur de fond ici
                      borderRadius: BorderRadius.circular(15), // Coins arrondis
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Ombre douce
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: child, // Les suggestions à l'intérieur
                  );
                },

                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Rechercher un emplacement",
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                        onPressed: () {
                          if (searchController.text.trim().isNotEmpty) {
                            _searchLocation(searchController.text.trim());
                          } else {
                            Fluttertoast.showToast(
                              msg: "Veuillez entrer un lieu",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  return await fetchSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.place, color: Colors.blue),
                        title: Text(
                          suggestion['address']['city'] ??
                              suggestion['address']['town'] ??
                              suggestion['address']['village'] ??
                              suggestion['display_name'].split(',')[0],
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          "${suggestion['address']['state'] ?? ''} ${suggestion['address']['country'] ?? ''}\nLat: ${suggestion['lat']}, Lon: ${suggestion['lon']}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      Divider(height: 1, color: Colors.blueGrey[100]),
                    ],
                  );
                },
                onSelected: (suggestion) {
                  double lat = double.parse(suggestion['lat']);
                  double lon = double.parse(suggestion['lon']);
                  _mapController.move(LatLng(lat, lon), 10.0);

                  searchController.clear();

                  FocusScope.of(context).requestFocus(FocusNode());
                },
                emptyBuilder:
                    (context) => const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Aucun résultat trouvé',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
              ),
            ),
          ),

          // ===========================
          // Slider Vertical Zoom
          // ===========================
          Positioned(
            top: 306,
            left: 324,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin:
                      child.key == const ValueKey('slider')
                          ? const Offset(1, 0)
                          : const Offset(0, 0),
                  end:
                      child.key == const ValueKey('slider')
                          ? const Offset(0, 0)
                          : const Offset(1, 0),
                ).animate(animation);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              child:
                  isSliderVisible
                      ? Positioned(
                        key: const ValueKey('slider'),
                        right: 20,
                        top: 305,
                        bottom: 250,
                        child: Column(
                          children: [
                            // Bouton +
                            SizedBox(
                              height: 30,
                              child: FloatingActionButton(
                                heroTag: "zoomPlus",
                                mini: true,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  double newZoom = (zoomNotifier.value + 1)
                                      .clamp(3.0, 20.0);
                                  zoomNotifier.value = newZoom;
                                  _mapController.move(
                                    _mapController.camera.center,
                                    newZoom,
                                  );
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                              ),
                            ),

                            // Slider Zoom
                            RotatedBox(
                              quarterTurns: -1,
                              child: SizedBox(
                                width: 160,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.grey,
                                    inactiveTrackColor: Colors.white,
                                    thumbColor: Colors.white,
                                    overlayColor: Colors.white.withAlpha(60),
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    trackHeight: 4.0,
                                  ),
                                  child: ValueListenableBuilder<double>(
                                    valueListenable: zoomNotifier,
                                    builder: (context, zoom, child) {
                                      return Slider(
                                        padding: const EdgeInsets.all(2),
                                        inactiveColor: Colors.grey,
                                        value: zoom,
                                        min: 3.0,
                                        max: 20.0,
                                        onChanged: (double newZoom) {
                                          setState(() {
                                            _mapController.move(
                                              _mapController.camera.center,
                                              newZoom,
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // Bouton -
                            SizedBox(
                              height: 30,
                              child: FloatingActionButton(
                                heroTag: "zoomMoins",
                                mini: true,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  double newZoom = (zoomNotifier.value - 1)
                                      .clamp(3.0, 20.0);
                                  zoomNotifier.value = newZoom;
                                  _mapController.move(
                                    _mapController.camera.center,
                                    newZoom,
                                  );
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox(key: ValueKey('empty')),
            ),
          ),
        ],
      ),

      // ===========================
      // Boutons flottants
      // ===========================
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 62),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton Slider
            FloatingActionButton(
              heroTag: 'zoomSliderButton',
              onPressed: () {
                setState(() {
                  isSliderVisible = !isSliderVisible;
                });
              },
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              child: Icon(Icons.zoom_in_map, color: Colors.blue),
            ),

            const SizedBox(height: 10),

            // Bouton pour revenir à la position initiale
            FloatingActionButton(
              heroTag: 'locationButton',
              onPressed: () {
                if (userLocation != null) {
                  _mapController.move(userLocation!, 18);
                }
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
            const SizedBox(height: 10),

            // Bouton pour afficher les fontaines
            FloatingActionButton(
              heroTag: 'searchWaterButton',
              onPressed: () async {
                if (userLocation != null) {
                  if (!mounted) return;
                  setState(() {
                    isFetchingSources = true;
                  });

                  try {
                    final sources = await fetchWaterSources(userLocation!);

                    if (!mounted) return;
                    fetchDataSource(sources);

                    setState(() {
                      waterSources = sources;
                    });
                  } catch (e) {
                    if (mounted) {
                      Fluttertoast.showToast(
                        msg: "Erreur lors du chargement des sources !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        isFetchingSources = false;
                      });
                    }
                  }
                }
              },
              backgroundColor: Colors.white,
              child:
                  isFetchingSources
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.blue,
                        ),
                      )
                      : const Icon(
                        Icons.water_drop_outlined,
                        color: Colors.blue,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
