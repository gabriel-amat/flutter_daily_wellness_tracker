import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/cards/meal_card.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/cards/water_card.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:daily_wellness_tracker/shared/ui/widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentEntriesWidget extends StatefulWidget {
  final EntryType currentType;

  const RecentEntriesWidget({super.key, required this.currentType});

  @override
  State<RecentEntriesWidget> createState() => _RecentEntriesWidgetState();
}

class _RecentEntriesWidgetState extends State<RecentEntriesWidget> {
  late CustomSnack snack;

  @override
  void initState() {
    snack = context.read<CustomSnack>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'Today\'s Entries',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Consumer<EntryViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (widget.currentType == EntryType.meal) {
              if (viewModel.todayMeals.isEmpty) {
                return EmptyList(text: 'No meals today. Add the first one!');
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.todayMeals.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return MealCard(mealEntity: viewModel.todayMeals[index]);
                },
              );
            } else {
              if (viewModel.todayWaterEntries.isEmpty) {
                return EmptyList(
                  text: 'No water entries today. Add the first one!',
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.todayWaterEntries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return WaterCard(
                    waterEntry: viewModel.todayWaterEntries[index],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
