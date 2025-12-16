import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/operation_model.dart';
import '../widgets/money_text.dart';
import '../widgets/empty_state.dart';
import 'operation_form_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final ops = p.filteredOperations;
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          PopupMenuButton<OperationType?>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (v) => context.read<AppProvider>().setFilter(v),
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: null, child: Text('Todas')),
              PopupMenuItem(value: OperationType.abastecimento, child: Text(operationTypeLabel(OperationType.abastecimento))),
              PopupMenuItem(value: OperationType.manutencao, child: Text(operationTypeLabel(OperationType.manutencao))),
              PopupMenuItem(value: OperationType.impostos, child: Text(operationTypeLabel(OperationType.impostos))),
            ],
          )
        ],
      ),
      body: ops.isEmpty
          ? const EmptyState(
              icon: Icons.history,
              title: 'Sem registros',
              subtitle: 'Adicione despesas para ver o histórico e os totalizadores.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: ops.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final total = ops.fold(0.0, (s, o) => s + o.value);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total do filtro', style: Theme.of(context).textTheme.titleMedium),
                          MoneyText(total, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }

                final op = ops[index - 1];
                return Dismissible(
                  key: ValueKey(op.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Excluir registro?'),
                            content: const Text('Essa ação não pode ser desfeita.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (_) async {
                    await context.read<AppProvider>().deleteOperation(op.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro excluído')));
                    }
                  },
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: Text(operationTypeLabel(op.type)),
                    subtitle: Text(df.format(op.date)),
                    trailing: MoneyText(op.value, style: const TextStyle(fontWeight: FontWeight.w700)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OperationFormScreen(editing: op)),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const OperationFormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
