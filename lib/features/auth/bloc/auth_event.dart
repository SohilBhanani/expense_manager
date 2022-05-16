part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthSignUp extends AuthEvent {
  const AuthSignUp({
    required this.pin,
    required this.securityQuestionOne,
    required this.answerOne,
    required this.securityQuestionTwo,
    required this.answerTwo,
  });

  final String pin;
  final String securityQuestionOne;
  final String answerOne;
  final String answerTwo;
  final String securityQuestionTwo;
}
