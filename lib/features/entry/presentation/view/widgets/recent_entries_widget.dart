import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentEntriesWidget extends StatelessWidget {
  final EntryType currentType;

  const RecentEntriesWidget({super.key, required this.currentType});

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
          builder: (context, viewModel, widget) {
            if (viewModel.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Get entries based on type
            final mealEntries = currentType == EntryType.meal
                ? viewModel.todayMeals
                : [];
            final waterEntries = currentType == EntryType.water
                ? viewModel.todayWaterEntries
                : [];
            final hasEntries =
                mealEntries.isNotEmpty || waterEntries.isNotEmpty;

            if (!hasEntries) {
              return Center(
                child: Column(
                  spacing: 8,
                  children: [
                    Icon(Icons.info, color: Colors.grey[400]),
                    Text(
                      currentType == EntryType.meal
                          ? 'No meals today. Add the first one!'
                          : 'No water entries today. Add the first one!',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (currentType == EntryType.meal) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mealEntries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final meal = mealEntries[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.restaurant,
                        color: Colors.orange,
                      ),
                      title: Text(meal.name),
                      subtitle: Text('${meal.foods.length} food items'),
                      trailing: Text(
                        '${meal.totalCalories.toStringAsFixed(0)} cal',
                      ),
                    ),
                  );
                },
              );
            } else {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: waterEntries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final waterEntry = waterEntries[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.water_drop, color: Colors.blue),
                      title: const Text('Water Entry'),
                      trailing: Text(
                        '${waterEntry.amount.toStringAsFixed(0)} ml',
                      ),
                    ),
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
