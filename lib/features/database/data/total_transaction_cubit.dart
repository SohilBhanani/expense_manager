import 'package:account_manager/features/database/data/account_datasource.dart';
import 'package:account_manager/features/database/data/transaction_datasource.dart';
import 'package:account_manager/features/database/domain/model/account_model.dart';
import 'package:account_manager/features/database/domain/model/transaction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalTransactionCubit extends Cubit<SumTrx> {
  TotalTransactionCubit() : super(const SumTrx(credit: 0, payment: 0));
  final transactionDataSource = TransactionDataSource();
  final accountDataSource = AccountDataSource();
  Future<void> getSumTrx(Account account) async {
    SumTrx trx = await transactionDataSource.getSumTrx(account.id!);
    await accountDataSource.updateAccount(
      Account(
          id: account.id,
          accountName: account.accountName,
          colorId: account.colorId,
          credit: trx.credit,
          payment: trx.payment),
    );
    emit(trx);
  }
}
