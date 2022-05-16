import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/style/colors.dart';
import '../../../core/style/text_style.dart';
import '../../../core/style/ui_helpers.dart';
import '../../prefs/model/config_model.dart';
import '../../prefs/prefs.dart';

class ChangePinDialog extends StatefulWidget {
  @override
  State<ChangePinDialog> createState() => _AddNewAccountDialogState();
}

class _AddNewAccountDialogState extends State<ChangePinDialog> {
  late final TextEditingController currentPinController;
  late final TextEditingController newPinController;

  @override
  void initState() {
    currentPinController = TextEditingController();
    newPinController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    currentPinController.dispose();
    newPinController.dispose();
    super.dispose();
  }

  ConfigModel configs =
      ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
  @override
  Widget build(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: GestureDetector(
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                color: MyColors.greyShade3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Reset Pin',
                        overflow: TextOverflow.ellipsis,
                        style: TS.sb16(clr: MyColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIH.vertGapMedium,
                  PinField.currentpin(currentPinController),
                  UIH.vertGapSmall,
                  PinField.newpin(newPinController),
                  UIH.vertGapSmall,
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
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
                            if (currentPinController.text.isEmpty) {
                              Fluttertoast.showToast(msg: 'Please enter PIN');
                            } else if (configs.pin ==
                                currentPinController.text) {
                              if (newPinController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Please enter new PIN');
                              } else {
                                ConfigModel newModel = configs.copyWith(
                                    pin: newPinController.text);
                                await Prefs.setString(
                                    'authStatus', jsonEncode(newModel));
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: MyColors.greenShade1,
                                        content: Text('PIN Reset Success !')));
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Invalid Current PIN!');
                            }
                          },
                          child: const Text(
                            'Reset',
                            style: TS.sb12(clr: MyColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              primary: MyColors.greyShade3),
                        ),
                      ],
                    ),
                  ),
                  UIH.vertGapSmall
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum PinFieldType { current, newpin }

class PinField extends StatelessWidget {
  final PinFieldType pinfieldType;
  const PinField.currentpin(this.pinController)
      : pinfieldType = PinFieldType.current;
  const PinField.newpin(this.pinController)
      : pinfieldType = PinFieldType.newpin;

  final TextEditingController pinController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: MyColors.blueShade1, borderRadius: BorderRadius.circular(6)),
        child: TextFormField(
          validator: (String? val) {
            if (val!.isEmpty) {
              return '';
            }
            return null;
          },
          style: const TS.r16(),
          controller: pinController,
          decoration: InputDecoration(
              hintText: pinfieldType == PinFieldType.current
                  ? 'Current Pin'
                  : 'New Pin',
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TS.r16(clr: MyColors.greyShade1),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10, bottom: 12)),
        ),
      ),
    );
  }
}
