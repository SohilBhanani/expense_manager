class Account {
  final int? id;
  final String accountName;
  final int colorId;
  // final String balance;
  final double credit;
  final double payment;

  const Account({
    this.id,
    required this.accountName,
    required this.colorId,
    // required this.balance,
    required this.credit,
    required this.payment,
  });

  // Convert a Account into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_name': accountName,
      'color_id': colorId,
      // 'balance': balance,
      'credit': credit,
      'payment': payment,
    };
  }

  // Implement toString to make it easier to see information about
  // each account when using the print statement.
  @override
  String toString() {
    return 'Account{id: $id, account_name: $accountName, color_id: $colorId, credit: $credit, payment: $payment}';
  }
}
