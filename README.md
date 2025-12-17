# AutoStats — Projeto Final Flutter


App em Flutter para gestão financeira e operacional de um veículo, com persistência local (Hive) e consulta do valor de mercado via API pública da Tabela FIPE (BrasilAPI).

## Arquitetura
- `lib/models` - modelos (Vehicle, Operation)
- `lib/services` - acesso a dados (Hive) e integração FIPE (HTTP)
- `lib/providers` - gerenciamento de estado (Provider)
- `lib/screens` - telas (Dashboard/Home, Veículo, Histórico, Form de Operação)
- `lib/widgets` - componentes reutilizáveis

## Pacotes
- provider
- hive / hive_flutter
- http
- intl

## Como executar
```bash
flutter pub get
flutter run
```

## Fluxo para o vídeo (obrigatório)
1. Abrir app e cadastrar veículo (inclua um Código FIPE).
2. Adicionar um gasto (Novo gasto).
3. Abrir Histórico e filtrar por categoria.
4. No Dashboard/Home, clicar em "Atualizar FIPE" e mostrar loading.
5. Mostrar comparativo TCO: Total gasto vs Valor de mercado.

   ## Vídeo demonstrativo
https://drive.google.com/drive/folders/10MKe-7uC7e-UeBzbp8MI27v7cMmEkjyK?usp=sharing

Fluxo demonstrado:
- Cadastro do veículo
- Inserção de despesas
- Histórico com filtro
- Atualização de valor via API FIPE
- Dashboard com comparativo de TCO

