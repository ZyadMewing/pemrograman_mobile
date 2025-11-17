// lib/model/activity_model.dart

// Ini adalah "blueprint" atau cetakan untuk setiap data aktivitas
// yang akan kita buat.
class ActivityModel {
  final String id; // ID unik untuk membantu proses hapus data
  final String namaAktivitas;
  final String kategori;
  final double durasi; // Slider menghasilkan double
  final bool isSelesai;
  final String? catatan; // Tanda tanya (?) berarti boleh kosong (optional)

  ActivityModel({
    required this.id,
    required this.namaAktivitas,
    required this.kategori,
    required this.durasi,
    required this.isSelesai,
    this.catatan,
  });
}