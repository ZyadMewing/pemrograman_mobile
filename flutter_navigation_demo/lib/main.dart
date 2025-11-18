import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      // Aktifkan Material 3
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Halaman awal aplikasi
      home: const HomePage(),
    );
  }
}

// --- Halaman 1: HomePage (Mengirim Data) ---
// Halaman ini memiliki TextField dan tombol untuk mengirim data ke halaman berikutnya.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller untuk mendapatkan teks dari TextField
  final TextEditingController _textController = TextEditingController();

  void _sendDataToMainScreen() {
    String dataToSend = _textController.text;
    if (dataToSend.isEmpty) {
      dataToSend = "Data Kosong";
    }

    // Menggunakan Navigator.push() untuk berpindah ke MainScreen
    // dan mengirimkan data melalui constructor
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(dataFromHome: dataToSend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman 1: Kirim Data'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Masukkan data untuk dikirim:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _sendDataToMainScreen,
              child: const Text('Kirim Data ke Halaman 2'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

// --- Halaman 2: MainScreen (Menerima Data & Punya BottomNavBar) ---
// Halaman ini adalah root untuk BottomNavigationBar.

class MainScreen extends StatefulWidget {
  // Variabel untuk menampung data yang dikirim dari HomePage
  final String dataFromHome;

  // Constructor untuk menerima data
  const MainScreen({super.key, required this.dataFromHome});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index untuk tab yang sedang aktif
  late List<Widget> _pages; // List widget untuk setiap tab

  @override
  void initState() {
    super.initState();
    // Inisialisasi halaman-halaman untuk tab
    // Kita teruskan data yang diterima ke DataDisplayPage
    _pages = <Widget>[
      DataDisplayPage(receivedData: widget.dataFromHome),
      const SettingsPage(),
    ];
  }

  // Fungsi untuk mengubah tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Halaman 2: Data' : 'Halaman 3: Pengaturan',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Tampilkan halaman sesuai index yang dipilih
      body: Center(child: _pages.elementAt(_selectedIndex)),
      // Definisikan BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'Data'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- Halaman 2.1: DataDisplayPage (Tab 1) ---
// Ini adalah widget yang ditampilkan sebagai tab pertama di MainScreen.

class DataDisplayPage extends StatelessWidget {
  final String receivedData;

  const DataDisplayPage({super.key, required this.receivedData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Data yang Diterima dari Halaman 1:',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              receivedData,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Halaman 3: SettingsPage (Tab 2) ---
// Ini adalah widget yang ditampilkan sebagai tab kedua di MainScreen.
// Halaman ini memiliki tombol untuk Navigator.pop().

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings, size: 80),
          const SizedBox(height: 20),
          Text(
            'Ini Halaman Pengaturan',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            // Menggunakan Navigator.pop() untuk kembali ke halaman sebelumnya
            // (dalam hal ini, kembali ke HomePage)
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Kembali ke Halaman 1'),
          ),
        ],
      ),
    );
  }
}