import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String text;

  const EmptyList({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 8,
        children: [
          Icon(Icons.info, color: Colors.grey[400]),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
