class FoodEntity {
  final String id;
  final String name;
  final double caloriesPerPortion;
  final double carbsPerPortion;
  final double proteinPerPortion;
  final double fatPerPortion;
  final String portionUnit;
  final double portions;

  const FoodEntity({
    required this.id,
    required this.name,
    required this.caloriesPerPortion,
    required this.carbsPerPortion,
    required this.proteinPerPortion,
    required this.fatPerPortion,
    required this.portionUnit,
    this.portions = 1.0,
  });

  factory FoodEntity.fromJson(Map<String, dynamic> json) {
    return FoodEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      caloriesPerPortion: json['calories_per_portion'] as double,
      carbsPerPortion: json['carbs_per_portion'] as double,
      proteinPerPortion: json['protein_per_portion'] as double,
      fatPerPortion: json['fat_per_portion'] as double,
      portionUnit: json['portion_unit'] as String,
      portions: json['portions'] as double? ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories_per_portion': caloriesPerPortion,
      'carbs_per_portion': carbsPerPortion,
      'protein_per_portion': proteinPerPortion,
      'fat_per_portion': fatPerPortion,
      'portion_unit': portionUnit,
      'portions': portions,
    };
  }

  double get totalCalories => caloriesPerPortion * portions;
  double get totalCarbs => carbsPerPortion * portions;
  double get totalProtein => proteinPerPortion * portions;
  double get totalFat => fatPerPortion * portions;

  FoodEntity copyWith({
    String? id,
    String? name,
    double? caloriesPerPortion,
    double? carbsPerPortion,
    double? proteinPerPortion,
    double? fatPerPortion,
    String? portionUnit,
    double? portions,
  }) {
    return FoodEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      caloriesPerPortion: caloriesPerPortion ?? this.caloriesPerPortion,
      carbsPerPortion: carbsPerPortion ?? this.carbsPerPortion,
      proteinPerPortion: proteinPerPortion ?? this.proteinPerPortion,
      fatPerPortion: fatPerPortion ?? this.fatPerPortion,
      portionUnit: portionUnit ?? this.portionUnit,
      portions: portions ?? this.portions,
    );
  }
}
