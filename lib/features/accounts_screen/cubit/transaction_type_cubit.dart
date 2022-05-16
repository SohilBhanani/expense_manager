import 'package:flutter_bloc/flutter_bloc.dart';

enum TransactionType { credit, payment, none }

class TransactionTypeCubit extends Cubit<TransactionType> {
  TransactionTypeCubit() : super(TransactionType.none);

  void switchTransactionTypeTo(TransactionType type) => emit(type);
}
