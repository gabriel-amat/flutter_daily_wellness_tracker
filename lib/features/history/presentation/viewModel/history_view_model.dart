import 'package:daily_wellness_tracker/core/helper/format_data.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/water_intake_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:flutter/material.dart';

enum HistoryFilterType { all, meals, water }

class HistoryViewModel extends ChangeNotifier {
  final MealConsumptionService _mealConsumptionService;

  HistoryViewModel({required MealConsumptionService mealConsumptionService})
      : _mealConsumptionService = mealConsumptionService;

  List<MealEntity> _allMeals = [];
  List<WaterIntakeEntity> _allWaterEntries = [];
  List<MealEntity> _filteredMeals = [];
  List<WaterIntakeEntity> _filteredWaterEntries = [];
  
  bool _isLoading = false;
  String? _selectedDate;
  HistoryFilterType _selectedFilter = HistoryFilterType.all;

  // Getters
  List<MealEntity> get filteredMeals => _filteredMeals;
  List<WaterIntakeEntity> get filteredWaterEntries => _filteredWaterEntries;
  bool get isLoading => _isLoading;
  String? get selectedDate => _selectedDate;
  HistoryFilterType get selectedFilter => _selectedFilter;

  bool get hasData => _allMeals.isNotEmpty || _allWaterEntries.isNotEmpty;
  bool get hasFilteredData => _filteredMeals.isNotEmpty || _filteredWaterEntries.isNotEmpty;
  bool get hasMeals => _filteredMeals.isNotEmpty;
  bool get hasWaterEntries => _filteredWaterEntries.isNotEmpty;

  // Load all history data
  Future<void> loadAllHistory() async {
    _isLoading = true;
    _selectedDate = null;
    _selectedFilter = HistoryFilterType.all;
    notifyListeners();

    try {
      final results = await Future.wait([
        _mealConsumptionService.getAllMeals(),
        _mealConsumptionService.getAllWaterEntries(),
      ]);

      _allMeals = results[0] as List<MealEntity>;
      _allWaterEntries = results[1] as List<WaterIntakeEntity>;
      
      // Sort by date (newest first)
      _allMeals.sort((a, b) => b.date.compareTo(a.date));
      _allWaterEntries.sort((a, b) => b.date.compareTo(a.date));
      
      _applyCurrentFilter();
    } catch (e) {
      debugPrint('Error loading history: $e');
      _allMeals = [];
      _allWaterEntries = [];
      _filteredMeals = [];
      _filteredWaterEntries = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load history for a specific date
  Future<void> loadHistoryByDate(DateTime date) async {
    _isLoading = true;
    final dateString = FormatDate.dateTimeToString(date);
    _selectedDate = dateString;
    notifyListeners();

    try {
      final results = await Future.wait([
        _mealConsumptionService.getMealsByDate(dateString),
        _mealConsumptionService.getWaterEntriesByDate(dateString),
      ]);

      _allMeals = results[0] as List<MealEntity>;
      _allWaterEntries = results[1] as List<WaterIntakeEntity>;
      
      _applyCurrentFilter();
    } catch (e) {
      debugPrint('Error loading history by date: $e');
      _filteredMeals = [];
      _filteredWaterEntries = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load recent history (last N days)
  Future<void> loadRecentHistory(int days) async {
    _isLoading = true;
    _selectedDate = null;
    _selectedFilter = HistoryFilterType.all;
    notifyListeners();

    try {
      final results = await Future.wait([
        _mealConsumptionService.getAllMeals(),
        _mealConsumptionService.getAllWaterEntries(),
      ]);

      final now = DateTime.now();
      final cutoffDate = now.subtract(Duration(days: days));
      final cutoffString = FormatDate.dateTimeToString(cutoffDate);

      _allMeals = (results[0] as List<MealEntity>)
          .where((meal) => meal.date.compareTo(cutoffString) >= 0)
          .toList();
      
      _allWaterEntries = (results[1] as List<WaterIntakeEntity>)
          .where((entry) => entry.date.compareTo(cutoffString) >= 0)
          .toList();

      // Sort by date (newest first)
      _allMeals.sort((a, b) => b.date.compareTo(a.date));
      _allWaterEntries.sort((a, b) => b.date.compareTo(a.date));
      
      _applyCurrentFilter();
    } catch (e) {
      debugPrint('Error loading recent history: $e');
      _allMeals = [];
      _allWaterEntries = [];
      _filteredMeals = [];
      _filteredWaterEntries = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Filter by type
  void filterByType(HistoryFilterType? filter) {
    _selectedFilter = filter ?? HistoryFilterType.all;
    _applyCurrentFilter();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _selectedDate = null;
    _selectedFilter = HistoryFilterType.all;
    _applyCurrentFilter();
    notifyListeners();
  }

  // Apply current filters
  void _applyCurrentFilter() {
    List<MealEntity> meals = _allMeals;
    List<WaterIntakeEntity> waterEntries = _allWaterEntries;

    // Apply date filter if selected
    if (_selectedDate != null) {
      meals = meals.where((meal) => meal.date == _selectedDate).toList();
      waterEntries = waterEntries.where((entry) => entry.date == _selectedDate).toList();
    }

    // Apply type filter
    switch (_selectedFilter) {
      case HistoryFilterType.all:
        _filteredMeals = meals;
        _filteredWaterEntries = waterEntries;
        break;
      case HistoryFilterType.meals:
        _filteredMeals = meals;
        _filteredWaterEntries = [];
        break;
      case HistoryFilterType.water:
        _filteredMeals = [];
        _filteredWaterEntries = waterEntries;
        break;
    }
  }

  // Remove a meal or water entry
  Future<void> removeItem(dynamic item) async {
    try {
      if (item is MealEntity) {
        await _mealConsumptionService.removeMeal(item);
        _allMeals.removeWhere((m) => m.id == item.id);
      } else if (item is WaterIntakeEntity) {
        await _mealConsumptionService.removeWaterEntry(item);
        _allWaterEntries.removeWhere((entry) => entry.id == item.id);
      }
      _applyCurrentFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing item: $e');
      rethrow;
    }
  }

  // Update an item
  Future<void> updateItem(dynamic item) async {
    try {
      if (item is MealEntity) {
        await _mealConsumptionService.updateMeal(item);
        final index = _allMeals.indexWhere((m) => m.id == item.id);
        if (index != -1) {
          _allMeals[index] = item;
        }
      } else if (item is WaterIntakeEntity) {
        await _mealConsumptionService.updateWaterEntry(item);
        final index = _allWaterEntries.indexWhere((entry) => entry.id == item.id);
        if (index != -1) {
          _allWaterEntries[index] = item;
        }
      }
      _applyCurrentFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating item: $e');
      rethrow;
    }
  }

  // Get total calories for a specific date (equivalent to getMealsForDate)
  Future<double> getMealsForDate(DateTime date) async {
    try {
      final dateString = FormatDate.dateTimeToString(date);
      return await _mealConsumptionService.getCaloriesByDate(dateString);
    } catch (e) {
      debugPrint('Error getting meals for date: $e');
      return 0.0;
    }
  }

  // Get total water for a specific date
  Future<double> getWaterForDate(DateTime date) async {
    try {
      final dateString = FormatDate.dateTimeToString(date);
      final waterEntries = await _mealConsumptionService.getWaterEntriesByDate(dateString);
      return waterEntries.fold<double>(0.0, (total, entry) => total + entry.amount);
    } catch (e) {
      debugPrint('Error getting water for date: $e');
      return 0.0;
    }
  }

  // Get statistics for current filtered data
  Map<String, dynamic> getStatistics() {
    final totalCalories = _filteredMeals.fold<double>(
      0.0, 
      (total, meal) => total + meal.totalCalories,
    );

    final totalWater = _filteredWaterEntries.fold<double>(
      0.0, 
      (total, entry) => total + entry.amount,
    );

    return {
      'totalMeals': totalCalories,
      'totalWater': totalWater,
      'totalEntries': _filteredMeals.length + _filteredWaterEntries.length,
    };
  }

  // Get available dates from history
  List<String> getAvailableDates() {
    final mealDates = _allMeals.map((meal) => meal.date).toSet();
    final waterDates = _allWaterEntries.map((entry) => entry.date).toSet();
    final dates = {...mealDates, ...waterDates}.toList();
    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }
}