import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'queries.dart';

class AccountDatabase {
  static late Database database;

  static Future<Database> init() async {
    final String path = await getDatabasesPath();
    // final Directory dir = await getApplicationDocumentsDirectory();
    // final String path = dir.path;
    log("Path to Database: " + path);

    bool isExi = await databaseExists(join(path, 'account_database.db'));

    log("exists: " + isExi.toString());
    database = await openDatabase(
      join(path, 'account_database.db'),

      // if created for first time
      onCreate: (db, version) {
        return db.execute(Query.createAccountsTable);
      },
      version: 1,
    );
    return database;
  }
}

class TransactionDatabase {
  static Future init(int accountId) async {
    await AccountDatabase.database.execute(Query.createAccTxnTable(accountId));
  }
}
