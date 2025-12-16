import 'package:flutter/material.dart';
import 'money_text.dart';

class TcoBar extends StatelessWidget {
  final double totalCost;
  final double marketValue;

  const TcoBar({
    super.key,
    required this.totalCost,
    required this.marketValue,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (marketValue <= 0) ? 0.0 : (totalCost / marketValue).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comparativo TCO', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total gasto'),
                MoneyText(totalCost, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Valor de mercado (FIPE)'),
                MoneyText(marketValue, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: ratio),
            const SizedBox(height: 8),
            Text('${(ratio * 100).toStringAsFixed(1)}% do valor de mercado já foi consumido em custos'),
          ],
        ),
      ),
    );
  }
}
