import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/custom_filter_chip.dart';
import 'package:daily_wellness_tracker/features/history/viewModel/history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TypeFilterWidget extends StatelessWidget {
  const TypeFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HistoryViewModel>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          CustomFilterChip(
            label: 'Todos',
            icon: Icons.all_inclusive,
            chipColor: AppColors.primary,
            isSelected: viewModel.selectedType == null,
            onTap: () => viewModel.filterByType(null),
          ),
          CustomFilterChip(
            label: 'Calorias',
            icon: Icons.local_fire_department,
            chipColor: Colors.orange,
            isSelected: viewModel.selectedType == ConsumptionType.calories,
            onTap: () => viewModel.filterByType(ConsumptionType.calories),
          ),
          CustomFilterChip(
            label: 'Água',
            icon: Icons.water_drop,
            chipColor: Colors.blue,
            isSelected: viewModel.selectedType == ConsumptionType.water,
            onTap: () => viewModel.filterByType(ConsumptionType.water),
          ),
        ],
      ),
    );
  }
}
