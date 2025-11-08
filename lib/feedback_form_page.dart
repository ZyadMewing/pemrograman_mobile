// lib/feedback_form_page.dart

import 'package:flutter/material.dart';
import 'feedback_result_page.dart';

// Model sederhana untuk data feedback
class FeedbackData {
  final String name;
  final String comment;
  final int rating;

  FeedbackData({required this.name, required this.comment, required this.rating});
}

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  // Controller untuk input teks
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  
  // State untuk rating
  int _currentRating = 3; // Nilai default

  // Kunci untuk memvalidasi formulir
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    // Memvalidasi formulir
    if (_formKey.currentState!.validate()) {
      // 1. Ambil data
      final feedback = FeedbackData(
        name: _nameController.text,
        comment: _commentController.text,
        rating: _currentRating,
      );

      // 2. Berpindah ke Halaman 2 menggunakan Navigator.push
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackResultPage(feedbackData: feedback),
        ),
      );
    }
  }

  // Widget untuk membuat tombol rating
  Widget _buildRatingButton(int rating) {
    return IconButton(
      icon: Icon(
        Icons.star,
        color: rating <= _currentRating ? Colors.amber : Colors.grey,
        size: 30,
      ),
      onPressed: () {
        // Memperbarui state menggunakan setState()
        setState(() {
          _currentRating = rating;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Formulir Feedback'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Input Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input Komentar
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Komentar/Saran',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Komentar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input Rating
              const Text(
                'Rating (1-5 Bintang):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  // Index 0 adalah Rating 1, Index 4 adalah Rating 5
                  return _buildRatingButton(index + 1);
                }),
              ),
              const SizedBox(height: 30),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitFeedback,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Feedback', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}