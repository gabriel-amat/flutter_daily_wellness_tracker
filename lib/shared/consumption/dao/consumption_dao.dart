import 'dart:convert';
import 'package:daily_wellness_tracker/core/database/db_helper.dart';
import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';

class ConsumptionDao {
  static const String _caloriesKey = 'calories_data';
  static const String _waterKey = 'water_data';

  Future<void> addConsumptionItem(ConsumptionItemEntity item) async {
    final prefs = await DBHelper.prefs;
    final key = item.type == ConsumptionType.calories
        ? _caloriesKey
        : _waterKey;

    final existingItems = await getConsumptionItemsByType(item.type);

    final newItem = ConsumptionItemEntity(
      id: DateTime.now().millisecondsSinceEpoch.toDouble(),
      date: item.date,
      value: item.value,
      type: item.type,
    );

    existingItems.add(newItem);

    final itemsJson = existingItems.map((e) => e.toMap()).toList();
    await prefs.setString(key, json.encode(itemsJson));
  }

  Future<List<ConsumptionItemEntity>> getConsumptionItemsByType(
    ConsumptionType type,
  ) async {
    final prefs = await DBHelper.prefs;
    final key = type == ConsumptionType.calories ? _caloriesKey : _waterKey;

    final itemsString = prefs.getString(key);
    if (itemsString == null) return [];

    final itemsList = json.decode(itemsString) as List;
    return itemsList
        .map((item) => ConsumptionItemEntity.fromMap(item))
        .toList();
  }

  Future<List<ConsumptionItemEntity>> getAllConsumptionItems() async {
    final calories = await getConsumptionItemsByType(ConsumptionType.calories);
    final water = await getConsumptionItemsByType(ConsumptionType.water);

    final allItems = [...calories, ...water];

    allItems.sort((a, b) => b.date.compareTo(a.date));

    return allItems;
  }

  Future<List<ConsumptionItemEntity>> getConsumptionItemsByDate(
    String date,
  ) async {
    final allItems = await getAllConsumptionItems();
    return allItems.where((item) => item.date == date).toList();
  }

  Future<List<ConsumptionItemEntity>> getConsumptionItemsByTypeAndDate(
    ConsumptionType type,
    String date,
  ) async {
    final items = await getConsumptionItemsByType(type);
    return items.where((item) {
      return item.date.startsWith(date);
    }).toList();
  }

  Future<double> getTotalConsumptionByTypeAndDate(
    ConsumptionType type,
    String date,
  ) async {
    final items = await getConsumptionItemsByTypeAndDate(type, date);
    return items.fold<double>(0.0, (total, item) => total + item.value);
  }

  Future<void> removeConsumptionItem(ConsumptionItemEntity item) async {
    final prefs = await DBHelper.prefs;
    final key = item.type == ConsumptionType.calories
        ? _caloriesKey
        : _waterKey;

    final existingItems = await getConsumptionItemsByType(item.type);
    existingItems.removeWhere((existingItem) => existingItem.id == item.id);

    final itemsJson = existingItems.map((e) => e.toMap()).toList();
    await prefs.setString(key, json.encode(itemsJson));
  }

  Future<void> updateConsumptionItem(ConsumptionItemEntity item) async {
    final prefs = await DBHelper.prefs;
    final key = item.type == ConsumptionType.calories
        ? _caloriesKey
        : _waterKey;

    final existingItems = await getConsumptionItemsByType(item.type);
    final index = existingItems.indexWhere(
      (existingItem) => existingItem.id == item.id,
    );

    if (index != -1) {
      existingItems[index] = item;
      final itemsJson = existingItems.map((e) => e.toMap()).toList();
      await prefs.setString(key, json.encode(itemsJson));
    }
  }

  Future<void> clearAllData() async {
    final prefs = await DBHelper.prefs;
    await prefs.remove(_caloriesKey);
    await prefs.remove(_waterKey);
  }

  Future<void> clearDataByType(ConsumptionType type) async {
    final prefs = await DBHelper.prefs;
    final key = type == ConsumptionType.calories ? _caloriesKey : _waterKey;
    await prefs.remove(key);
  }
}
