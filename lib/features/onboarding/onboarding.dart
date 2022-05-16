import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../core/style/style.dart';
import '../keypad/keypad.dart';
import 'security_question_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final pinController = TextEditingController();
  final _pageController = PageController();
  bool isNotVisible = true;

  @override
  void dispose() {
    pinController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 90,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                UIH.vertGapMedium,
                Text(
                  'Welcome !',
                  style: TS.sb14(clr: MyColors.greyShade2, letterSpace: 0.6),
                ),
                UIH.vertGapSmall,
                Text(
                  'Set your PIN',
                  style: TS.b20(clr: MyColors.greyShade3),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: UIH().screenSize(context).height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIH.vertGapMedium,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Pinput(
                        controller: pinController,
                        keyboardType: TextInputType.number,
                        useNativeKeyboard: false,
                        obscureText: isNotVisible,
                        obscuringCharacter: '●',
                      ),
                      UIH.vertGapTiny,
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isNotVisible = !isNotVisible;
                          });
                        },
                        child: Text(
                          isNotVisible ? "Show" : "Hide",
                          style: const TS.r14(clr: MyColors.greyShade2),
                        ),
                      ),
                    ],
                  ),
                  UIH.vertGapMedium,
                  UIH.vertGapSmall,
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          KeyPad(
                            controller: pinController,
                            onDone: () {
                              setState(() {
                                // _hasEnteredPin = true;
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              });
                            },
                          ),
                          SecurityQuestionScreen(
                            pinController: pinController,
                            onBack: () {
                              setState(() {
                                // _hasEnteredPin = false;
                                _pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

          // body:
          ),
    );
  }
}
