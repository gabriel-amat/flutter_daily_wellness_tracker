class WaterIntakeEntity {
  double? id;
  String date;
  double amount; // Amount of water in ml

  WaterIntakeEntity({this.id, required this.date, required this.amount});

  factory WaterIntakeEntity.fromJson(Map<String, dynamic> map) {
    return WaterIntakeEntity(
      id: map['id'] as double?,
      date: map['date'] as String,
      amount: map['amount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'date': date, 'amount': amount};
  }

  @override
  bool operator ==(covariant WaterIntakeEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.date == date && other.amount == amount;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ amount.hashCode;
  }

  WaterIntakeEntity copyWith({double? id, String? date, double? amount}) {
    return WaterIntakeEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
    );
  }
}
