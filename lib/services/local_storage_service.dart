import 'package:hive/hive.dart';
import '../models/vehicle_model.dart';
import '../models/operation_model.dart';

class LocalStorageService {
  static const vehicleBoxName = 'vehicleBox';
  static const operationsBoxName = 'operationsBox';

  Future<void> saveVehicle(Vehicle vehicle) async {
    final box = await Hive.openBox(vehicleBoxName);
    await box.put('vehicle', vehicle.toMap());
  }

  Future<Vehicle?> getVehicle() async {
    final box = await Hive.openBox(vehicleBoxName);
    final data = box.get('vehicle');
    if (data == null) return null;
    return Vehicle.fromMap(Map.from(data));
  }

  Future<List<Operation>> getOperations() async {
    final box = await Hive.openBox(operationsBoxName);
    final list = <Operation>[];
    for (final v in box.values) {
      list.add(Operation.fromMap(Map.from(v)));
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> upsertOperation(Operation op) async {
    final box = await Hive.openBox(operationsBoxName);
    await box.put(op.id, op.toMap());
  }

  Future<void> deleteOperation(String id) async {
    final box = await Hive.openBox(operationsBoxName);
    await box.delete(id);
  }
}
