import 'package:flutter/material.dart';
import '../models/operation_model.dart';
import 'money_text.dart';

class CategoryBars extends StatelessWidget {
  final double abastecimento;
  final double manutencao;
  final double impostos;

  const CategoryBars({
    super.key,
    required this.abastecimento,
    required this.manutencao,
    required this.impostos,
  });

  @override
  Widget build(BuildContext context) {
    final total = abastecimento + manutencao + impostos;
    double pct(double v) => total <= 0 ? 0 : (v / total).clamp(0.0, 1.0);

    Widget row(String label, double value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                MoneyText(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: pct(value)),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distribuição por categoria', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            row(operationTypeLabel(OperationType.abastecimento), abastecimento),
            row(operationTypeLabel(OperationType.manutencao), manutencao),
            row(operationTypeLabel(OperationType.impostos), impostos),
          ],
        ),
      ),
    );
  }
}
