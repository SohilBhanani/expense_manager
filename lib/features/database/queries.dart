class Query {
  static const String createAccountsTable =
      'CREATE TABLE accounts(id INTEGER PRIMARY KEY AUTOINCREMENT, account_name TEXT, color_id INTEGER, credit REAL, payment REAL)';

  static String createAccTxnTable(int accountId) =>
      "CREATE TABLE IF NOT EXISTS account$accountId(id INTEGER PRIMARY KEY AUTOINCREMENT, transaction_date INTEGER, note TEXT, credit REAL, payment REAL)";

  static String searchAmongDate(int accountId, int dateFrom, int dateTo) =>
      "SELECT * FROM account$accountId WHERE transaction_date BETWEEN $dateFrom AND $dateTo";
}
