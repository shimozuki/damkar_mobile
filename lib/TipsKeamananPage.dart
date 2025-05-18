import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TipsKeamananPage extends StatefulWidget {
  @override
  _TipsKeamananPageState createState() => _TipsKeamananPageState();
}

class _TipsKeamananPageState extends State<TipsKeamananPage> {
  List<dynamic> tips = [];

  @override
  void initState() {
    super.initState();
    loadTipsFromJson();
  }

  Future<void> loadTipsFromJson() async {
    final String response = await rootBundle.loadString(
      'assets/data/tips_keamanan.json',
    );
    final data = json.decode(response);
    setState(() {
      tips = data;
    });
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tips Keamanan Damkar'),
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text(
                'Menu Damkar',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildMenuItem(Icons.shield, "Tips Keamanan", () {
              Navigator.pop(context);
            }),
            _buildMenuItem(Icons.school, "Edukasi Bencana", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/edukasi_bencana');
            }),
            _buildMenuItem(Icons.person, "Profil Saya", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profil_saya');
            }),
          ],
        ),
      ),
      body:
          tips.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.fire_extinguisher, color: Colors.red),
                      title: Text(
                        tips[index]["judul"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(tips[index]["deskripsi"]),
                    ),
                  );
                },
              ),
    );
  }
}
