import 'package:account_manager/core/widgets/btn.dart';
import 'package:account_manager/features/accounts_screen/cubit/transaction_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../core/style/style.dart';
import '../database/domain/model/transaction_model.dart';

class AddNewTransactionDialog extends StatelessWidget {
  const AddNewTransactionDialog({required this.onSubmit});

  final Function(Transaction trx) onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionTypeCubit(),
      child: AddNewTransactionDialogView(onSubmit: onSubmit),
    );
  }
}

class AddNewTransactionDialogView extends StatefulWidget {
  const AddNewTransactionDialogView({required this.onSubmit});

  final Function(Transaction trx) onSubmit;
  @override
  State<AddNewTransactionDialogView> createState() =>
      _AddNewTransactionDialogViewState();
}

class _AddNewTransactionDialogViewState
    extends State<AddNewTransactionDialogView> {
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();

  final dateController = TextEditingController();
  DateTime date = DateTime.now();

  Future showDate(TextEditingController _controller, BuildContext context,
      TransactionType state) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2021),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: txnColor(state),
            colorScheme: ColorScheme.light(primary: txnColor(state)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        date = pickedDate;
        _controller.text = DateFormat("dd-MM-yyyy").format(pickedDate);
      });
    }
  }

  Color txnColor(TransactionType t) {
    switch (t) {
      case TransactionType.credit:
        return MyColors.bottomShade1;
      case TransactionType.payment:
        return MyColors.redShade1;
      default:
        return MyColors.greyShade1;
    }
  }

  @override
  void initState() {
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

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
        child: BlocBuilder<TransactionTypeCubit, TransactionType>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: txnColor(state),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          'New Transaction',
                          style: TS.sb16(clr: MyColors.white),
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
                      UIH.vertGapSmall,
                      GestureDetector(
                        onTap: () async {
                          await showDate(dateController, context, state);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Container(
                              width: double.infinity,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: MyColors.blueShade1,
                                  borderRadius: BorderRadius.circular(6.0)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Text(DateFormat("dd-MM-yyyy").format(date)),
                                    const Spacer(),
                                    const SizedBox(
                                      height: 25,
                                      child: VerticalDivider(
                                        color: MyColors.blueShade3,
                                        thickness: 1.5,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: MyColors.blueShade3,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      UIH.vertGapSmall,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Btn(
                                    color: state == TransactionType.credit
                                        ? MyColors.bottomShade1
                                        : MyColors.greyShade1,
                                    onPressed: () {
                                      context
                                          .read<TransactionTypeCubit>()
                                          .switchTransactionTypeTo(
                                              TransactionType.credit);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.call_received,
                                          size: 18,
                                        ),
                                        Text('Credit'),
                                      ],
                                    ))),
                            UIH.horzGapSmall,
                            Expanded(
                                child: Btn(
                                    color: state == TransactionType.payment
                                        ? MyColors.redShade1
                                        : MyColors.greyShade1,
                                    onPressed: () {
                                      context
                                          .read<TransactionTypeCubit>()
                                          .switchTransactionTypeTo(
                                              TransactionType.payment);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.call_made,
                                          size: 18,
                                        ),
                                        Text('Payment'),
                                      ],
                                    ))),
                          ],
                        ),
                      ),
                      UIH.vertGapMedium,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextFormField(
                          cursorColor: MyColors.greyShade1,
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          style: TS.sb20(clr: txnColor(state)),
                          controller: _amountController,
                          onChanged: (_) {
                            // setState(() {});
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                          decoration: const InputDecoration(
                              hintText: 'Amount',
                              errorStyle: TextStyle(height: 0),
                              hintStyle: TS.sb20(clr: MyColors.greyShade1),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 8)),
                        ),
                      ),
                      UIH.vertGapSmall,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: txnColor(state).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: TextFormField(
                              cursorColor: MyColors.white,
                              controller: _noteController,
                              style: const TS.sb14(clr: MyColors.white),
                              decoration: const InputDecoration(
                                  hintText: 'Add Note',
                                  hintStyle: TS.sb14(clr: MyColors.white),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    bottom: 20 / 2, // HERE THE IMPORTANT PART
                                  )),
                              // textAlignVertical: TextAlignVertical.center,  THIS DOES NOT WORK

                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      UIH.vertGapMedium,
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
                                if (state == TransactionType.none) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Please select any one transaction type');
                                } else if (_amountController.text.isEmpty) {
                                  Fluttertoast.showToast(msg: 'Enter Amount');
                                } else {
                                  widget.onSubmit(Transaction(
                                    note: _noteController.text.isEmpty
                                        ? null
                                        : _noteController.text,
                                    transactionDate:
                                        date.millisecondsSinceEpoch,
                                    credit: state == TransactionType.credit
                                        ? double.parse(_amountController.text)
                                        : 0,
                                    payment: state == TransactionType.payment
                                        ? double.parse(_amountController.text)
                                        : 0,
                                  ));
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'Save',
                                style: TS.sb12(clr: MyColors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  primary: txnColor(state)),
                            ),
                          ],
                        ),
                      ),
                      UIH.vertGapSmall
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
