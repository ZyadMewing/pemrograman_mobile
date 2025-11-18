
import 'package:flutter/material.dart';
import 'home_page.dart'; // Impor halaman utama kita

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Activity Tracker',
      theme: ThemeData(
        // Mengaktifkan Material 3
        useMaterial3: true,
        
        // Menentukan skema warna. Anda bisa ganti 'Colors.blue'
        // dengan warna lain seperti 'Colors.green' atau 'Colors.purple'
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light, // Tema terang
        ),
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan banner "DEBUG"
      home: const HomePage(), // Memulai aplikasi dengan HomePage
    );
  }
}