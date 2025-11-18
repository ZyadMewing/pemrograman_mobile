
import 'package:flutter/material.dart';
import 'model/activity_model.dart'; // Impor model kita

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  // Controller untuk mengambil teks dari TextField
  final _namaController = TextEditingController();
  final _catatanController = TextEditingController();

  // Variabel untuk menyimpan nilai dari form
  String _kategori = 'Belajar'; // Nilai default dropdown
  double _durasi = 1.0; // Nilai default slider
  bool _isSelesai = false; // Nilai default switch

  // Daftar pilihan untuk dropdown
  final List<String> _kategoriOptions = [
    'Belajar',
    'Ibadah',
    'Olahraga',
    'Hiburan',
    'Lainnya',
  ];

  // Fungsi untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error Validasi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menyimpan data
  void _simpanAktivitas() {
    // 1. Validasi
    if (_namaController.text.isEmpty) {
      _showErrorDialog('Nama aktivitas wajib diisi.');
      return; // Hentikan fungsi jika nama kosong
    }

    // 2. Buat objek ActivityModel baru
    final newActivity = ActivityModel(
      // Buat ID unik sederhana berdasarkan waktu
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      namaAktivitas: _namaController.text,
      kategori: _kategori,
      durasi: _durasi,
      isSelesai: _isSelesai,
      catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
    );

    // 3. Kirim data baru kembali ke HomePage
    // Kita 'pop' (tutup) halaman ini dan mengirim 'newActivity'
    // sebagai hasilnya.
    Navigator.pop(context, newActivity);
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget tidak lagi digunakan
    _namaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Aktivitas Baru'),
      // SingleChildScrollView agar halaman bisa di-scroll
      // jika keyboard muncul dan menutupi form
      flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.red], // Gradasi sama persis
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. TextField Nama Aktivitas
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Aktivitas',
                hintText: 'Contoh: Mengerjakan tugas Flutter',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // 2. Dropdown Kategori
            DropdownButtonFormField<String>(
              initialValue:
                  _kategori, // <-- Ganti 'value' menjadi 'initialValue'
              decoration: const InputDecoration(
                labelText: 'Kategori Aktivitas',
                border: OutlineInputBorder(),
              ),
              items: _kategoriOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _kategori = newValue!;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // 3. Slider Durasi
            Text('Durasi: ${_durasi.toStringAsFixed(1)} Jam'),
            Slider(
              value: _durasi,
              min: 1.0,
              max: 8.0,
              divisions: 14, // (8-1) * 2 = 14 (untuk interval 0.5 jam)
              label: _durasi.toStringAsFixed(1),
              onChanged: (newValue) {
                setState(() {
                  // Kita bulatkan ke 0.5 terdekat
                  _durasi = (newValue * 2).round() / 2;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // 4. Switch Status
            SwitchListTile(
              title: const Text('Status Aktivitas'),
              subtitle: Text(_isSelesai ? 'Sudah Selesai' : 'Belum Selesai'),
              value: _isSelesai,
              onChanged: (newValue) {
                setState(() {
                  _isSelesai = newValue;
                });
              },
              secondary: Icon(
                _isSelesai ? Icons.check_circle : Icons.hourglass_empty,
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16.0),

            // 5. TextField Catatan
            TextField(
              controller: _catatanController,
              decoration: const InputDecoration(
                labelText: 'Catatan Tambahan (Optional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3, // Membuatnya jadi multiline
            ),
            const SizedBox(height: 24.0),

            // 6. Tombol Simpan
            ElevatedButton(
              onPressed: _simpanAktivitas,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
