import 'dart:io';

import 'package:animeapp/model/currency_model.dart';
import 'package:animeapp/service/currency_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class CurrencyRepositoy {
  late Isar db;
  Future<dynamic> chekDatabase() async {
    db = await openDatabase();
    if (await db.currencyModels.count() == 0) {
      return getCurency();
    } else {
      return await db.currencyModels.where().findAll();
    }
  }

  Future<dynamic> getCurency() async {
    CurrencyService currencyService = CurrencyService();
    return await currencyService.getCurrency().then((dynamic response) async {
      if (response is List<CurrencyModel>) {
        db = await openDatabase();
        await writeToDatabase(response);
        return await db.currencyModels.where().findAll();
      } else {
        return response.toString();
      }
    });
  }

  Future<Isar> openDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([CurrencyModelSchema], directory: appDocDir.path);
    } else {
      return await Future.value(Isar.getInstance());
    }
  }

  Future<void> writeToDatabase(List<CurrencyModel> data) async {
    final isar = db;
    isar.writeTxn(() async {
      await isar.currencyModels.clear();
      await isar.currencyModels.putAll(data);
    });
  }
}
