import '../database.dart';
import '../domain/model/account_model.dart';

class AccountDataSource {
  //!inserts
  Future<void> insertAccount(Account account) async {
    await AccountDatabase.database.insert(
      'accounts',
      account.toMap(),
    );
  }

  //!fetchs
  Future<List<Account>> getAllAccounts() async {
    final List<Map<String, dynamic>> accountMaps =
        await AccountDatabase.database.query('accounts');

    return List.generate(
        accountMaps.length,
        (index) => Account(
              id: accountMaps[index]['id'],
              accountName: accountMaps[index]['account_name'],
              colorId: accountMaps[index]['color_id'],
              credit: accountMaps[index]['credit'],
              payment: accountMaps[index]['payment'],
            ));
  }

  //!update
  Future<void> updateAccount(Account account) async {
    // Update the given Account.
    await AccountDatabase.database.update(
      'accounts',
      account.toMap(),
      // Ensure that the Account has a matching id.
      where: 'id = ?',
      // Pass the Account's id as a whereArg to prevent SQL injection.
      whereArgs: [account.id],
    );
  }

  //!delete
  Future<void> deleteAccount(int id) async {
    // Remove the Account from the database.
    await AccountDatabase.database.delete(
      'accounts',
      // Use a `where` clause to delete a specific account.
      where: 'id = ?',
      // Pass the Account's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
