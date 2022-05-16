import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../core/style/style.dart';
import '../home_screen/home_screen.dart';
import '../keypad/keypad.dart';
import '../prefs/model/config_model.dart';
import '../prefs/prefs.dart';
import 'forget_pin_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final pinController = TextEditingController();
  bool isNotVisible = true;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigModel authStatus =
        ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            UIH.vertGapMedium,
            Text(
              'Hi !',
              style: TS.sb14(clr: MyColors.greyShade2, letterSpace: 0.6),
            ),
            UIH.vertGapSmall,
            Text(
              'Please enter your PIN',
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
              UIH.vertGapMedium,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: UIH().screenSize(context).width * 0.20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              UIH().navigate(context, const ForgetPinScreen());
                            },
                            child: Text(
                              "Forget PIN ?",
                              style: const TS.r14(clr: MyColors.greyShade2)
                                  .apply(decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
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
                  ),
                ],
              ),
              UIH.vertGapMedium,
              UIH.vertGapSmall,
              Expanded(
                child: KeyPad(
                  controller: pinController,
                  onDone: () {
                    if (pinController.text == authStatus.pin) {
                      UIH().replace(context, const HomeScreen());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: MyColors.redShade1,
                          content: Text(
                            "Invalid PIN !",
                            style: TS.sb14(clr: MyColors.white),
                          )));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
