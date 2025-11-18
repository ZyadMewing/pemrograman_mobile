
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
  final List<ActivityModel> _activities = [];

  // --- FUNGSI WARNA & IKON ---
  Color _getCategoryColor(String kategori) {
    switch (kategori) {
      case 'Belajar':
        return Colors.blue;
      case 'Olahraga':
        return Colors.orange;
      case 'Ibadah':
        return Colors.green;
      case 'Hiburan':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String kategori) {
    switch (kategori) {
      case 'Belajar':
        return Icons.book;
      case 'Olahraga':
        return Icons.sports_soccer;
      case 'Ibadah':
        return Icons.mosque;
      case 'Hiburan':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }

  // --- FUNGSI NAVIGASI ---

  void _tambahAktivitas() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityPage()),
    );

    if (result != null && result is ActivityModel) {
      setState(() {
        _activities.add(result);
      });
    }
  }

  // Fungsi ini tadinya 'unused', sekarang kita pastikan terpanggil di bawah
  void _lihatDetail(ActivityModel activity, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityDetailPage(activity: activity),
      ),
    );

    // Refresh halaman setelah kembali dari detail
    setState(() {});

    if (!mounted) return;

    if (result == 'delete') {
      setState(() {
        _activities.removeWhere((item) => item.id == activity.id);
      });

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
        title: const Text(
          'Student Activity Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // Gradasi Navbar Hijau-Merah
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.red],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
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
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                final categoryColor = _getCategoryColor(activity.kategori);

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    // PERBAIKAN DEPRECATED: Ganti .withOpacity() jadi .withValues(alpha: ...)
                    side: BorderSide(
                        color: categoryColor.withValues(alpha: 0.5), width: 1),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    
                    // Bagian Ikon Kiri
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // PERBAIKAN DEPRECATED
                        color: categoryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCategoryIcon(activity.kategori),
                        color: categoryColor,
                      ),
                    ),

                    // Judul & Kategori
                    title: Text(
                      activity.namaAktivitas,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: categoryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                activity.kategori,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.timer_outlined,
                                size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${activity.durasi.toStringAsFixed(1)} Jam',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Bagian Kanan: Tombol Centang Status (Update Langsung)
                    trailing: IconButton(
                      icon: Icon(
                        activity.isSelesai
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: activity.isSelesai
                            ? Colors.green
                            : Colors.grey[400],
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          activity.isSelesai = !activity.isSelesai;
                        });
                      },
                    ),

                    // PERBAIKAN UNUSED ELEMENT:
                    // Memanggil fungsi _lihatDetail saat kartu ditekan
                    onTap: () => _lihatDetail(activity, index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahAktivitas,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Aktivitas'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
    );
  }
}