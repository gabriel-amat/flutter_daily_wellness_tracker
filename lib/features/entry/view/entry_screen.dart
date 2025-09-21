import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/entry/view/widgets/entry_type_selector.dart';
import 'package:daily_wellness_tracker/features/entry/view/widgets/new_entry_card.dart';
import 'package:daily_wellness_tracker/features/entry/view/widgets/recent_entries_widget.dart';
import 'package:daily_wellness_tracker/features/entry/view/widgets/today_total_card.dart';
import 'package:daily_wellness_tracker/features/entry/viewModel/entry_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  late EntryViewModel viewModel;
  final entryController = TextEditingController();
  EntryType currentType = EntryType.calorie;

  @override
  void initState() {
    viewModel = context.read<EntryViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    super.initState();
  }

  @override
  void dispose() {
    entryController.dispose();
    super.dispose();
  }

  void _loadData() {
    viewModel.getTodayTotalCalories();
    viewModel.getTodayTotalWater();
    viewModel.getTodayEntries();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: AppTheme.defaultPageMargin,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            TodayTotalCard(currentType: currentType),
            EntryTypeSelector(
              currentType: currentType,
              onTypeChanged: (type) {
                setState(() => currentType = type);
              },
            ),
            NewEntryCard(selectedType: currentType),
            RecentEntriesWidget(currentType: currentType),
          ],
        ),
      ),
    );
  }
}
