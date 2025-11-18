
class ActivityModel {
  final String id; 
  final String namaAktivitas;
  final String kategori;
  final double durasi;
  
  // HAPUS 'final' di dua baris ini agar bisa diedit:
  bool isSelesai; 
  String? catatan; 

  ActivityModel({
    required this.id,
    required this.namaAktivitas,
    required this.kategori,
    required this.durasi,
    required this.isSelesai,
    this.catatan,
  });
}