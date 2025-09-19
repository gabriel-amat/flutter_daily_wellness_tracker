import 'package:daily_wellness_tracker/core/helper/format_data.dart';
import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';
import 'package:flutter/material.dart';

class HistoryViewModel extends ChangeNotifier {
  final ConsumptionService _consumptionService;

  HistoryViewModel({required ConsumptionService consumptionService})
    : _consumptionService = consumptionService;

  List<ConsumptionItemEntity> _historyItems = [];
  List<ConsumptionItemEntity> _filteredItems = [];
  bool _isLoading = false;
  String? _selectedDate;
  ConsumptionType? _selectedType;

  List<ConsumptionItemEntity> get historyItems => _filteredItems;
  bool get isLoading => _isLoading;

  String? get selectedDate => _selectedDate;
  ConsumptionType? get selectedType => _selectedType;

  bool get hasData => _historyItems.isNotEmpty;
  bool get hasFilteredData => _filteredItems.isNotEmpty;

  Future<void> loadAllHistory() async {
    _isLoading = true;
    _selectedDate = null;
    _selectedType = null;
    notifyListeners();

    try {
      _historyItems = await _consumptionService.getAllHistory();
      _filteredItems = List.from(_historyItems);
    } catch (e) {
      debugPrint('Erro ao carregar histórico: $e');
      _historyItems = [];
      _filteredItems = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadHistoryByDate(DateTime date) async {
    _isLoading = true;
    final dateString = FormatDate.dateTimeToString(date);
    _selectedDate = dateString;
    _selectedType = null;
    notifyListeners();

    try {
      final allHistory = await _consumptionService.getAllHistory();
      _historyItems = allHistory;
      _filteredItems = allHistory
          .where((item) => item.date == dateString)
          .toList();
    } catch (e) {
      debugPrint('Erro ao carregar histórico por data: $e');
      _filteredItems = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterByType(ConsumptionType? type) {
    _selectedType = type;

    if (type == null) {
      if (_selectedDate != null) {
        _filteredItems = _historyItems
            .where((item) => item.date == _selectedDate)
            .toList();
      } else {
        _filteredItems = List.from(_historyItems);
      }
    } else {
      if (_selectedDate != null) {
        _filteredItems = _historyItems
            .where((item) => item.type == type && item.date == _selectedDate)
            .toList();
      } else {
        _filteredItems = _historyItems
            .where((item) => item.type == type)
            .toList();
      }
    }

    notifyListeners();
  }

  void clearFilters() {
    _selectedDate = null;
    _selectedType = null;
    _filteredItems = List.from(_historyItems);
    notifyListeners();
  }

  Future<void> removeItem(ConsumptionItemEntity item) async {
    try {
      await _consumptionService.removeEntry(item);
      _historyItems.removeWhere((historyItem) => historyItem.id == item.id);
      _applyCurrentFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao remover item: $e');
      rethrow;
    }
  }

  Future<void> updateItem(ConsumptionItemEntity item) async {
    try {
      await _consumptionService.updateEntry(item);
      final index = _historyItems.indexWhere(
        (historyItem) => historyItem.id == item.id,
      );
      if (index != -1) {
        _historyItems[index] = item;
        _applyCurrentFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao atualizar item: $e');
      rethrow;
    }
  }

  Future<double> getCaloriesForDate(DateTime date) async {
    try {
      final dateString = FormatDate.dateTimeToString(date);
      final items = _historyItems.where(
        (item) =>
            item.date == dateString && item.type == ConsumptionType.calories,
      );
      return items.fold<double>(0.0, (total, item) => total + item.value);
    } catch (e) {
      debugPrint('Erro ao calcular calorias para a data: $e');
      return 0.0;
    }
  }

  Future<double> getWaterForDate(DateTime date) async {
    try {
      final dateString = FormatDate.dateTimeToString(date);
      final items = _historyItems.where(
        (item) => item.date == dateString && item.type == ConsumptionType.water,
      );
      return items.fold<double>(0.0, (total, item) => total + item.value);
    } catch (e) {
      debugPrint('Erro ao calcular água para a data: $e');
      return 0.0;
    }
  }

  Future<void> loadRecentHistory(int days) async {
    _isLoading = true;
    _selectedDate = null;
    _selectedType = null;
    notifyListeners();

    try {
      final allHistory = await _consumptionService.getAllHistory();
      final now = DateTime.now();
      final cutoffDate = now.subtract(Duration(days: days));

      _historyItems = allHistory.where((item) {
        final itemDate = DateTime.parse(item.date);
        return itemDate.isAfter(cutoffDate) ||
            itemDate.isAtSameMomentAs(cutoffDate);
      }).toList();

      _filteredItems = List.from(_historyItems);
    } catch (e) {
      debugPrint('Erro ao carregar histórico recente: $e');
      _historyItems = [];
      _filteredItems = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Map<String, dynamic> getStatistics() {
    final calories = _filteredItems
        .where((item) => item.type == ConsumptionType.calories)
        .fold<double>(0.0, (total, item) => total + item.value);

    final water = _filteredItems
        .where((item) => item.type == ConsumptionType.water)
        .fold<double>(0.0, (total, item) => total + item.value);

    final calorieEntries = _filteredItems
        .where((item) => item.type == ConsumptionType.calories)
        .length;

    final waterEntries = _filteredItems
        .where((item) => item.type == ConsumptionType.water)
        .length;

    return {
      'totalCalories': calories,
      'totalWater': water,
      'calorieEntries': calorieEntries,
      'waterEntries': waterEntries,
      'totalEntries': _filteredItems.length,
    };
  }

  void _applyCurrentFilters() {
    List<ConsumptionItemEntity> items = List.from(_historyItems);

    if (_selectedDate != null) {
      items = items.where((item) => item.date == _selectedDate).toList();
    }

    if (_selectedType != null) {
      items = items.where((item) => item.type == _selectedType).toList();
    }

    _filteredItems = items;
  }

  List<String> getAvailableDates() {
    final dates = _historyItems.map((item) => item.date).toSet().toList();
    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }
}
