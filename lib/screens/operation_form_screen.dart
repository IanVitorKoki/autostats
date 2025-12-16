import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/operation_model.dart';
import '../providers/app_provider.dart';

class OperationFormScreen extends StatefulWidget {
  final Operation? editing;
  const OperationFormScreen({super.key, this.editing});

  @override
  State<OperationFormScreen> createState() => _OperationFormScreenState();
}

class _OperationFormScreenState extends State<OperationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  OperationType _type = OperationType.abastecimento;
  DateTime _date = DateTime.now();
  final _value = TextEditingController();

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _type = e.type;
      _date = e.date;
      _value.text = e.value.toStringAsFixed(2).replaceAll('.', ',');
    }
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  String _newId() {
    final r = Random();
    return '${DateTime.now().millisecondsSinceEpoch}-${r.nextInt(1 << 32)}';
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(widget.editing == null ? 'Novo gasto' : 'Editar gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<OperationType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: OperationType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(operationTypeLabel(t))))
                    .toList(),
                onChanged: (v) => setState(() => _type = v ?? OperationType.abastecimento),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data'),
                subtitle: Text(df.format(_date)),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _value,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse((v ?? '').replaceAll('.', '').replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final value = double.parse(_value.text.replaceAll('.', '').replaceAll(',', '.'));
                  final op = Operation(
                    id: widget.editing?.id ?? _newId(),
                    type: _type,
                    date: _date,
                    value: value,
                  );

                  await context.read<AppProvider>().upsertOperation(op);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(widget.editing == null ? 'Gasto adicionado!' : 'Gasto atualizado!')),
                    );
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
