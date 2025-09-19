# Sistema Centralizado de Armazenamento de Consumo

Este sistema permite armazenar e gerenciar entradas de **calorias** e **água** de forma centralizada, sendo compartilhado entre todas as features do app.

## Estrutura

```
lib/
├── core/
│   ├── database/
│   │   ├── dao/
│   │   │   └── consumption_dao.dart          # DAO para operações no banco
│   │   └── models/
│   │       └── consumption_item.dart         # Modelo unificado (já existente)
│   ├── services/
│   │   └── consumption_service.dart          # Serviço de alto nível
│   └── examples/
│       └── water_consumption_example.dart    # Exemplo de uso para água
```

## Como Usar

### 1. Serviço Centralizado

O `ConsumptionService` é um singleton que fornece métodos de alto nível:

```dart
import 'package:daily_wellness_tracker/core/services/consumption_service.dart';

final service = ConsumptionService();

// Adicionar calorias
await service.addCalorieEntry(150.0); // 150 calorias
await service.addCalorieEntry(200.0, customDate: '2024-09-18');

// Adicionar água
await service.addWaterEntry(250.0); // 250ml
await service.addWaterEntry(500.0, customDate: '2024-09-18');

// Consultar dados
double todayCalories = await service.getTodayCalories();
double todayWater = await service.getTodayWater();

// Histórico
List<ConsumptionItem> history = await service.getAllHistory();
List<ConsumptionItem> todayHistory = await service.getHistoryByDate('2024-09-18');
```

### 2. Features que Já Usam o Sistema

#### Feature History
O `HistoryDao` foi atualizado para usar o sistema centralizado:

```dart
final historyDao = HistoryDao();

// Obtém todo o histórico
List<ConsumptionItem> allHistory = await historyDao.getHistory();

// Obtém histórico de uma data específica
List<ConsumptionItem> dayHistory = await historyDao.getHistoryByDate('2024-09-18');

// Obtém histórico dos últimos N dias
List<ConsumptionItem> recentHistory = await historyDao.getRecentHistory(7);
```

#### Feature AddCalorie
O `AddCalorieViewModel` foi atualizado para salvar no sistema centralizado:

```dart
// O método saveEntry() agora salva no sistema centralizado
await viewModel.saveEntry();

// Pode consultar o total do dia
double total = await viewModel.getTodayTotalCalories();
```

### 3. Como Integrar Novas Features

#### Exemplo 1: Adicionando água no dashboard

```dart
class DashboardViewModel extends ChangeNotifier {
  final ConsumptionService _service = ConsumptionService();
  
  Future<void> addGlassOfWater() async {
    await _service.addWaterEntry(250.0); // 250ml
    notifyListeners();
  }
  
  Future<double> getTodayWaterTotal() async {
    return await _service.getTodayWater();
  }
}
```

#### Exemplo 2: Criando uma nova feature de água

```dart
class WaterTrackingViewModel extends ChangeNotifier {
  final ConsumptionService _service = ConsumptionService();
  
  Future<void> logWaterIntake(double amount) async {
    await _service.addWaterEntry(amount);
    notifyListeners();
  }
  
  Future<List<ConsumptionItem>> getTodayWaterEntries() async {
    return await _service.getTodayWaterEntries();
  }
}
```

## Modelos de Dados

### ConsumptionItem
```dart
class ConsumptionItem {
  final double? id;           // ID único (timestamp)
  final String date;          // Data no formato 'YYYY-MM-DD'
  final double value;         // Valor (calorias ou ml)
  final ConsumptionType type; // calories ou water
}
```

### ConsumptionType
```dart
enum ConsumptionType {
  calories('Calories'),
  water('Water');
}
```

## Métodos Disponíveis

### ConsumptionService

#### Calorias
- `addCalorieEntry(double calories, {String? customDate})`
- `getTodayCalories()` → `Future<double>`
- `getCaloriesByDate(String date)` → `Future<double>`
- `getTodayCalorieEntries()` → `Future<List<ConsumptionItem>>`

#### Água
- `addWaterEntry(double milliliters, {String? customDate})`
- `getTodayWater()` → `Future<double>`
- `getWaterByDate(String date)` → `Future<double>`
- `getTodayWaterEntries()` → `Future<List<ConsumptionItem>>`

#### Gerais
- `getAllHistory()` → `Future<List<ConsumptionItem>>`
- `getHistoryByDate(String date)` → `Future<List<ConsumptionItem>>`
- `removeEntry(ConsumptionItem item)`
- `updateEntry(ConsumptionItem item)`
- `clearAllData()`

### Utilidades
- `formatDateToString(DateTime date)` → `String`
- `parseDateString(String dateString)` → `DateTime?`

## Armazenamento

Os dados são salvos usando `SharedPreferences` através do `DBHelper`, com duas chaves:
- `calories_data`: Todas as entradas de calorias
- `water_data`: Todas as entradas de água

Os dados são serializados como JSON e cada entrada tem um ID único baseado no timestamp.

## Benefícios

1. **Centralizado**: Um só lugar para gerenciar todos os dados de consumo
2. **Compartilhado**: Todas as features acessam os mesmos dados
3. **Consistente**: Formato uniforme para calorias e água
4. **Flexível**: Fácil de estender para novos tipos de consumo
5. **Histórico**: Automático e unificado para todas as features