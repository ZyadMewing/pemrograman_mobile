import 'package:flutter/material.dart';
import 'model/activity_model.dart';

// KITA UBAH JADI STATEFULWIDGET AGAR BISA UPDATE TAMPILAN SAAT DIEDIT
class ActivityDetailPage extends StatefulWidget {
  final ActivityModel activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  // Controller untuk edit teks catatan
  final TextEditingController _catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi controller dengan catatan yang sudah ada saat pertama dibuka
    _catatanController.text = widget.activity.catatan ?? '';
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  // FUNGSI: Munculkan Dialog Edit Catatan
  void _showEditCatatanDialog() {
    // Update text field dengan data terbaru
    _catatanController.text = widget.activity.catatan ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: TextField(
            controller: _catatanController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Tulis catatan baru...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Batal
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // SIMPAN PERUBAHAN KE MODEL
                setState(() {
                  widget.activity.catatan = _catatanController.text;
                });
                Navigator.pop(context); // Tutup dialog
                
                // Feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Catatan berhasil diperbarui!')),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _konfirmasiHapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus aktivitas "${widget.activity.namaAktivitas}"?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
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
        title: Text(
          widget.activity.namaAktivitas,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.namaAktivitas,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(widget.activity.kategori),
                    backgroundColor: Colors.white,
                    avatar: const Icon(Icons.category_outlined, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kartu Durasi
            Card(
              child: ListTile(
                leading: const Icon(Icons.timer_outlined, color: Colors.orange),
                title: const Text('Durasi'),
                subtitle: Text('${widget.activity.durasi.toStringAsFixed(1)} Jam'),
              ),
            ),

            // Kartu Status (Bisa di-klik juga di sini kalau mau)
            Card(
              child: ListTile(
                leading: Icon(
                  widget.activity.isSelesai
                      ? Icons.check_circle
                      : Icons.hourglass_top_outlined,
                  color: widget.activity.isSelesai ? Colors.green : Colors.grey,
                ),
                title: const Text('Status'),
                subtitle: Text(
                    widget.activity.isSelesai ? 'Sudah Selesai' : 'Belum Selesai'),
                trailing: Switch(
                  value: widget.activity.isSelesai,
                  onChanged: (value) {
                    setState(() {
                      widget.activity.isSelesai = value;
                    });
                  },
                ),
              ),
            ),

            // Kartu Catatan dengan Tombol Edit
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.notes_outlined, color: Colors.purple),
                            SizedBox(width: 12),
                            Text('Catatan Tambahan',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // TOMBOL EDIT KECIL
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Edit Catatan',
                          onPressed: _showEditCatatanDialog,
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      (widget.activity.catatan == null || widget.activity.catatan!.isEmpty)
                          ? 'Tidak ada catatan.'
                          : widget.activity.catatan!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Tombol Hapus
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                label:
                    const Text('Hapus Aktivitas', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _konfirmasiHapus(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}