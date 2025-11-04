import 'package:aqua_sense/widgets/le_saviez_vous.dart';
import 'package:aqua_sense/widgets/mineralite_infos.dart';
import 'package:aqua_sense/widgets/parametre_infos.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// infos_page.dart
// Page d'informations : paramètre de l'eau, minéralité et faits utiles.
// Simple carrousel de trois écrans informatifs pour l'utilisateur.

class InfosPage extends StatefulWidget {
  const InfosPage({super.key});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fond_app_icones.png"),
              fit: BoxFit.cover,
            ),
        ),
        child: SafeArea(
            child: Column(
              children: [
                // --- En-tête
                Padding(padding: EdgeInsets.all(20)),
                Center(child: Text("Informations", style: TextStyle(fontFamily: "MontserratBold", fontSize: 30, color: Colors.white))),
                const SizedBox(height: 20,),
                Container(
                    height: 7,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                ),
                const SizedBox(height: 10,),
                  // --- Indicateurs de page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3, 
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index ? Colors.white : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),



                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 1.0,
                        height: MediaQuery.of(context).size.height * 0.75,
                        onPageChanged: (index, reason){
                            setState(() {
                              _currentIndex = index;
                            });
                        }
                    ),
                    items: [
                        // Trois écrans informatifs
                        ParametreInfosSlider(),
                        MineraliteInfosSlider(),
                        LeSaviezVousSlider(),
                      ]
                  ),
                ),
              ],
            ),
          ),
    );
  }
}