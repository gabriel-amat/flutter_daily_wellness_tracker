import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';

class ConsumptionItemEntity {
  double? id;
  String date;
  double value;
  ConsumptionType type;

  ConsumptionItemEntity({
    this.id,
    required this.date,
    required this.value,
    required this.type,
  });

  factory ConsumptionItemEntity.fromMap(Map<String, dynamic> map) {
    return ConsumptionItemEntity(
      id: map['id'] as double?,
      date: map['date'] as String,
      value: map['value'] as double,
      type: ConsumptionType.values[map['type'] as int],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'value': value, 'type': type.index};
  }

  double get getCalories => type == ConsumptionType.calories ? value : 0.0;

  double get getWater => type == ConsumptionType.water ? value : 0.0;

  @override
  bool operator ==(covariant ConsumptionItemEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.value == value &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ value.hashCode ^ type.hashCode;
  }
}
