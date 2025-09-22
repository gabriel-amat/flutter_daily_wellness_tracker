import 'package:daily_wellness_tracker/core/enums/history_filter_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/features/history/presentation/view/widgets/custom_filter_chip.dart';
import 'package:daily_wellness_tracker/features/history/presentation/viewModel/history_view_model.dart';
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
            label: 'All',
            icon: Icons.all_inclusive,
            chipColor: AppColors.primary,
            isSelected: viewModel.selectedFilter == HistoryFilterType.all,
            onTap: () => viewModel.filterByType(HistoryFilterType.all),
          ),
          CustomFilterChip(
            label: 'Meals',
            icon: Icons.local_fire_department,
            chipColor: Colors.orange,
            isSelected: viewModel.selectedFilter == HistoryFilterType.meals,
            onTap: () => viewModel.filterByType(HistoryFilterType.meals),
          ),
          CustomFilterChip(
            label: 'Water',
            icon: Icons.water_drop,
            chipColor: Colors.blue,
            isSelected: viewModel.selectedFilter == HistoryFilterType.water,
            onTap: () => viewModel.filterByType(HistoryFilterType.water),
          ),
        ],
      ),
    );
  }
}
