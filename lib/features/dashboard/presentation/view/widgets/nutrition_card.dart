import 'package:daily_wellness_tracker/core/theme/app_text_style.dart';
import 'package:daily_wellness_tracker/features/dashboard/presentation/viewModel/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NutritionCard extends StatefulWidget {
  const NutritionCard({super.key});

  @override
  State<NutritionCard> createState() => _NutritionCardState();
}

class _NutritionCardState extends State<NutritionCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, dashboardViewModel, child) {
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nutrition Overview', style: AppTextStyle.subtitle),
                const SizedBox(height: 16),
                _buildNutritionRow(
                  label: 'Carbohydrates',
                  value: '${dashboardViewModel.totalCarbs} g',
                  color: Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildNutritionRow(
                  label: 'Protein',
                  value: '${dashboardViewModel.totalProtein} g',
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildNutritionRow(
                  label: 'Fats',
                  value: '${dashboardViewModel.totalFats} g',
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyle.normal)),
        Text(
          value,
          style: AppTextStyle.subtitle.copyWith(color: Colors.black54),
        ),
      ],
    );
  }
}
