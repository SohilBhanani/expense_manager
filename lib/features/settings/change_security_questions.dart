import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/constants/strings.dart';
import '../../core/style/style.dart';
import '../prefs/model/config_model.dart';
import '../prefs/prefs.dart';

class ChangeSecurityQuestionsScreen extends StatefulWidget {
  const ChangeSecurityQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<ChangeSecurityQuestionsScreen> createState() =>
      _ChangeSecurityQuestionsScreenState();
}

class _ChangeSecurityQuestionsScreenState
    extends State<ChangeSecurityQuestionsScreen> {
  String selectedQuestionOne = '';

  String selectedQuestionTwo = '';

  final answerOneController = TextEditingController();
  final answerTwoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    answerOneController.dispose();
    answerTwoController.dispose();
    super.dispose();
  }

  ConfigModel configs = ConfigModel.fromJson(
    jsonDecode(Prefs.getString('authStatus')!),
  );
  @override
  Widget build(BuildContext context) {
    List<String> secureList1 = [
      SecurityQuestions.securityQuestionOne,
      SecurityQuestions.securityQuestionTwo,
      SecurityQuestions.securityQuestionThree,
      SecurityQuestions.securityQuestionFour,
      SecurityQuestions.securityQuestionFive,
    ];
    List<String> secureList2 = [
      SecurityQuestions.securityQuestionSix,
      SecurityQuestions.securityQuestionSeven,
      SecurityQuestions.securityQuestionEight,
      SecurityQuestions.securityQuestionNine,
      SecurityQuestions.securityQuestionTen,
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text(
          'Reset Security Questions',
          style: TS.b20(clr: MyColors.greyShade3),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security Question 1',
                style: TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
              ),
              UIH.vertGapTiny,
              Container(
                width: double.infinity,
                height: 37,
                decoration: BoxDecoration(
                    color: MyColors.blueShade1,
                    borderRadius: BorderRadius.circular(6.0)),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  hint: const Text(
                    "Select a question",
                    style: TS.r14(clr: MyColors.greyShade2),
                  ),
                  isDense: true,
                  icon: Row(
                    children: const [
                      SizedBox(
                        child: VerticalDivider(
                          color: MyColors.greyShade1,
                          thickness: 2,
                        ),
                      ),
                      Icon(Icons.key),
                    ],
                  ),
                  onChanged: (String? v) {
                    setState(() {
                      selectedQuestionOne = v!;
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 10, bottom: 14, right: 8)),
                  items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                            child: Text(
                              secureList1[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TS.r14(),
                            ),
                            value: secureList1[index],
                          )),
                ),
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
                  controller: answerOneController,
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return '';
                    }
                    return null;
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
              const Text(
                'Security Question 2',
                style: TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
              ),
              UIH.vertGapTiny,
              Container(
                width: double.infinity,
                height: 37,
                decoration: BoxDecoration(
                    color: MyColors.blueShade1,
                    borderRadius: BorderRadius.circular(6.0)),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  hint: const Text(
                    "Select a question",
                    style: TS.r14(clr: MyColors.greyShade2),
                  ),
                  isDense: true,
                  icon: Row(
                    children: const [
                      SizedBox(
                        child: VerticalDivider(
                          color: MyColors.greyShade1,
                          thickness: 2,
                        ),
                      ),
                      Icon(Icons.key),
                    ],
                  ),
                  onChanged: (String? v) {
                    setState(() {
                      selectedQuestionTwo = v!;
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 10, bottom: 12, right: 8)),
                  items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                            onTap: () {},
                            child: Text(
                              secureList2[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TS.r14(),
                            ),
                            value: secureList2[index],
                          )),
                ),
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
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  controller: answerTwoController,
                  decoration: const InputDecoration(
                      hintText: 'Type here..',
                      errorStyle: TextStyle(height: 0),
                      hintStyle: TS.r16(clr: MyColors.greyShade1),
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
                      side: const BorderSide(
                          color: MyColors.greyShade2, width: 2),
                    ),
                  ),
                  UIH.horzGapMedium,
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          (selectedQuestionOne.isNotEmpty &&
                              selectedQuestionTwo.isNotEmpty)) {
                        ConfigModel updatedConfigs = configs.copyWith(
                            securityQuestionOne: selectedQuestionOne,
                            securityQuestionTwo: selectedQuestionTwo,
                            securityAnswerOne: answerOneController.text,
                            securityAnswerTwo: answerTwoController.text);

                        await Prefs.setString(
                            'authStatus', jsonEncode(updatedConfigs));

                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Updated Security Questions');
                      } else {
                        Fluttertoast.showToast(msg: 'Please set questions');
                      }
                    },
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
        ),
      ),
    );
  }
}
