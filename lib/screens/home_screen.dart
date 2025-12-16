import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/money_text.dart';
import '../widgets/tco_bar.dart';
import '../widgets/category_bars.dart';
import '../widgets/empty_state.dart';
import '../models/operation_model.dart';
import 'vehicle_screen.dart';
import 'history_screen.dart';
import 'operation_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final v = p.vehicle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoStats'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await context.read<AppProvider>().refreshMarketValue();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Valor de mercado atualizado!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                  );
                }
              }
            },
            icon: p.loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
            tooltip: 'Atualizar FIPE',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const OperationFormScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo gasto'),
      ),
      body: v == null
          ? const EmptyState(
              icon: Icons.directions_car,
              title: 'Cadastre seu veículo',
              subtitle: 'Para começar, informe os dados do seu veículo principal.',
            )
          : RefreshIndicator(
              onRefresh: () async => context.read<AppProvider>().init(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${v.model} (${v.year})', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 6),
                          Text('Placa: ${v.plate.isEmpty ? '-' : v.plate}  •  KM: ${v.mileage.toStringAsFixed(0)}'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Custo total acumulado'),
                              MoneyText(p.totalCostAll, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VehicleScreen())),
                                icon: const Icon(Icons.edit),
                                label: const Text('Editar veículo'),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                                icon: const Icon(Icons.history),
                                label: const Text('Histórico'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TcoBar(totalCost: p.totalCostAll, marketValue: p.marketValue),
                  const SizedBox(height: 12),
                  CategoryBars(
                    abastecimento: p.totalCostBy(OperationType.abastecimento),
                    manutencao: p.totalCostBy(OperationType.manutencao),
                    impostos: p.totalCostBy(OperationType.impostos),
                  ),
                ],
              ),
            ),
    );
  }
}
