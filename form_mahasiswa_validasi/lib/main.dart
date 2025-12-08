import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Mahasiswa Validasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      home: const FormMahasiswaPage(),
    );
  }
}

class FormMahasiswaPage extends StatefulWidget {
  const FormMahasiswaPage({super.key});

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  // Key Form Terpisah per Step
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Controllers Text
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();

  // State Variables
  int _currentStep = 0;
  String? _selectedJurusan;
  double _semester = 1.0;
  bool _agree = false;

  // Data Hobi
  final Map<String, bool> _hobbies = {
    'Coding': false,
    'Desain Grafis': false,
    'Olahraga': false,
    'Menulis': false,
  };

  final List<String> _jurusanList = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Manajemen Informatika',
    'Teknik Komputer'
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    super.dispose();
  }

  // --- FUNGSI RESET FORM (BARU) ---
  void _resetForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Form?'),
        content: const Text('Apakah Anda yakin ingin menghapus semua data dan mengulang dari awal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Tutup dialog
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog dulu
              setState(() {
                // 1. Bersihkan Text Controller
                _namaController.clear();
                _emailController.clear();
                _hpController.clear();

                // 2. Reset Variabel State
                _currentStep = 0;
                _selectedJurusan = null;
                _semester = 1.0;
                _agree = false;
                
                // 3. Reset semua Checkbox Hobi jadi false
                _hobbies.updateAll((key, value) => false); 
              });

              // 4. Hilangkan pesan error merah (reset state validasi)
              _formKeyStep1.currentState?.reset();
              _formKeyStep2.currentState?.reset();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form berhasil direset')),
              );
            },
            child: const Text('Ya, Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- FUNGSI SUBMIT ---
  void _submitForm() {
    List<String> selectedHobbies = _hobbies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Berhasil Disimpan!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Nama: ${_namaController.text}'),
              Text('Email: ${_emailController.text}'),
              Text('No HP: ${_hpController.text}'),
              Text('Jurusan: $_selectedJurusan'),
              Text('Semester: ${_semester.round()}'),
              Text('Hobi: ${selectedHobbies.join(', ')}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Mahasiswa'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        // TOMBOL RESET DI APP BAR
        actions: [
          IconButton(
            onPressed: _resetForm,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        
        // Logika Tombol Continue
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_formKeyStep1.currentState!.validate()) {
              setState(() => _currentStep += 1);
            }
          } else if (_currentStep == 1) {
            if (_formKeyStep2.currentState!.validate()) {
              setState(() => _currentStep += 1);
            }
          } else if (_currentStep == 2) {
            if (!_hobbies.containsValue(true)) {
              showErrorSnackBar('Pilih minimal satu hobi!');
              return;
            }
            if (!_agree) {
              showErrorSnackBar('Harap setujui syarat & ketentuan!');
              return;
            }
            _submitForm();
          }
        },

        // Logika Tombol Cancel
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },

        steps: [
          // --- STEP 1: Data Pribadi ---
          Step(
            title: const Text('Data Pribadi'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.editing,
            content: Form(
              key: _formKeyStep1,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Contoh: Rifqi Ziyad',
                      helperText: 'Nama harus lebih dari 4 huruf',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Nama wajib diisi';
                      if (value.length <= 4) return 'Nama terlalu pendek (min. 5 huruf)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'nama@email.com',
                      helperText: 'Gunakan format email yang benar',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email wajib diisi';
                      if (!value.contains('@')) return 'Format email salah';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hpController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      hintText: '08xxxxxxxxxx',
                      helperText: 'Hanya angka, minimal 8 digit',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Nomor HP wajib diisi';
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Hanya boleh angka';
                      if (value.length < 8) return 'Nomor HP terlalu pendek (min. 8 digit)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // --- STEP 2: Data Akademik ---
          Step(
            title: const Text('Data Akademik'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.editing,
            content: Form(
              key: _formKeyStep2,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedJurusan,
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      hintText: 'Pilih jurusan',
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: _jurusanList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) => setState(() => _selectedJurusan = newValue),
                    validator: (value) => value == null ? 'Pilih jurusan terlebih dahulu' : null,
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Semester Saat Ini', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Slider(
                    value: _semester,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: _semester.round().toString(),
                    onChanged: (double value) => setState(() => _semester = value),
                  ),
                  Text('Semester: ${_semester.round()}', 
                    style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
                ],
              ),
            ),
          ),

          // --- STEP 3: Minat & Persetujuan ---
          Step(
            title: const Text('Minat & Persetujuan'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilih Hobi (Min. 1):', style: TextStyle(fontWeight: FontWeight.bold)),
                ..._hobbies.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _hobbies[key],
                    onChanged: (bool? value) => setState(() => _hobbies[key] = value!),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                }),
                const Divider(),
                SwitchListTile(
                  title: const Text('Saya menyetujui syarat & ketentuan yang berlaku'),
                  value: _agree,
                  onChanged: (bool value) => setState(() => _agree = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}