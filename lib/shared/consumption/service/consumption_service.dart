import 'dart:developer';

import 'package:daily_wellness_tracker/core/helper/format_data.dart';
import 'package:daily_wellness_tracker/shared/consumption/dao/consumption_dao.dart';
import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';

class ConsumptionService {
  final ConsumptionDao _consumptionDao;

  ConsumptionService({required ConsumptionDao consumptionDao})
    : _consumptionDao = consumptionDao;

  Future<void> addCalorieEntry(double value) async {
    final item = ConsumptionItemEntity(
      date: FormatDate.dateTimeToString(DateTime.now()),
      value: value,
      type: ConsumptionType.calories,
    );
    log('Adding calorie entry: $item');
    await _consumptionDao.addConsumptionItem(item);
  }

  Future<double> getTodayCalories() async {
    return await _consumptionDao.getTotalConsumptionByTypeAndDate(
      ConsumptionType.calories,
      FormatDate.dateTimeToString(DateTime.now()),
    );
  }

  Future<List<ConsumptionItemEntity>> getTodayCalorieEntries() async {
    return await _consumptionDao.getConsumptionItemsByTypeAndDate(
      ConsumptionType.calories,
      FormatDate.dateTimeToString(DateTime.now()),
    );
  }

  Future<void> addWaterEntry(double value) async {
    final item = ConsumptionItemEntity(
      date: FormatDate.dateTimeToString(DateTime.now()),
      value: value,
      type: ConsumptionType.water,
    );
    await _consumptionDao.addConsumptionItem(item);
  }

  Future<double> getTodayWater() async {
    return await _consumptionDao.getTotalConsumptionByTypeAndDate(
      ConsumptionType.water,
      FormatDate.dateTimeToString(DateTime.now()),
    );
  }

  Future<List<ConsumptionItemEntity>> getTodayWaterEntries() async {
    return await _consumptionDao.getConsumptionItemsByTypeAndDate(
      ConsumptionType.water,
      FormatDate.dateTimeToString(DateTime.now()),
    );
  }

  Future<List<ConsumptionItemEntity>> getAllHistory() async {
    return await _consumptionDao.getAllConsumptionItems();
  }

  Future<void> removeEntry(ConsumptionItemEntity item) async {
    await _consumptionDao.removeConsumptionItem(item);
  }

  Future<void> updateEntry(ConsumptionItemEntity item) async {
    await _consumptionDao.updateConsumptionItem(item);
  }

  Future<void> clearAllData() async {
    await _consumptionDao.clearAllData();
  }

  clearDataByType(ConsumptionType type) async {
    await _consumptionDao.clearDataByType(type);
  }
}
