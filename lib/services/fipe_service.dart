import 'dart:convert';
import 'package:http/http.dart' as http;

class FipeService {
  Future<double> fetchMarketValueByFipeCode(String fipeCode) async {
    final url = Uri.parse('https://brasilapi.com.br/api/fipe/preco/v1/$fipeCode');
    final res = await http.get(url, headers: {'Accept': 'application/json'});

    if (res.statusCode != 200) {
      throw Exception('Falha na consulta FIPE (HTTP ${res.statusCode})');
    }

    final data = json.decode(res.body);
    if (data is! List || data.isEmpty) {
      throw Exception('Resposta FIPE inválida');
    }

    final first = data[0] as Map<String, dynamic>;
    final raw = (first['valor'] ?? '').toString();

    final cleaned = raw
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    final value = double.tryParse(cleaned);
    if (value == null) throw Exception('Não foi possível interpretar o valor FIPE');
    return value;
  }
}
