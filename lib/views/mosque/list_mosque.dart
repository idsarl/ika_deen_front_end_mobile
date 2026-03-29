import 'package:flutter/material.dart';

// class ListMosqueScreen extends StatefulWidget {
//   const ListMosqueScreen({super.key});

//   @override
//   State<ListMosqueScreen> createState() => _ListMosqueScreenState();
// }

// class _ListMosqueScreenState extends State<ListMosqueScreen> {
 
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../features/auth/controllers/mosque_controller.dart';

class ListMosqueScreen extends StatelessWidget {
  const ListMosqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MosqueController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Mosquées & Itinéraires", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- PARTIE HAUTE : LA MAP ---
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(target: LatLng(12.6458, -7.9922), zoom: 12),
                markers: controller.manualMosques.map((m) => Marker(
                  markerId: MarkerId(m['name']),
                  position: LatLng(m['lat'], m['lng']),
                  onTap: () => controller.selectMosque(m),
                )).toSet(),
              ),
            ),
          ),

          // --- INFO BULLE (S'affiche quand on clique sur une mosquée) ---
          Obx(() => controller.selectedMosque.isNotEmpty 
            ? _buildSelectedInfo(controller) 
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("Sélectionnez une mosquée sur la carte"),
              )),

          // --- PARTIE BASSE : LISTE MANUELLE ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: controller.manualMosques.length,
              itemBuilder: (context, index) {
                final mosque = controller.manualMosques[index];
                return _buildMosqueItem(mosque, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedInfo(MosqueController controller) {
  final m = controller.selectedMosque;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.black, // Look "Dark Mode" pour le bandeau
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              m['name'], 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
              "Prochaine prière : ${controller.nextPrayerName} à ${controller.prayerTimes[controller.nextPrayerName.value]}",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            )),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71), // Vert rappelant ton AppConstants.primaryColor
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(() => Text(
            "${controller.minutesRemaining} min",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
        )
      ],
    ),
  );
}

  Widget _buildMosqueItem(Map<String, dynamic> mosque, MosqueController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.mosque, color: Colors.teal),
        ),
        title: Text(mosque['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(mosque['address']),
        trailing: const Icon(Icons.directions_outlined, color: Colors.blue),
        onTap: () => controller.selectMosque(mosque),
      ),
    );
  }
}