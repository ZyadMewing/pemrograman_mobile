// lib/feedback_result_page.dart

import 'package:flutter/material.dart';
import 'feedback_form_page.dart'; // Import model FeedbackData

class FeedbackResultPage extends StatelessWidget {
  // Menerima data dari halaman sebelumnya
  final FeedbackData feedbackData;

  const FeedbackResultPage({super.key, required this.feedbackData});

  // Widget untuk menampilkan bintang
  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 28,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✅ Hasil Feedback'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Center(
                  child: Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'Feedback Berhasil Dikirim!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 30),

                // Menampilkan Nama
                _buildInfoRow('Nama', feedbackData.name, Icons.person),
                const SizedBox(height: 10),

                // Menampilkan Rating
                Row(
                  children: [
                    const Icon(Icons.star_half, color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    const Text('Rating:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 10),
                    _buildStarRating(feedbackData.rating),
                  ],
                ),
                const SizedBox(height: 10),

                // Menampilkan Komentar
                _buildInfoRow('Komentar', feedbackData.comment, Icons.comment),
                const SizedBox(height: 10),
                
                const Divider(height: 30),

                // Tombol Kembali
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Kembali ke halaman sebelumnya menggunakan Navigator.pop
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali ke Formulir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueGrey),
            const SizedBox(width: 10),
            Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(content, style: const TextStyle(fontSize: 15)),
        ),
      ],
    );
  }
}