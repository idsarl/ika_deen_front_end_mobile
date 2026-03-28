import 'package:flutter/material.dart';
// Pour des animations Lottie (ex: Kaaba qui tourne doucement)
// import 'package:lottie/lottie.dart';

class UmraGuideScreen extends StatefulWidget {
  const UmraGuideScreen({super.key});

  @override
  _UmraGuideScreenState createState() => _UmraGuideScreenState();
}

class _UmraGuideScreenState extends State<UmraGuideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white, // Vert foncé pour la sérénité
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Guide de l'Umra Step-by-Step",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/umra_g.jpeg', fit: BoxFit.cover),
                  DecoratedBox(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.4))),
                  // Optionnel : Une animation Lottie douce
                  // Center(child: Lottie.network('https://assets3.lottiefiles.com/packages/lf20_xyz.json', height: 150)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildUmraStep(
                      "1",
                      "Préparation & Ihram",
                      "Mise en état de sacralisation, intentions et Talbiyah.",
                      Icons.check_circle_outline),
                  _buildUmraStep(
                      "2",
                      "Tawaf",
                      "Les 7 tours autour de la Kaaba, suivis de 2 Rakaats.",
                      Icons.directions_run_outlined),
                  _buildUmraStep(
                      "3",
                      "Sa'y",
                      "Le parcours entre Safa et Marwah (7 fois).",
                      Icons.swap_calls_outlined),
                  _buildUmraStep(
                      "4",
                      "Halq ou Taqsir",
                      "Se raser ou se couper les cheveux pour sortir de l'Ihram.",
                      Icons.content_cut_outlined),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUmraStep(
      String number, String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF00897B),
          child: Text(number,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black)),
        subtitle:
            Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        children: [
          // Détails de l'étape
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Invocations recommandées :",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 5),
                const Text(
                    "C'est ici que tu peux mettre le texte de l'invocation en arabe et sa traduction...",
                    style: TextStyle(fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Icon(icon, color: Colors.teal, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
