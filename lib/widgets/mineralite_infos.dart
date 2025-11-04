import 'package:flutter/material.dart';

// Slider Minéralité — fiches d'information
//
// Affiche une série de cartes déroulantes décrivant les principaux minéraux
// présents dans l'eau (Calcium, Magnésium, Potassium, Sodium, etc.). Pour
// chaque minéral :
// - plage/valeur de référence,
// - rôle et impact sur la santé / les installations,
// - conseil ou avertissement.
//
/// Widget MineraliteInfosSlider
/// Affiche une liste déroulante de fiches d'information sur la minéralité de l'eau
/// Widget affichant les informations sur la minéralité sous forme de cartes déroulantes
class MineraliteInfosSlider extends StatelessWidget {
  const MineraliteInfosSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // Liste des fiches de minéraux
        children: [
      
          /// Section Potassium
          /// Affiche les informations sur le potassium dans l'eau :
          /// - Valeur maximale recommandée
          /// - Impact sur la santé
          /// - Avertissement pour les personnes sensibles
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.local_florist, color: Colors.green, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Potassium",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Affichage de la valeur de référence
                          // Structure commune à toutes les fiches :
                          // - Icône goutte d'eau en teinte teal
                          // - Texte de la valeur en italique
                          Row(
                            children: [
                              Icon(Icons.water_drop, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                "Valeur max : 12 mg/L",
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Le potassium est un minéral présent naturellement dans l’eau. Il est généralement inoffensif à faibles doses, mais des concentrations élevées peuvent signaler une pollution agricole ou industrielle.",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Boîte d'avertissement/conseil
                          // - Fond coloré léger assorti à la couleur du minéral
                          // - Icône d'information et texte explicatif
                          // - Bordures arrondies pour style cohérent
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.green),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "💡 Risqué pour les personnes atteintes d’insuffisance rénale à forte concentration.",
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Calcium
          /// Affiche les informations sur le calcium dans l'eau :
          /// - Plage de valeurs idéale
          /// - Rôle dans la dureté de l'eau
          /// - Impact sur les installations
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.blueGrey, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Calcium",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.water_drop, color: Colors.teal),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Valeur idéale : entre 60 et 120 mg/L",
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Le calcium est essentiel pour les os et les dents. Il détermine en grande partie la dureté de l’eau. En excès, il peut provoquer des dépôts de calcaire dans les canalisations.",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blueGrey),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "💡 Trop de calcium rend l’eau « dure » et réduit l’efficacité des appareils électroménagers.",
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Sulfates
          /// Affiche les informations sur les sulfates dans l'eau :
          /// - Valeur limite réglementaire
          /// - Effets sur le goût de l'eau
          /// - Précautions pour les nourrissons
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.eco_outlined, color: Colors.purple, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Sulfates",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child:
                          Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.water_drop, color: Colors.teal),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Valeur limite : 250 mg/L",
                                            style: TextStyle(
                                              fontFamily: "Raleway",
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        "Les sulfates sont des sels naturels. En excès, ils peuvent donner un goût amer à l’eau et provoquer des troubles digestifs chez les personnes sensibles.",
                                        style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade50,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info_outline, color: Colors.purple),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "💡 Une eau trop riche en sulfates n’est pas recommandée pour les nourrissons.",
                                              style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Magnésium
          /// Affiche les informations sur le magnésium dans l'eau :
          /// - Valeur recommandée maximale
          /// - Importance pour la santé
          /// - Effets secondaires possibles
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.bubble_chart_outlined,
                        color: Colors.deepOrange,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Magnésium",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
      
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: 
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Valeur recommandée : ≤ 50 mg/L",
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Le magnésium est essentiel pour le métabolisme humain. Une concentration modérée est bénéfique, mais en excès, il peut altérer le goût de l’eau et causer des dépôts dans les tuyauteries.",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.deepOrange),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "💡 Trop de magnésium peut rendre l’eau laxative pour certaines personnes.",
                                        style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Sodium
          /// Affiche les informations sur le sodium dans l'eau :
          /// - Valeur recommandée maximale
          /// - Sources et implications
          /// - Risques pour populations sensibles
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.scatter_plot_outlined,
                        color: Colors.indigo,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Sodium",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
      
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: 
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.water_drop, color: Colors.teal),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Valeur recommandée : ≤ 200 mg/L",
                                        style: TextStyle(
                                          fontFamily: "Raleway",
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Le sodium peut provenir de sources naturelles ou de rejets humains. Une forte teneur en sodium peut poser des risques pour les personnes souffrant d’hypertension ou suivant un régime sans sel.",
                                    style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, color: Colors.indigo),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "💡 Une eau riche en sodium n’est pas adaptée aux personnes ayant des maladies cardiaques.",
                                          style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Chlorures
          /// Affiche les informations sur les chlorures dans l'eau :
          /// - Valeur limite réglementaire
          /// - Lien avec le sodium
          /// - Impact sur le goût et la corrosion
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.ac_unit_outlined, color: Colors.teal, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Chlorures",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
      
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: 
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Valeur limite : 250 mg/L",
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Les chlorures sont souvent associés au sodium. Une concentration élevée donne un goût salé à l’eau et peut corroder les canalisations métalliques.",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.teal),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "💡 Un goût salé dans l’eau peut être un indicateur d’une pollution par les chlorures.",
                                        style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
          /// Section Nitrates
          /// Affiche les informations sur les nitrates dans l'eau :
          /// - Limite légale stricte
          /// - Sources agricoles
          /// - Danger pour les nourrissons
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: 
                    Row(
                      children: [
                        Icon(Icons.science_outlined, color: Colors.redAccent, size: 28),
                        SizedBox(width: 10),
                        Text(
                          "Nitrates",
                          style: TextStyle(
                            fontFamily: "MontserratBold",
                            fontSize: 20,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: 
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Limite légale : 50 mg/L",
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Les nitrates proviennent surtout des engrais agricoles. Un taux trop élevé peut être dangereux pour les nourrissons et causer la méthémoglobinémie (maladie du bébé bleu).",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.redAccent),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "⚠️ L’eau contenant plus de 50 mg/L de nitrates n’est pas potable pour les nourrissons.",
                                        style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Nitrites
          /// Affiche les informations sur les nitrites dans l'eau :
          /// - Limite légale très stricte
          /// - Indicateur de contamination
          /// - Risques sanitaires importants
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: 
                    Row(
                      children: [
                        Icon(Icons.warning_amber_outlined, color: Colors.deepPurple, size: 28),
                        SizedBox(width: 10),
                        Text(
                          "Nitrites",
                          style: TextStyle(
                            fontFamily: "MontserratBold",
                            fontSize: 20,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: 
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Limite légale : 0.1 mg/L",
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Les nitrites sont issus de la dégradation des nitrates ou d’une pollution récente. Leur présence est un indicateur d’une contamination microbiologique ou d’une eau non traitée.",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.deepPurple),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "⚠️ À très faible dose seulement ! Toute présence de nitrites est préoccupante.",
                                        style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Résidus secs
          /// Affiche les informations sur les résidus secs dans l'eau :
          /// - Valeur recommandée maximale
          /// - Définition et signification
          /// - Impact sur la qualité de l'eau
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: 
                              Row(
                                children: [
                                  Icon(Icons.grid_4x4, color: Colors.brown, size: 28),
                                  SizedBox(width: 10),
                                  Text(
                                    "Résidus secs",
                                    style: TextStyle(
                                      fontFamily: "MontserratBold",
                                      fontSize: 20,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: 
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Recommandé : ≤ 1000 mg/L",
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Les résidus secs représentent la quantité totale de minéraux dissous dans l’eau après évaporation. Au-delà de 1000 mg/L, l’eau est considérée comme très minéralisée et peut ne pas convenir à tous les consommateurs.",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.brown.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.brown),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "💡 Plus les résidus secs sont élevés, plus l’eau est chargée en minéraux – ce qui peut être bon ou mauvais selon les cas.",
                                        style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          /// Section Bicarbonates
          /// Affiche les informations sur les bicarbonates dans l'eau :
          /// - Plage normale de présence
          /// - Rôle dans l'équilibre du pH
          /// - Bénéfices pour les canalisations
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: 
                              Row(
                                children: [
                                  Icon(Icons.science, color: Colors.lightBlue, size: 28),
                                  SizedBox(width: 10),
                                  Text(
                                    "Bicarbonates",
                                    style: TextStyle(
                                      fontFamily: "MontserratBold",
                                      fontSize: 20,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ],
                              ),
                  iconColor: Colors.blue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Présence normale : entre 100 et 400 mg/L",
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Les bicarbonates régulent le pH de l’eau et jouent un rôle tampon. Leur présence est normale et bénéfique, notamment pour protéger les tuyaux contre la corrosion acide.",
                                  style: TextStyle(fontFamily: "Raleway", fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.lightBlue),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "💡 Une eau équilibrée en bicarbonates contribue à un bon goût et à la stabilité du pH.",
                                        style: TextStyle(fontFamily: "Raleway", fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}
