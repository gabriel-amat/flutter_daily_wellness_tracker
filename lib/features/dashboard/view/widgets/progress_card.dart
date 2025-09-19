import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final double todayCalories;
  final double calorieGoal;
  final String title;

  const ProgressCard({
    super.key,
    required this.todayCalories,
    required this.calorieGoal,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: todayCalories / calorieGoal,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(
              '$todayCalories / $calorieGoal kcal',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
