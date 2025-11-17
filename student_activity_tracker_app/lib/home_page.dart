// lib/home_page.dart

import 'package:flutter/material.dart';
import 'add_activity_page.dart'; // Impor halaman Add
import 'activity_detail_page.dart'; // Impor halaman Detail
import 'model/activity_model.dart'; // Impor Model

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ini adalah "State" atau data yang akan kita kelola di halaman ini.
  // Ini adalah daftar (List) yang akan menampung semua aktivitas.
  final List<ActivityModel> _activities = [];

  // Fungsi untuk navigasi ke halaman Tambah Aktivitas
  void _tambahAktivitas() async {
    // Kita 'push' (buka) halaman AddActivityPage dan 'await' (menunggu)
    // hasilnya (data aktivitas baru).
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityPage()),
    );

    // Jika kita mendapat hasil (result != null) dan hasilnya adalah
    // ActivityModel, maka tambahkan ke daftar kita.
    if (result != null && result is ActivityModel) {
      // Kita gunakan setState() untuk memberi tahu Flutter bahwa ada
      // perubahan data, sehingga UI perlu di-render ulang.
      setState(() {
        _activities.add(result);
      });
    }
  }

  // Fungsi untuk navigasi ke halaman Detail
  void _lihatDetail(ActivityModel activity, int index) async {
    // Kita kirim 'activity' yang dipilih ke ActivityDetailPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityDetailPage(activity: activity),
      ),
    );

    // Jika halaman detail mengembalikan sinyal 'delete'
    if (result == 'delete') {
      setState(() {
        // Hapus aktivitas dari daftar berdasarkan ID-nya
        _activities.removeWhere((item) => item.id == activity.id);
      });

      // Tampilkan SnackBar sebagai feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aktivitas "${activity.namaAktivitas}" telah dihapus.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Activity Tracker'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.red], // Gradasi Hijau ke Merah
              begin: Alignment.centerLeft, // Mulai dari Kiri
              end: Alignment.centerRight, // Selesai di Kanan
            ),
          ),
        ),
      ),
      body: _activities.isEmpty
          ? const Center(
              child: Text(
                'Belum ada aktivitas.\nTekan tombol ➕ untuk menambah.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          // Jika daftar tidak kosong, tampilkan ListView.builder
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              // Jumlah item di list = panjang data _activities
              itemCount: _activities.length,
              // builder akan dipanggil untuk setiap item
              itemBuilder: (context, index) {
                final activity = _activities[index];

                // Gunakan Card untuk tampilan yang lebih rapi
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    // Tampilan item di daftar
                    leading: Icon(
                      activity.isSelesai
                          ? Icons.check_circle_outline
                          : Icons.hourglass_top,
                      color: activity.isSelesai ? Colors.green : Colors.orange,
                    ),
                    title: Text(
                      activity.namaAktivitas,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Kategori: ${activity.kategori}'),
                    trailing: Text('${activity.durasi.toStringAsFixed(1)} Jam'),
                    onTap: () {
                      // Panggil fungsi _lihatDetail saat item di-tap
                      _lihatDetail(activity, index);
                    },
                  ),
                );
              },
            ),

      // Tombol ➕ (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahAktivitas,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Aktivitas'),
        tooltip: 'Tambah Aktivitas Baru',
      ),
    );
  }
}
