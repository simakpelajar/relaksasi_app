import 'package:flutter/material.dart';

class EmptyJournalState extends StatelessWidget {
  final VoidCallback onCreateJournal;

  const EmptyJournalState({
    Key? key,
    required this.onCreateJournal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.book,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Anda belum memiliki catatan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat catatan pertama Anda untuk memulai perjalanan refleksi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onCreateJournal,
            child: const Text('Buat Catatan'),
          ),
        ],
      ),
    );
  }
}