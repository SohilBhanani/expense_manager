import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess(
        pin: event.pin,
        securityQuestionOne: event.securityQuestionOne,
        answerOne: event.answerOne,
        securityQuestionTwo: event.securityQuestionTwo,
        answerTwo: event.answerTwo,
      ));
    });
  }
}
