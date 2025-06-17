import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class EdukasiBencanaPage extends StatefulWidget {
  const EdukasiBencanaPage({super.key});

  @override
  State<EdukasiBencanaPage> createState() => _EdukasiBencanaPageState();
}

class _EdukasiBencanaPageState extends State<EdukasiBencanaPage> {
  List<dynamic> edukasi = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final String response = await rootBundle.loadString(
      'assets/edukasi_bencana.json',
    );
    final data = json.decode(response);
    setState(() {
      edukasi = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121015),
      appBar: AppBar(
        title: const Text("Edukasi Bencana"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: edukasi.length,
        itemBuilder: (context, index) {
          final item = edukasi[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: item['video_id'],
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.redAccent,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['judul'],
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['deskripsi'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
