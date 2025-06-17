import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LaporanSekitarPage extends StatefulWidget {
  const LaporanSekitarPage({super.key});

  @override
  State<LaporanSekitarPage> createState() => _LaporanSekitarPageState();
}

class _LaporanSekitarPageState extends State<LaporanSekitarPage> {
  List<dynamic> laporan = [];

  @override
  void initState() {
    super.initState();
    loadLaporan();
  }

  Future<void> loadLaporan() async {
    final String jsonString = await rootBundle.loadString(
      'assets/laporan_sekitar_saya.json',
    );
    final data = json.decode(jsonString);
    setState(() {
      laporan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121015),
      appBar: AppBar(
        title: const Text("Laporan Sekitar Saya"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body:
          laporan.isEmpty
              ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: laporan.length,
                itemBuilder: (context, index) {
                  final item = laporan[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1C22),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['jenis'],
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.place,
                              color: Colors.white54,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item['lokasi'],
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white54,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item['waktu'],
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['keterangan'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
