import 'dart:developer';

import 'package:account_manager/features/database/domain/model/account_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/data/account_datasource.dart';

class AccountsCubit extends Cubit<List<Account>> {
  AccountsCubit() : super([]);
  final accountDataSource = AccountDataSource();

  Future<void> getAccountsList() async {
    List<Account> accounts = await accountDataSource.getAllAccounts();
    log(accounts.toString());
    emit(accounts);
  }

  Future<void> deleteAccount(int id) async {
    await accountDataSource.deleteAccount(id);
    getAccountsList();
  }

  Future<void> editAccount(Account account) async {
    await accountDataSource.updateAccount(account);
    getAccountsList();
  }
}
