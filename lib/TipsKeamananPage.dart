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
      'assets/TipsKeamanan.json',
    );
    final Map<String, dynamic> data = json.decode(response);
    setState(() {
      tips = data['tips_keamanan'];
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tips Keamanan Damkar'),
        backgroundColor: Colors.red,
      ),
      body:
          tips.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  final item = tips[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.fire_extinguisher, color: Colors.red),
                      title: Text(
                        item['judul'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item['deskripsi']),
                      trailing: IconButton(
                        icon: Icon(Icons.play_circle_fill, color: Colors.red),
                        onPressed: () {
                          final url = item['link_video'];
                          // Bisa tambahkan logic buka url YouTube pakai url_launcher
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
