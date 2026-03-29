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
//  Widget featureIcon(IconData icon, String label, Color color,
//     {VoidCallback? onTap}) {
//   return InkWell(
//     // Utilisation de InkWell pour l'effet de pression visuel
//     onTap: onTap,
//     child: Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1), // Fond coloré très léger
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Icon(icon, size: 26, color: color), // Icône assortie
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(
//               fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
//         ),
//       ],
//     ),
//   );
// }
Widget featureIcon(IconData icon, String label, Color color,
    {VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius:
        BorderRadius.circular(18), // Pour que l'effet ripple soit propre
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important pour l'alignement vertical
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1, // Garde le texte sur une ligne
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // Coupe avec "..." si trop long
            style: const TextStyle(
              fontSize: 11, // Un poil plus petit pour laisser de la place
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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

//param liste widget
Widget buildSettingsGroup(List<Widget> tiles) {
  return Container(
    decoration: softCardDecoration(Colors.white),
    child: Column(children: tiles),
  );
}

// Widget buildSettingsTile(IconData icon, String title, {VoidCallback? onTap}) {
//   return ListTile(
//     leading: Icon(icon, color: Colors.black87),
//     title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//     trailing: const Icon(Icons.chevron_right, size: 20),
//     onTap: onTap,
//   );
// }

Widget buildSettingsTile(IconData icon, String title,
    {VoidCallback? onTap, String? subtitle, Color? color}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (color ?? Colors.black87).withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color ?? Colors.black87, size: 22),
    ),
    title: Text(
      title,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black),
    ),
    subtitle: subtitle != null
        ? Text(subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54))
        : null,
    trailing: const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
    onTap: onTap,
  );
}

BoxDecoration softCardDecoration(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
