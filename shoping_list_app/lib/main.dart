import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Kita butuh ini untuk input angka
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'shopping_item.dart'; // BARU: Ganti import ke model baru

// BARU: Buat enum untuk tipe filter
enum FilterType { semua, sudah, belum }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false, 
      home: ShoppingListScreen(),
    );
  }
}

// Ganti nama class
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> items = [];
  
  FilterType _currentFilter = FilterType.semua;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Kategori default untuk contoh
  final List<String> _categories = ['Buah', 'Sayur', 'Daging', 'Minuman', 'Lainnya'];
  String _selectedCategory = 'Lainnya'; //

List<ShoppingItem> get _filteredItems {
  switch (_currentFilter) {
    case FilterType.sudah:
      return items.where((item) => item.isBought).toList();
    case FilterType.belum:
      return items.where((item) => !item.isBought).toList();
    case FilterType.semua:
      return items; // Hapus 'default:' dan biarkan seperti ini
  }
}

  @override
  void initState() {
    super.initState();
    _loadItems(); // Ganti nama fungsi
  }

  // --- FUNGSI UNTUK SIMPAN & MUAT DATA ---

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    // Ganti Key: 'todos_list' -> 'shopping_list'
    String? itemsString = prefs.getString('shopping_list');

    if (itemsString != null) {
      List<dynamic> itemsJson = jsonDecode(itemsString);
      setState(() {
        // Ganti Model: Todo.fromJson -> ShoppingItem.fromJson
        items = itemsJson.map((json) => ShoppingItem.fromJson(json)).toList();
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> itemsJson =
        items.map((item) => item.toJson()).toList();
    String itemsString = jsonEncode(itemsJson);
    // Ganti Key: 'todos_list' -> 'shopping_list'
    await prefs.setString('shopping_list', itemsString);
  }

  // --- FUNGSI CRUD ---

  void _addItem(String name, int quantity, String category) {
    setState(() {
      items.add(ShoppingItem(
        id: DateTime.now().toString(),
        name: name,
        quantity: quantity,
        category: category,
        createdAt: DateTime.now(),
      ));
    });
    _saveItems(); // Simpan
  }

  void _toggleItemStatus(int index) {
    setState(() {
      // Ganti properti: isCompleted -> isBought
      items[index].isBought = !items[index].isBought;
    });
    _saveItems(); // Simpan
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    _saveItems(); // Simpan
  }

  // --- FUNGSI UNTUK TAMPILKAN DIALOG ---

  void _showAddItemDialog() {
    // Bersihkan controller
    _nameController.clear();
    _quantityController.text = '1'; // Default jumlah 1
    _selectedCategory = 'Lainnya'; // Reset kategori

    showDialog(
      context: context,
      builder: (context) {
        // Kita pakai StatefulWidget di dalam dialog agar Dropdown bisa di-update
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Tambah Barang Belanja'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Nama Barang',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Jumlah',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Keyboard angka
                    // Hanya izinkan input angka
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(height: 16),
                  // Dropdown untuk Kategori
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        //
                        _selectedCategory = newValue!; //
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Validasi
                  if (_nameController.text.isNotEmpty &&
                      _quantityController.text.isNotEmpty) {
                    _addItem(
                      _nameController.text,
                      int.parse(_quantityController.text), // ubah ke angka
                      _selectedCategory,
                    );
                    Navigator.pop(context); // Tutup dialog
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: Text('Daftar Belanja'),
        actions: [
          // BARU: Tombol Menu untuk Filter
          PopupMenuButton<FilterType>(
            icon: Icon(Icons.filter_list), // Ikon filter
            onSelected: (FilterType result) {
              // Panggil setState untuk ganti filter
              setState(() {
                _currentFilter = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterType>>[
              const PopupMenuItem<FilterType>(
                value: FilterType.semua,
                child: Text('Tampilkan Semua'),
              ),
              const PopupMenuItem<FilterType>(
                value: FilterType.belum,
                child: Text('Belum Dibeli'),
              ),
              const PopupMenuItem<FilterType>(
                value: FilterType.sudah,
                child: Text('Sudah Dibeli'),
              ),
            ],
          ),
  
          IconButton(
            icon: Icon(Icons.info_outline), // Ikon 'info'
            onPressed: () {
              // Di sini kita hitung totalnya
              final int totalItems = items.length;
              final int boughtItems =
                  items.where((item) => item.isBought).length; // Hitung yang 'isBought' true

              // Tampilkan SnackBar (seperti di PDF [cite: 251-253])
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Total: $boughtItems / $totalItems barang sudah dibeli'),
                  duration: Duration(seconds: 2), // Biar gak kelamaan
                ),
              );
            },
            tooltip: 'Lihat Total', //
          ),
        ],
      ),
          body: _filteredItems.isEmpty // <-- UBAH DI SINI
          ? Center(
              child: Text(
                _currentFilter == FilterType.semua
                    ? 'Belum ada barang belanja' // Pesan jika 'semua' kosong
                    : 'Tidak ada barang di filter ini', // Pesan jika filter lain kosong
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _filteredItems.length, // <-- UBAH DI SINI
              itemBuilder: (context, index) {
                final item = _filteredItems[index]; // <-- UBAH DI SINI

                return CheckboxListTile(
                  title: Text(
                    item.name, // Tampilkan nama
                    style: TextStyle(
                      decoration: item.isBought
                          ? TextDecoration.lineThrough // Coret
                          : TextDecoration.none,
                    ),
                  ),
                  // BARU: Subtitle untuk jumlah dan kategori
                  subtitle: Text('Jumlah: ${item.quantity} | Kategori: ${item.category}'),
                  value: item.isBought,
                  onChanged: (bool? value) {
                    _toggleItemStatus(index); // Panggil fungsi toggle
                  },
                  secondary: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteItem(index); // Panggil fungsi hapus
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog, // Panggil dialog baru
        tooltip: 'Tambah Barang', // Ganti tooltip
        child: Icon(Icons.add_shopping_cart), // Ganti ikon
      ),
    );
  }
}