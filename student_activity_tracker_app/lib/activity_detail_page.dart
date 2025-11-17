// lib/activity_detail_page.dart

import 'package:flutter/material.dart';
import 'model/activity_model.dart'; // Impor model kita

class ActivityDetailPage extends StatelessWidget {
  // Halaman ini menerima data 'activity' dari HomePage
  final ActivityModel activity;

  const ActivityDetailPage({super.key, required this.activity});

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _konfirmasiHapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus aktivitas "${activity.namaAktivitas}"?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Tutup dialog
                Navigator.of(dialogContext).pop(); 
                // Kirim sinyal 'delete' kembali ke HomePage
                Navigator.pop(context, 'delete'); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.namaAktivitas),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container untuk info utama
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.namaAktivitas,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(activity.kategori),
                    avatar: const Icon(Icons.category_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detail lainnya menggunakan Card dan ListTile
            Card(
              child: ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: const Text('Durasi'),
                subtitle: Text('${activity.durasi.toStringAsFixed(1)} Jam'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(
                  activity.isSelesai
                      ? Icons.check_circle_outline
                      : Icons.hourglass_top_outlined,
                  color: activity.isSelesai ? Colors.green : Colors.orange,
                ),
                title: const Text('Status'),
                subtitle: Text(activity.isSelesai ? 'Sudah Selesai' : 'Belum Selesai'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notes_outlined),
                title: const Text('Catatan Tambahan'),
                subtitle: Text(activity.catatan ?? 'Tidak ada catatan.'),
              ),
            ),
            
            // Spacer untuk mendorong tombol ke bawah
            const Spacer(), 

            // Tombol-tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Kembali
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali'),
                    onPressed: () {
                      Navigator.pop(context); // Cukup tutup halaman
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // Tombol Hapus
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    label: const Text('Hapus', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _konfirmasiHapus(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Warna merah untuk hapus
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Padding bawah
          ],
        ),
      ),
    );
  }
}