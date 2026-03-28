
import 'package:flutter/material.dart';

class RadioTvScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Radio & TV Direct")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          _buildChannelItem("ORTM 1", "Télévision Nationale", Icons.tv),
          _buildChannelItem("Radio Mali", "91.2 FM", Icons.radio),
          _buildChannelItem("Joliba TV", "Information en continu", Icons.live_tv),
        ],
      ),
    );
  }

  Widget _buildChannelItem(String name, String desc, IconData icon) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: Icon(Icons.play_circle_fill, color: Colors.teal, size: 30),
        onTap: () { /* Lancer le flux vidéo/audio */ },
      ),
    );
  }
}