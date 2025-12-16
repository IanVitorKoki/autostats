import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyText extends StatelessWidget {
  final double value;
  final TextStyle? style;

  const MoneyText(this.value, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Text(f.format(value), style: style);
  }
}
