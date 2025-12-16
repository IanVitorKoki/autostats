enum OperationType { abastecimento, manutencao, impostos }

class Operation {
  String id;
  OperationType type;
  DateTime date;
  double value;

  Operation({
    required this.id,
    required this.type,
    required this.date,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'date': date.toIso8601String(),
      'value': value,
    };
  }

  factory Operation.fromMap(Map map) {
    return Operation(
      id: map['id'] as String,
      type: OperationType.values[(map['type'] as num).toInt()],
      date: DateTime.parse(map['date'] as String),
      value: (map['value'] as num).toDouble(),
    );
  }
}

String operationTypeLabel(OperationType t) {
  switch (t) {
    case OperationType.abastecimento:
      return 'Abastecimento/Recarga';
    case OperationType.manutencao:
      return 'Manutenção';
    case OperationType.impostos:
      return 'Impostos';
  }
}
