// import 'package:daily_wellness_tracker/core/consumption/consumption_service.dart';
// import 'package:flutter/material.dart';

// /// Exemplo de como usar o ConsumptionService para água no dashboard
// class WaterConsumptionExample extends ChangeNotifier {
//   final ConsumptionService _consumptionService = ConsumptionService();

//   double _todayWaterTotal = 0.0;
//   bool _isLoading = false;

//   double get todayWaterTotal => _todayWaterTotal;
//   bool get isLoading => _isLoading;

//   /// Adiciona água (em ml)
//   Future<void> addWater(double milliliters) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       await _consumptionService.addWaterEntry(milliliters);
//       await _loadTodayWaterTotal(); // Recarrega o total
//     } catch (e) {
//       debugPrint('Erro ao adicionar água: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Carrega o total de água do dia
//   Future<void> _loadTodayWaterTotal() async {
//     _todayWaterTotal = await _consumptionService.getTodayWater();
//   }

//   /// Método para inicializar os dados (chamar no initState)
//   Future<void> initialize() async {
//     await _loadTodayWaterTotal();
//     notifyListeners();
//   }

//   /// Adiciona quantidade padrão de água (ex: 250ml - um copo)
//   Future<void> addGlassOfWater() async {
//     await addWater(250.0);
//   }

//   /// Adiciona quantidade padrão de água (ex: 500ml - uma garrafa)
//   Future<void> addBottleOfWater() async {
//     await addWater(500.0);
//   }
// }
