import 'package:flutter/material.dart';

Widget btn(
    String text,
    Color color,
    Color textColor, // Ajout du type Color pour plus de clarté
    VoidCallback onPress,
    {bool? isLoading}) {
  // On traite le null comme false par défaut
  final bool loading = isLoading ?? false;

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      // On désactive le clic si on est en train de charger
      onPressed: loading ? null : onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        // Couleur quand le bouton est désactivé (pendant le chargement)
        disabledBackgroundColor: color.withOpacity(0.6),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
}

Widget btnSmall2ByRow(
    String text,
    Color color,
    Color textColor,
    VoidCallback onPress,
    String text2,
    Color color2,
    Color textColor2,
    VoidCallback onPresse) {
  return SizedBox(
    width: double.infinity, // Make the Row take the full width
    child: Row(
      children: [
        // First Button
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                onPress();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                // padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child:
                  Text(text, style: TextStyle(fontSize: 18, color: textColor)),
            ),
          ),
        ),
        const SizedBox(width: 8), // Space between the buttons

        // Second Button
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                onPresse();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color2,
                // padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(text2,
                  style: TextStyle(fontSize: 18, color: textColor2)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildAppBarAction(
    {required IconData icon, required VoidCallback onPressed}) {
  return Container(
    margin:
        const EdgeInsets.symmetric(vertical: 22), // Pour centrer verticalement
    decoration: BoxDecoration(
      color: Colors.grey[100], // Fond gris très clair
      borderRadius: BorderRadius.circular(12),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: const Color(0xFF2D6A4F), size: 22),
      splashRadius: 25,
    ),
  );
}

//icon et texte en bas
Widget featureIcon(IconData icon, String label, Color color,
    {VoidCallback? onTap}) {
  return InkWell(
    // Utilisation de InkWell pour l'effet de pression visuel
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // Fond coloré très léger
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, size: 26, color: color), // Icône assortie
        ),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

// Petit helper pour l'animation de fondu/montée
Widget buildAnimatedItem({required Widget child, required int delay}) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0, end: 1),
    duration: Duration(milliseconds: 600 + delay),
    builder: (context, double value, child) {
      return Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      );
    },
    child: child,
  );
}
