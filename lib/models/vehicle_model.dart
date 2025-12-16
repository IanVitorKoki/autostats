class Vehicle {
  String model;
  int year;
  String plate;
  double mileage;
  String fipeCode;
  double marketValue;

  Vehicle({
    required this.model,
    required this.year,
    required this.plate,
    required this.mileage,
    required this.fipeCode,
    this.marketValue = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'year': year,
      'plate': plate,
      'mileage': mileage,
      'fipeCode': fipeCode,
      'marketValue': marketValue,
    };
  }

  factory Vehicle.fromMap(Map map) {
    return Vehicle(
      model: (map['model'] ?? '') as String,
      year: (map['year'] as num).toInt(),
      plate: (map['plate'] ?? '') as String,
      mileage: (map['mileage'] as num).toDouble(),
      fipeCode: (map['fipeCode'] ?? '59') as String,
      marketValue: (map['marketValue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
