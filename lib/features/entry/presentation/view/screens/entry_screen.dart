import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/widgets/entry_type_selector.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/forms/meal_form_widget.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/forms/water_form_widget.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/widgets/recent_entries_widget.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/widgets/today_total_card.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
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
  EntryType currentType = EntryType.meal;

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
    viewModel.getTodayData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: AppTheme.defaultPageMargin,
        // physics: AlwaysScrollableScrollPhysics(),
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

            currentType == EntryType.meal ? MealEntryCard() : WaterEntryCard(),

            RecentEntriesWidget(currentType: currentType),
          ],
        ),
      ),
    );
  }
}
