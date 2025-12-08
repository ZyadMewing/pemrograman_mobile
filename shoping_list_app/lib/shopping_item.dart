// File: shopping_item.dart

class ShoppingItem {
  String id;
  String name;
  int quantity; // BARU: untuk jumlah
  String category; // BARU: untuk kategori
  bool isBought; // Ganti nama dari 'isCompleted'
  DateTime createdAt;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isBought = false,
    required this.createdAt,
  });

  // Konversi dari Map (JSON) ke Object
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      category: json['category'],
      isBought: json['isBought'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Konversi dari Object ke Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isBought': isBought,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
