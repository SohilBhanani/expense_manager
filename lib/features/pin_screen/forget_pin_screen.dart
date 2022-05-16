import 'dart:convert';

import 'package:account_manager/features/prefs/cubit/auth_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/style/style.dart';
import '../prefs/model/config_model.dart';
import '../prefs/prefs.dart';

class ForgetPinScreen extends StatefulWidget {
  const ForgetPinScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPinScreen> createState() => _ForgetPinScreenState();
}

class _ForgetPinScreenState extends State<ForgetPinScreen> {
  final _answerOneController = TextEditingController();
  final _answerTwoController = TextEditingController();
  bool _isEnabled = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _answerOneController.dispose();
    _answerTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    ConfigModel authStatus =
        ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              UIH.vertGapMedium,
              Text(
                'No worries',
                style: TS.sb14(clr: MyColors.greyShade2, letterSpace: 0.6),
              ),
              UIH.vertGapSmall,
              Text(
                'You can always reset your PIN',
                maxLines: 2,
                style: TS.b20(clr: MyColors.greyShade3),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIH.vertGapMedium,
                  Text(
                    authStatus.securityQuestionOne!,
                    maxLines: 2,
                    style: const TS.b16(clr: MyColors.greyShade3),
                  ),
                  UIH.vertGapSmall,
                  const Text(
                    'Answer',
                    style: TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
                  ),
                  UIH.vertGapTiny,
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      controller: _answerOneController,
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      // onChanged: (_) {
                      //   _formKey.currentState!.validate();
                      // },
                      decoration: const InputDecoration(
                          hintText: 'Type here..',
                          hintStyle: TS.r16(clr: MyColors.greyShade1),
                          errorStyle: TextStyle(height: 0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.greyShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.greyShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.redShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.redShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          contentPadding: EdgeInsets.only(left: 10)),
                    ),
                  ),
                  UIH.vertGapMedium,
                  UIH.vertGapMedium,
                  Text(
                    authStatus.securityQuestionTwo!,
                    maxLines: 2,
                    style: const TS.b16(clr: MyColors.greyShade3),
                  ),
                  UIH.vertGapSmall,
                  const Text(
                    'Answer',
                    style: TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
                  ),
                  UIH.vertGapTiny,
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      controller: _answerTwoController,
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        _formKey.currentState!.validate();
                      },
                      decoration: const InputDecoration(
                          hintText: 'Type here..',
                          hintStyle: TS.r16(clr: MyColors.greyShade1),
                          errorStyle: TextStyle(height: 0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.greyShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.greyShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.redShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.redShade1,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          contentPadding: EdgeInsets.only(left: 10)),
                    ),
                  ),
                  UIH.vertGapMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_answerOneController.text ==
                                    authStatus.securityAnswerOne &&
                                _answerTwoController.text ==
                                    authStatus.securityAnswerTwo) {
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 1),
                                      backgroundColor: MyColors.greenShade1,
                                      content: Text(
                                        "Success !",
                                        style: TS.sb14(clr: MyColors.white),
                                      )));
                              setState(() {
                                _isEnabled = true;
                              });
                            } else {
                              setState(() {
                                _isEnabled = false;
                              });
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 1),
                                      backgroundColor: MyColors.redShade1,
                                      content: Text(
                                        "Invalid Answer !",
                                        style: TS.sb14(clr: MyColors.white),
                                      )));
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Answer fields are required');
                          }
                        },
                        child: const Text(
                          'Check',
                          style: TS.sb12(clr: MyColors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            primary: MyColors.blueShade2),
                      ),
                    ],
                  ),
                  EnterNewPinWidget(
                    isEnabled: _isEnabled,
                    onSuccess: (String newPin) async {
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      context
                          .read<AuthStatusCubit>()
                          .updateAuthStatusModel(pin: newPin);
                      await Future.delayed(const Duration(milliseconds: 300));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: MyColors.greenShade1,
                          content: Text(
                            "PIN changed successfully !",
                            style: TS.sb14(clr: MyColors.white),
                          )));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EnterNewPinWidget extends StatefulWidget {
  const EnterNewPinWidget({required this.isEnabled, required this.onSuccess});
  final bool isEnabled;
  final Function(String) onSuccess;

  @override
  State<EnterNewPinWidget> createState() => _EnterNewPinWidgetState();
}

class _EnterNewPinWidgetState extends State<EnterNewPinWidget> {
  final newPinController = TextEditingController();
  final _pinFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _pinFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your new PIN.',
            maxLines: 2,
            style: TS.b20(
                clr: widget.isEnabled
                    ? MyColors.greyShade3
                    : MyColors.greyShade1),
          ),
          Container(),
          UIH.vertGapSmall,
          SizedBox(
            height: 35,
            child: TextFormField(
              controller: newPinController,
              validator: (String? val) {
                if (val == null || val.isEmpty || val.length < 4) {
                  return '';
                }
                return null;
              },
              inputFormatters: [OnlyFourDigitNumberInputFormatter()],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter new 4-digit PIN',
                  enabled: widget.isEnabled,
                  hintStyle: const TS.r16(clr: MyColors.greyShade1),
                  errorStyle: const TextStyle(height: 0),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.greyShade1,
                          width: 2,
                          style: BorderStyle.solid)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.greyShade1.withOpacity(0.4),
                          width: 2,
                          style: BorderStyle.solid)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.greyShade1,
                          width: 2,
                          style: BorderStyle.solid)),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.redShade1,
                          width: 2,
                          style: BorderStyle.solid)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.redShade1,
                          width: 2,
                          style: BorderStyle.solid)),
                  contentPadding: const EdgeInsets.only(left: 10)),
            ),
          ),
          UIH.vertGapSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back',
                  style: TS.sb12(clr: MyColors.greyShade2),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: const BorderSide(color: MyColors.greyShade2, width: 2),
                ),
              ),
              UIH.horzGapSmall,
              ElevatedButton(
                onPressed: widget.isEnabled
                    ? () async {
                        if (_pinFormKey.currentState!.validate()) {
                          widget.onSuccess(newPinController.text);
                        }
                      }
                    : null,
                child: const Text(
                  'Set',
                  style: TS.sb12(clr: MyColors.white),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    primary: MyColors.blueShade2),
              ),
            ],
          )
        ],
      ),
    );
  }
}
