part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess({
    required this.pin,
    required this.securityQuestionOne,
    required this.answerOne,
    required this.securityQuestionTwo,
    required this.answerTwo,
  });
  final String pin;
  final String securityQuestionOne;
  final String answerOne;
  final String securityQuestionTwo;
  final String answerTwo;
}
