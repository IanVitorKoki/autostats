import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle_model.dart';
import '../providers/app_provider.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _plate = TextEditingController();
  final _mileage = TextEditingController();
  final _fipe = TextEditingController();

  @override
  void initState() {
    super.initState();
    final v = context.read<AppProvider>().vehicle;
    if (v != null) {
      _model.text = v.model;
      _year.text = v.year.toString();
      _plate.text = v.plate;
      _mileage.text = v.mileage.toStringAsFixed(0);
      _fipe.text = v.fipeCode;
    } else {
      _fipe.text = '59';
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _year.dispose();
    _plate.dispose();
    _mileage.dispose();
    _fipe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _model,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o modelo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _year,
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n < 1900 || n > 2100) return 'Ano inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _plate,
                decoration: const InputDecoration(labelText: 'Placa (opcional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mileage,
                decoration: const InputDecoration(labelText: 'Quilometragem atual'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                  if (n == null || n < 0) return 'Quilometragem inválida';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fipe,
                decoration: const InputDecoration(
                  labelText: 'Código FIPE (BrasilAPI)',
                  helperText: 'Exemplo: 59 (apenas para teste). Use o código do seu veículo para valor real.',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o código FIPE' : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final vehicle = Vehicle(
                    model: _model.text.trim(),
                    year: int.parse(_year.text.trim()),
                    plate: _plate.text.trim(),
                    mileage: double.parse(_mileage.text.trim().replaceAll(',', '.')),
                    fipeCode: _fipe.text.trim(),
                    marketValue: context.read<AppProvider>().vehicle?.marketValue ?? 0.0,
                  );

                  await context.read<AppProvider>().saveVehicle(vehicle);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veículo salvo!')));
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
