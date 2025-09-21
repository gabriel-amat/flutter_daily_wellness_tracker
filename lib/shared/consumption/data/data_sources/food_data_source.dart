import 'dart:convert';
import 'package:daily_wellness_tracker/core/database/db_helper.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/food_item_entity.dart';

class FoodDataSource {
  static const String _foodsKey = 'foods_data';

  Future<void> saveFoodItem(FoodEntity food) async {
    final prefs = await DBHelper.prefs;
    final existingFoods = await getAllFoodItems();

    existingFoods.removeWhere((f) => f.id == food.id);
    existingFoods.add(food);

    final foodsJson = existingFoods.map((e) => e.toJson()).toList();
    await prefs.setString(_foodsKey, json.encode(foodsJson));
  }

  Future<List<FoodEntity>> getAllFoodItems() async {
    final prefs = await DBHelper.prefs;
    final foodsString = prefs.getString(_foodsKey);

    if (foodsString == null) {
      return [];
    }

    final foodsList = json.decode(foodsString) as List;
    return foodsList.map((food) => FoodEntity.fromJson(food)).toList();
  }

  Future<List<FoodEntity>> searchFoodItems(String query) async {
    final allFoods = await getAllFoodItems();
    if (query.isEmpty) return allFoods;

    return allFoods
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<FoodEntity?> getFoodItemById(String id) async {
    final allFoods = await getAllFoodItems();
    try {
      return allFoods.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllFoods() async {
    final prefs = await DBHelper.prefs;
    await prefs.remove(_foodsKey);
  }
}
