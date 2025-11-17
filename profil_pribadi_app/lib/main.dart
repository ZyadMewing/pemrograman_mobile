import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilPribadiApp());
}

class ProfilPribadiApp extends StatelessWidget {
  const ProfilPribadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APLIKASI PROFIL SAYA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      home: const ProfilScreen(),
    );
  }
}

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  // --- Data Profil ---
  final String namaLengkap = "Rifqi Ziyad Fulvian";
  final String profesi = "Mahasiswa";
  final String deskripsiSingkat =
      "Saya adalah mahasiswa Program Studi Sistem Informasi di UIN Sulthan Thaha Saifuddin Jambi. Saya memiliki minat yang mendalam di bidang teknologi, khususnya pemrograman. Bagi saya, pemrograman bukan sekadar menulis kode, melainkan sebuah sarana untuk mengasah kemampuan berpikir logis, memecahkan masalah secara sistematis, dan menciptakan inovasi yang bermanfaat.";

  // Data Biodata
  final Map<String, String> biodata = const {
    "Tempat, Tgl Lahir": "Jambi, 16 Oktober 2005",
    "Agama": "Islam",
    "Jenis Kelamin": "Laki-laki",
    "Hobi": "Coding, Editing, Dan Bermain Game",
    "Alamat":
        "JL. Cendana RT. 19, Desa Kebon IX, Sungai Gelam, Muaro Jambi",
  };

  // Data Kontak
  final String email = "rifqyziyadulvian@gmail.com";
  final String phone = "+62 895338432828";
  final String fotoLokalPath = 'assets/pi.png';

  // --- Fungsi Aksi ---

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        duration: const Duration(seconds: 10),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  void _tombolUtamaAksi(BuildContext context) {
    print("Tombol 'Pesan Motivasi' ditekan!");
    _showSnackBar(
      context,
      "“selesaikan apa yang sudah kau mulai”",
    );
  }

  // --- Widget Builders ---

  // Membuat baris item untuk Card Biodata
  Widget _buildBiodataItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Membuat baris item untuk Card Kontak (dengan ikon dan label)
  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label (Email / Nomor Telepon)
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                // Nilai (Alamat Email / Nomor)
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bagian Foto dan Nama
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: <Widget>[
        // Foto Profil (menggunakan aset lokal)
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 85,
            backgroundImage: AssetImage(fotoLokalPath),
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // Nama Lengkap
        Text(
          namaLengkap,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 5),

        // Profesi/Jabatan
        Text(
          profesi,
          style: TextStyle(
            fontSize: 18,
            color: Colors.lightBlue.shade100,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Membuat Card Umum
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const Divider(color: Colors.blueAccent),
            const SizedBox(height: 15),
            ...children, // Memasukkan daftar widget yang diberikan
          ],
        ),
      ),
    );
  }

  // Card Ringkasan
  Widget _buildRingkasanCard() {
    return _buildInfoCard("Tentang Saya", [
      Text(
        deskripsiSingkat,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.6,
        ),
        textAlign: TextAlign.justify,
      ),
    ]);
  }

  // Card Biodata
  Widget _buildBiodataCard() {
    return _buildInfoCard(
      "Biodata",
      biodata.entries.map((entry) {
        return _buildBiodataItem(entry.key, entry.value);
      }).toList(),
    );
  }

  // Card Kontak
  Widget _buildContactCard() {
    return _buildInfoCard("Kontak", [
      // Baris untuk Email
      _buildContactItem(Icons.email, "Email", email),

      // Baris untuk Nomor Telepon
      _buildContactItem(Icons.phone_android, "Telepon", phone),
    ]);
  }

  // --- Widget Build Utama ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'APLIKASI PROFIL SAYA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Container(
        // Menerapkan Gradasi Biru
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5), Color(0xFFBBDEFB)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),

              // 1. Header
              _buildHeader(context),

              const SizedBox(height: 30),

              // 2. Card Ringkasan
              _buildRingkasanCard(),

              // 3. Card Biodata
              _buildBiodataCard(),

              // 4. Card Kontak Saya (Sekarang dengan label yang jelas)
              _buildContactCard(),

              const SizedBox(height: 20),

              // 5. Tombol Utama
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _tombolUtamaAksi(context),
                    icon: const Icon(Icons.message, size: 24),
                    label: const Text(
                      'Pesan Motivasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade700,
                      elevation: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}