import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';

class RamadhanRoutinePage extends StatelessWidget {
  const RamadhanRoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor, // Vert foncé
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white),
        title: const Text('Ramadhan Routine',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tune, color: Colors.white))
        ],
      ),
      body: Column(
        children: [
          _buildCalendarHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildSkippedAlert(),
                const SizedBox(height: 20),
                _buildSectionHeader(),
                const SizedBox(height: 10),
                _buildFilterChips(),
                const SizedBox(height: 20),
                // Exemples de tâches
                const TaskCard(
                    title: "Tahajjud Prayer",
                    time: "02.30 AM - 03.30 AM",
                    status: TaskStatus.skipped),
                const TaskCard(
                    title: "Sahoor",
                    time: "AM - 04.30 AM",
                    status: TaskStatus.done),
                const TaskCard(
                    title: "Fajr Prayer",
                    time: "04.45 AM - 05.15 AM",
                    status: TaskStatus.done),
                const TaskCard(
                    title: "Reading Quran",
                    time: "05.30 AM - 06.30 AM",
                    status: TaskStatus.done),
                const TaskCard(
                    title: "Dhuhr Prayer",
                    time: "12.30 PM - 01.00 PM",
                    status: TaskStatus.ongoing),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Your Activity",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          "4/14",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: AppConstants.primaryColor, // Même vert que l'AppBar
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(7, (index) {
            bool isSelected = index == 0; // Exemple: Samedi 12 est sélectionné
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF4C9A74) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  Text(['Sam', 'Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven'][index],
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text('${12 + index}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSkippedAlert() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.error, color: Colors.black, size: 28),
              SizedBox(width: 10),
              Text(
                "Skipped 1 Activity Today",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text("New Task"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C9A74),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      // Ajout du scroll pour éviter l'overflow
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none, // Pour que l'ombre ne soit pas coupée
      child: Row(
        children: [
          _filterChip("All", "14", isSelected: true),
          const SizedBox(width: 8),
          _filterChip("Done", "3", color: const Color(0xFF4C9A74)),
          const SizedBox(width: 8),
          _filterChip("Ongoing", "12", color: const Color(0xFF2D3142)),
          const SizedBox(width: 8),
          _filterChip("Skipped", "1", color: Colors.grey),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String count,
      {bool isSelected = false, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4C9A74).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color ?? Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(count,
                style: const TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

enum TaskStatus { done, ongoing, skipped }

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final TaskStatus status;

  const TaskCard(
      {required this.title,
      required this.time,
      required this.status,
      super.key});

  @override
  Widget build(BuildContext context) {
    // Animation douce de la couleur et de la taille
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: status == TaskStatus.done
            ? const LinearGradient(
                colors: [Color(0xFF4C9A74), Color(0xFF2E7D32)])
            : null,
        color: status == TaskStatus.skipped ? Colors.grey[400] : Colors.white,
        border: status == TaskStatus.ongoing
            ? Border.all(color: Colors.grey.shade300)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: status == TaskStatus.done
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: status == TaskStatus.done
                        ? Colors.white70
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          _buildTrailingIcon(),
        ],
      ),
    );
  }

  Widget _buildTrailingIcon() {
    if (status == TaskStatus.done) {
      return const Icon(Icons.check_circle, color: Colors.white);
    } else if (status == TaskStatus.ongoing) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
      );
    }
    return const SizedBox.shrink();
  }
}
