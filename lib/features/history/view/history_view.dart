import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/filter_section_widget.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/history_item.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/statistics_card.dart';
import 'package:daily_wellness_tracker/features/history/viewModel/history_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryViewModel historyViewModel;
  late final CustomSnack customSnack;

  @override
  void initState() {
    historyViewModel = context.read<HistoryViewModel>();
    customSnack = context.read<CustomSnack>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      historyViewModel.loadAllHistory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDatePicker(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      body: Padding(
        padding: AppTheme.defaultPageMargin,
        child: Consumer<HistoryViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Historico",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (String result) => switch (result) {
                        '7' => viewModel.loadRecentHistory(7),
                        '30' => viewModel.loadRecentHistory(30),
                        'all' => viewModel.loadAllHistory(),
                        'clear_filters' => viewModel.clearFilters(),
                        _ => throw UnimplementedError(),
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: '7',
                          child: Text('Últimos 7 dias'),
                        ),
                        const PopupMenuItem<String>(
                          value: '30',
                          child: Text('Últimos 30 dias'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'all',
                          child: Text('Todos os registros'),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'clear_filters',
                          child: Text('Limpar filtros'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilterSection(historyViewModel: historyViewModel),
                if (viewModel.hasFilteredData) ...[
                  StatisticsCard(stats: viewModel.getStatistics()),
                  const SizedBox(height: 8),
                ],
                Expanded(child: _buildHistoryContent(viewModel)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryContent(HistoryViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text('Carregando histórico...'),
          ],
        ),
      );
    }

    if (!viewModel.hasFilteredData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum registro encontrado',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comece adicionando calorias ou água',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.historyItems.length,
      itemBuilder: (context, index) {
        final item = viewModel.historyItems[index];
        return HistoryItem(item: item, viewModel: viewModel);
      },
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final availableDates = historyViewModel.getAvailableDates();

    if (availableDates.isEmpty) {
      customSnack.error(text: 'Nenhuma data disponível no histórico');
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      selectableDayPredicate: (date) {
        final dateString = date.toIso8601String().split('T').first;
        return availableDates.contains(dateString);
      },
    );

    if (picked != null) {
      historyViewModel.loadHistoryByDate(picked);
    }
  }
}
