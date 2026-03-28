import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class ZakatCalculatorScreen extends StatelessWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculatrice de Zakat")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Carte d'information sur le Nisab
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppConstants.primaryColor),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                          "Le Nisab actuel est estimé à : 3 500 000 FCFA")),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Champ de saisie
            const TextField(
              decoration: InputDecoration(
                labelText: "Total de vos économies (Cash, Or, etc.)",
                border: OutlineInputBorder(),
                suffixText: "FCFA",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {/* Calculer 2.5% */},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor),
              child: const Text(
                "Calculer mon montant",
                style: TextStyle(color: AppConstants.backgroundColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
