import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/filter_section_widget.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/history_card.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/statistics_card.dart';
import 'package:daily_wellness_tracker/features/history/viewModel/history_view_model.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    super.initState();
  }

  _loadData() {
    historyViewModel.loadAllHistory();
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
        child: RefreshIndicator.adaptive(
          onRefresh: () async => _loadData(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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
                          icon: const Icon(
                            Icons.filter_list,
                            color: AppColors.primary,
                          ),
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
                    const SizedBox(height: 16),

                    if (viewModel.hasFilteredData)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: StatisticsCard(stats: viewModel.getStatistics()),
                      ),

                    _buildHistoryContent(viewModel),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryContent(HistoryViewModel viewModel) {
    if (viewModel.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
            Text('Carregando histórico...'),
          ],
        ),
      );
    }

    if (!viewModel.hasFilteredData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            Text(
              'Nenhum registro encontrado',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            Text('Comece adicionando calorias ou água'),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: viewModel.historyItems.length,
      itemBuilder: (context, index) {
        final item = viewModel.historyItems[index];
        return HistoryCard(item: item, viewModel: viewModel);
      },
    );
  }
}
