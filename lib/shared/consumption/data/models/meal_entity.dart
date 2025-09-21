import 'package:daily_wellness_tracker/shared/consumption/data/models/food_item_entity.dart';

class MealEntity {
  double? id;
  String date;
  String name;
  List<FoodEntity> foods;

  double get totalCalories =>
      foods.fold(0.0, (sum, food) => sum + food.totalCalories);

  double get totalCarbs =>
      foods.fold(0.0, (sum, food) => sum + food.totalCarbs);

  double get totalProtein =>
      foods.fold(0.0, (sum, food) => sum + food.totalProtein);

  double get totalFat => foods.fold(0.0, (sum, food) => sum + food.totalFat);

  MealEntity({
    this.id,
    required this.date,
    required this.name,
    required this.foods,
  });

  factory MealEntity.fromJson(Map<String, dynamic> json) {
    return MealEntity(
      id: json['id'] as double?,
      date: json['date'] as String,
      name: json['name'] as String,
      foods: (json['foods'] as List)
          .map((food) => FoodEntity.fromJson(food))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'name': name,
      'foods': foods.map((food) => food.toJson()).toList(),
    };
  }

  MealEntity copyWith({
    double? id,
    String? date,
    String? name,
    List<FoodEntity>? foods,
  }) {
    return MealEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      foods: foods ?? this.foods,
    );
  }
}
