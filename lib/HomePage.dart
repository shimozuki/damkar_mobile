import 'dart:io';
import 'package:damkar/TipsKeamananPage.dart';
import 'package:damkar/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _foto;
  double? _latitude;
  double? _longitude;
  String _status = '';
  final _deskripsiController = TextEditingController();
  String _jenisBencana = 'Kebakaran';

  final ImagePicker _picker = ImagePicker();

  Future<void> _ambilFoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() => _foto = File(pickedFile.path));
    }
  }

  void _showToast(String message, {bool success = true}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> _ambilLokasi() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _status = 'Izin lokasi ditolak.');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  void _kirimLaporan() async {
    await _ambilLokasi();
    if (_deskripsiController.text.isEmpty || _foto == null) {
      setState(() => _status = 'Lengkapi semua data sebelum melapor.');
      _showToast(
        'Gagal: Lengkapi data sebelum mengirim laporan.',
        success: false,
      );
      return;
    }

    final data = {
      'jenis': _jenisBencana,
      'deskripsi': _deskripsiController.text,
      'latitude': _latitude,
      'longitude': _longitude,
      'foto': _foto?.path,
      'waktu': DateTime.now().toIso8601String(),
    };

    setState(() => _status = 'Laporan berhasil dikirim: \n$data');
    _showToast('Laporan berhasil dikirim!');

    _deskripsiController.clear();
    _foto = null;
  }

  void _bukaFormLapor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Form Laporan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<String>(
                    value: _jenisBencana,
                    items:
                        ['Kebakaran', 'Banjir', 'Gempa', 'Lainnya']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Jenis Bencana',
                    ),
                    onChanged:
                        (value) => setState(
                          () => _jenisBencana = value ?? 'Kebakaran',
                        ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _deskripsiController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi Laporan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_foto != null) Image.file(_foto!, height: 150),
                  ElevatedButton.icon(
                    onPressed: _ambilFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Ambil Foto'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _kirimLaporan,
                    icon: const Icon(Icons.send),
                    label: const Text(
                      'KIRIM LAPORAN',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(_status, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red.shade100,
            radius: 30,
            child: Icon(icon, color: Colors.red, size: 30),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Damkar'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🔥 Waspada Kebakaran Hutan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Hindari membakar lahan di musim kemarau. Laporkan segera jika melihat asap atau api.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Lapor Sekarang
            Center(
              child: ElevatedButton.icon(
                onPressed: _bukaFormLapor,
                icon: const Icon(Icons.report),
                label: const Text(
                  "LAPOR KEBAKARAN / BENCANA",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Menu Grid
            const Text(
              'Menu Utama',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: [
                _buildMenuItem(Icons.shield, "Tips Keamanan", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TipsKeamananPage()),
                  );
                }),
                _buildMenuItem(Icons.school, "Edukasi Bencana", () {}),
                _buildMenuItem(Icons.person, "Profil Saya", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProfilePage(
                            user: {
                              "name": "Nama Saya",
                              "nik": "1234567890",
                              "username": "user",
                              "role": "masyarakat",
                            },
                          ),
                    ),
                  );
                }),
                _buildMenuItem(
                  Icons.location_on,
                  "Laporan Sekitar Saya",
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
