import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/constants/strings.dart';
import '../../core/style/style.dart';
import '../auth/bloc/auth_bloc.dart';
import '../prefs/cubit/auth_status_cubit.dart';

class SecurityQuestionScreen extends StatefulWidget {
  final VoidCallback onBack;
  final TextEditingController pinController;

  const SecurityQuestionScreen(
      {required this.onBack, required this.pinController});

  @override
  State<SecurityQuestionScreen> createState() => _SecurityQuestionScreenState();
}

class _SecurityQuestionScreenState extends State<SecurityQuestionScreen> {
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

    return Form(
      key: _formKey,
      child: Padding(
        padding: UIH().sEdgeHorz(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Must haves for PIN retrieval !',
              style: TS.b20(clr: MyColors.greyShade3),
            ),
            UIH.vertGapSmall,
            const Text(
              'Please answer the security questions.',
              style: TS.sb14(clr: MyColors.greyShade2, letterSpace: 0.6),
            ),
            UIH.vertGapMedium,
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
                    contentPadding: EdgeInsets.only(left: 10)),
              ),
            ),
            UIH.vertGapSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    widget.onBack();
                  },
                  child: const Text(
                    'Back',
                    style: TS.sb12(clr: MyColors.greyShade2),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    side:
                        const BorderSide(color: MyColors.greyShade2, width: 2),
                  ),
                ),
                UIH.horzGapMedium,
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      context.read<AuthStatusCubit>().updateAuthStatusModel(
                            pin: state.pin,
                            securityQuestionOne: state.securityQuestionOne,
                            securityAnswerOne: state.answerOne,
                            securityQuestionTwo: state.securityQuestionTwo,
                            securityAnswerTwo: state.answerTwo,
                          );
                      // UIH().replace(context, const CurrencySelectionScreen());
                    }
                    if (state is AuthLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please Wait...')));
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          (selectedQuestionOne.isNotEmpty &&
                              selectedQuestionTwo.isNotEmpty)) {
                        context.read<AuthBloc>().add(AuthSignUp(
                              pin: widget.pinController.text,
                              securityQuestionOne: selectedQuestionOne,
                              answerOne: answerOneController.text,
                              securityQuestionTwo: selectedQuestionTwo,
                              answerTwo: answerTwoController.text,
                            ));
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
