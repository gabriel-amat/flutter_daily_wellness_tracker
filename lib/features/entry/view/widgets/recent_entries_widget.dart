import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/features/entry/view/widgets/entry_card.dart';
import 'package:daily_wellness_tracker/features/entry/viewModel/entry_view_model.dart';
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
            final entries = currentType == EntryType.calorie
                ? viewModel.todayCalorieEntries
                : viewModel.todayWaterEntries;

            if (viewModel.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (entries.isEmpty) {
              return Center(
                child: Column(
                  spacing: 8,
                  children: [
                    Icon(Icons.info, color: Colors.grey[400]),
                    const Text(
                      'No entries today. Add the first one!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return EntryCard(item: entries[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
