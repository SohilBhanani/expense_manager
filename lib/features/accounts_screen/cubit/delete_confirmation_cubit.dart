import 'package:flutter_bloc/flutter_bloc.dart';

enum DeleteConfirmation { isOpen, isClosed }

class DeleteConfirmationCubit extends Cubit<DeleteConfirmation> {
  DeleteConfirmationCubit() : super(DeleteConfirmation.isOpen);

  void toggleDeleteConfirmation() {
    if (state == DeleteConfirmation.isClosed) {
      emit(DeleteConfirmation.isOpen);
    } else if (state == DeleteConfirmation.isOpen) {
      emit(DeleteConfirmation.isClosed);
    }
  }
}
