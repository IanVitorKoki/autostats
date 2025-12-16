import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/vehicle_model.dart';
import '../models/operation_model.dart';
import '../services/local_storage_service.dart';
import '../services/fipe_service.dart';

class AppProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final FipeService _fipe = FipeService();

  Vehicle? vehicle;
  List<Operation> operations = [];
  bool loading = false;

  OperationType? historyFilter;

  Future<void> init() async {
    vehicle = await _storage.getVehicle();
    operations = await _storage.getOperations();
    notifyListeners();
  }

  List<Operation> get filteredOperations {
    final f = historyFilter;
    if (f == null) return operations;
    return operations.where((o) => o.type == f).toList();
  }

  double get totalCostAll => operations.fold(0.0, (s, o) => s + o.value);

  double totalCostBy(OperationType type) =>
      operations.where((o) => o.type == type).fold(0.0, (s, o) => s + o.value);

  double get marketValue => vehicle?.marketValue ?? 0.0;

  double get tcoRatio {
    final mv = marketValue;
    if (mv <= 0) return 0;
    return min(1.0, totalCostAll / mv);
  }

  Future<void> saveVehicle(Vehicle v) async {
    await _storage.saveVehicle(v);
    vehicle = v;
    notifyListeners();
  }

  Future<void> upsertOperation(Operation op) async {
    await _storage.upsertOperation(op);
    final idx = operations.indexWhere((e) => e.id == op.id);
    if (idx >= 0) {
      operations[idx] = op;
    } else {
      operations.add(op);
    }
    operations.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> deleteOperation(String id) async {
    await _storage.deleteOperation(id);
    operations.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setFilter(OperationType? t) {
    historyFilter = t;
    notifyListeners();
  }

  Future<void> refreshMarketValue() async {
    final v = vehicle;
    if (v == null) throw Exception('Cadastre um veículo antes de consultar a FIPE.');
    final code = v.fipeCode.trim();
    if (code.isEmpty) throw Exception('Informe o código FIPE no cadastro do veículo.');

    loading = true;
    notifyListeners();
    try {
      final value = await _fipe.fetchMarketValueByFipeCode(code);
      vehicle = Vehicle(
        model: v.model,
        year: v.year,
        plate: v.plate,
        mileage: v.mileage,
        fipeCode: v.fipeCode,
        marketValue: value,
      );
      await _storage.saveVehicle(vehicle!);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
