import 'package:equatable/equatable.dart';

class Transaction {
  final int? id;
  final String? note;
  final int transactionDate;
  final double credit;
  final double payment;

  const Transaction({
    this.id,
    this.note,
    required this.transactionDate,
    required this.credit,
    required this.payment,
  });

  // Convert a Transaction into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transaction_date': transactionDate,
      'note': note,
      'credit': credit,
      'payment': payment,
    };
  }

  // Implement toString to make it easier to see information about
  // each Transaction when using the print statement.
  @override
  String toString() {
    return 'Transaction{id: $id, transaction_date: $transactionDate, note: $note, credit: $credit, payment: $payment}';
  }
}

class SumTrx extends Equatable {
  final double credit;
  final double payment;

  const SumTrx({required this.credit, required this.payment});

  @override
  List<Object?> get props => [credit, payment];
}
