import 'dart:convert';

import 'package:account_manager/features/prefs/prefs.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/config_model.dart';

part 'auth_status_state.dart';

class AuthStatusCubit extends Cubit<ConfigModel> {
  final ConfigModel auth;
  AuthStatusCubit(this.auth) : super(auth);
  ConfigModel? _authStatus;
  Future<void> updateAuthStatusModel({
    String? pin,
    String? securityQuestionOne,
    String? securityAnswerOne,
    String? securityQuestionTwo,
    String? securityAnswerTwo,
    CurrencyModel? currency,
    SettingsModel? settings,
  }) async {
    _authStatus = Prefs.getString("authStatus") == null
        ? null
        : ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
    if (_authStatus == null) {
      ConfigModel newAuthData = ConfigModel().copyWith(
          pin: pin,
          securityQuestionOne: securityQuestionOne,
          securityAnswerOne: securityAnswerOne,
          securityQuestionTwo: securityQuestionTwo,
          securityAnswerTwo: securityAnswerTwo,
          currency: currency,
          settings: settings);
      await Prefs.setString('authStatus', jsonEncode(newAuthData));
      emit(newAuthData);
    } else {
      ConfigModel newAuthStatus =
          ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
      ConfigModel authStatus = newAuthStatus.copyWith(
          pin: pin,
          securityQuestionOne: securityQuestionOne,
          securityAnswerOne: securityAnswerOne,
          securityQuestionTwo: securityQuestionTwo,
          securityAnswerTwo: securityAnswerTwo,
          currency: currency,
          settings: settings);
      await Prefs.setString('authStatus', jsonEncode(authStatus));
      emit(authStatus);
    }
  }

  Future<void> resetData() async {
    await Prefs.remove('authStatus');
    emit(ConfigModel());
  }
}
