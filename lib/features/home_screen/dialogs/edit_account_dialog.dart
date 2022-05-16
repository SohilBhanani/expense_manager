import 'package:flutter/material.dart';

import '../../../core/style/style.dart';
import '../../database/domain/model/account_model.dart';

class EditAccountDialog extends StatefulWidget {
  const EditAccountDialog({required this.onSubmit, required this.accountData});
  final Function(Account account) onSubmit;
  final Account accountData;

  @override
  State<EditAccountDialog> createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends State<EditAccountDialog> {
  late Color _selectedColor;
  late int _selectedColorId;
  late final TextEditingController accountNameController;

  @override
  void initState() {
    accountNameController =
        TextEditingController(text: widget.accountData.accountName);
    _selectedColorId = widget.accountData.colorId;
    _selectedColor = UIH.colorPallete
        .firstWhere((element) => element['id'] == _selectedColorId)['bg'];

    super.initState();
  }

  @override
  void dispose() {
    accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    Size size = MediaQuery.of(context).size;
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
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        accountNameController.text.isEmpty
                            ? 'New Account'
                            : accountNameController.text,
                        overflow: TextOverflow.ellipsis,
                        style: const TS.sb16(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: UIH.colorPallete
                          .map((color) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = color['bg'];
                                    _selectedColorId = color['id'];
                                  });
                                },
                                child: Container(
                                  height: size.width * 0.08,
                                  width: size.width * 0.08,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: color['border'], width: 2),
                                    color: color['bg'],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  UIH.vertGapMedium,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: MyColors.blueShade1,
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        style: const TS.r16(),
                        controller: accountNameController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                            hintText: 'Type here..',
                            errorStyle: TextStyle(height: 0),
                            hintStyle: TS.r16(clr: MyColors.greyShade1),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 8)),
                      ),
                    ),
                  ),
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
                          onPressed: () {
                            widget.onSubmit(
                              Account(
                                  id: widget.accountData.id,
                                  accountName: accountNameController.text,
                                  colorId: _selectedColorId,
                                  // balance: '--',
                                  credit: widget.accountData.credit,
                                  payment: widget.accountData.payment),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Save',
                            style: TS.sb12(clr: MyColors.greyShade3),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              primary: _selectedColor),
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
