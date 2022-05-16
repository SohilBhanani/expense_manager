import 'dart:developer';

import 'package:account_manager/features/database/database.dart';
import 'package:account_manager/features/database/domain/model/transaction_model.dart';

class TransactionDataSource {
  //!inserts
  Future<void> insertTxn(Transaction txn, int accountId) async {
    await AccountDatabase.database.insert(
      'account$accountId',
      txn.toMap(),
    );
  }

  //!fetchs
  Future<List<Transaction>> getAllTxnOf(
      int accountId, bool requestSorted) async {
    final List<Map<String, dynamic>> txnMaps = requestSorted
        ? await AccountDatabase.database
            .query('account$accountId', orderBy: 'transaction_date')
        : await AccountDatabase.database.query('account$accountId');
    log("--> getAllTxnOf: " + txnMaps.toString());
    return List.generate(
        txnMaps.length,
        (index) => Transaction(
              id: txnMaps[index]['id'],
              note: txnMaps[index]['note'],
              transactionDate: txnMaps[index]['transaction_date'],
              credit: txnMaps[index]['credit'],
              payment: txnMaps[index]['payment'],
            ));
  }

  Future<SumTrx> getSumTrx(int accountId) async {
    List<Map> sumCredit = await AccountDatabase.database
        .rawQuery("SELECT SUM(credit) FROM account$accountId");
    List<Map> sumPayment = await AccountDatabase.database
        .rawQuery("SELECT SUM(payment) FROM account$accountId");

    return SumTrx(
      credit: sumCredit[0]['SUM(credit)'] == null
          ? 0
          : (sumCredit[0]['SUM(credit)'] as double),
      payment: sumPayment[0]['SUM(payment)'] == null
          ? 0
          : (sumPayment[0]['SUM(payment)'] as double),
    );
  }

  Future<List<Transaction>> searchTransaction({
    required int accountId,
    String? note,
    double? amount,
    int? dateFrom,
    int? dateTo,
  }) async {
    log('[$note, $amount, $dateFrom, $dateTo]');
    late List<Map<String, dynamic>> txnMaps;
    if (note == null && amount == null && dateFrom != null) {
      //done
      txnMaps = await AccountDatabase.database.query(
        'account$accountId',
        where: 'transaction_date BETWEEN ? AND ?',
        whereArgs: [dateFrom, dateTo],
      );
    } else if (note == null && amount != null && dateFrom == null) {
      //done
      txnMaps = await AccountDatabase.database.query(
        'account$accountId',
        where: 'credit = ? OR payment = ?',
        whereArgs: [amount, amount],
      );
    } else if (note == null && amount != null && dateFrom != null) {
      //done
      txnMaps = await AccountDatabase.database.query(
        'account$accountId',
        where:
            '(credit = ? OR payment = ?) AND transaction_date BETWEEN ? AND ?',
        whereArgs: [amount, amount, dateFrom, dateTo],
      );
    } else if (note != null && amount == null && dateFrom == null) {
      //done
      txnMaps = await AccountDatabase.database.query(
        'account$accountId',
        where: 'note LIKE ?',
        whereArgs: ['%$note%'],
      );
    } else if (note != null && amount == null && dateFrom != null) {
      //done
      txnMaps = await AccountDatabase.database.query(
        'account$accountId',
        where: 'note LIKE ? AND transaction_date BETWEEN ? AND ?',
        whereArgs: ['%$note%', dateFrom, dateTo],
      );
    } else if (note != null && amount != null && dateFrom == null) {
      txnMaps = await AccountDatabase.database.query(
        'account$accountId',
        where: 'note LIKE ? AND (credit = ? OR payment = ?)',
        whereArgs: ['%$note%', amount, amount],
      );
    } else {
      //done
      txnMaps = await AccountDatabase.database.query(
        'account$accountId',
        where:
            'note LIKE ? AND (credit = ? OR payment = ?) AND transaction_date BETWEEN ? AND ?',
        whereArgs: ['%$note%', amount, amount, dateFrom, dateTo],
      );
    }

    log(txnMaps.toString());
    return List.generate(
        txnMaps.length,
        (index) => Transaction(
              id: txnMaps[index]['id'],
              note: txnMaps[index]['note'],
              transactionDate: txnMaps[index]['transaction_date'],
              credit: txnMaps[index]['credit'],
              payment: txnMaps[index]['payment'],
            ));
  }

  //!update
  Future<void> updateTxn(Transaction txn, int accountId) async {
    // Update the given Transaction.
    await AccountDatabase.database.update(
      'account$accountId',
      txn.toMap(),
      // Ensure that the Transaction has a matching id.
      where: 'id = ?',
      // Pass the Transaction's id as a whereArg to prevent SQL injection.
      whereArgs: [txn.id],
    );
  }

  //!delete
  Future<void> deleteTxn(int id, int accountId) async {
    // Remove  Transaction from the database.
    await AccountDatabase.database.delete(
      'account$accountId',
      // Use a `where` clause to delete a specific txn.
      where: 'id = ?',
      // Pass the Transaction's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
