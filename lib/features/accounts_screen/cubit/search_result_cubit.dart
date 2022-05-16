import 'package:account_manager/features/database/domain/model/transaction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultCubit extends Cubit<List<Transaction>> {
  SearchResultCubit() : super([]);

  void showSearchResults(List<Transaction> trxs) => emit([...trxs]);
  void clearSearchResults() => emit([]);
}
