import 'package:account_manager/core/widgets/expanded_section.dart';
import 'package:account_manager/features/accounts_screen/cubit/search_result_cubit.dart';
import 'package:account_manager/features/database/data/transaction_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/style/style.dart';

class SearchExpansion extends StatelessWidget {
  const SearchExpansion({
    required this.accountId,
    required this.isExpanded,
    required this.onCancel,
    required this.onSearch,
  });

  final bool isExpanded;
  final int accountId;
  final VoidCallback onCancel;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return SearchExpansionView(
      accountId: accountId,
      isExpanded: isExpanded,
      onCancel: onCancel,
      onSearch: onSearch,
    );
  }
}

class SearchExpansionView extends StatefulWidget {
  const SearchExpansionView({
    required this.accountId,
    required this.isExpanded,
    required this.onCancel,
    required this.onSearch,
  });

  final bool isExpanded;
  final int accountId;
  final VoidCallback onCancel;
  final VoidCallback onSearch;

  @override
  State<SearchExpansionView> createState() => _SearchExpansionViewState();
}

class _SearchExpansionViewState extends State<SearchExpansionView> {
  int dateFrom = DateTime.now().millisecondsSinceEpoch;
  int dateTo = DateTime.now().millisecondsSinceEpoch;
  final dateFromController = TextEditingController();
  final dateToController = TextEditingController();
  final noteController = TextEditingController();
  final amountController = TextEditingController();

  final trxDataSource = TransactionDataSource();

  DateTime date = DateTime.now();
  Future<DateTime> showDate(
      TextEditingController _controller, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2021),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyColors.blueShade2,
            colorScheme: const ColorScheme.light(primary: MyColors.blueShade2),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        DateTime.now().millisecondsSinceEpoch;
        date = pickedDate;
        _controller.text = DateFormat("dd-MM-yyyy").format(pickedDate);
      });
    }
    return date;
  }

  @override
  void dispose() {
    dateFromController.dispose();
    dateToController.dispose();
    noteController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!widget.isExpanded) {
      context.read<SearchResultCubit>().clearSearchResults();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
    return ExpandedSection(
      expand: widget.isExpanded,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Note',
                        style:
                            TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
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
                          controller: noteController,
                          decoration: const InputDecoration(
                              hintText: 'Search by Note',
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
                    ],
                  ),
                ),
                UIH.horzGapTiny,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Amount',
                        style:
                            TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
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
                          controller: amountController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Amount',
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
                    ],
                  ),
                ),
              ],
            ),
            UIH.vertGapSmall,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date From',
                        style:
                            TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
                      ),
                      UIH.vertGapTiny,
                      GestureDetector(
                        onTap: () async {
                          DateTime d = await showDate(
                            dateFromController,
                            context,
                          );
                          setState(() {
                            dateFrom = d.millisecondsSinceEpoch;
                          });
                        },
                        child: Container(
                            width: double.infinity,
                            height: 35,
                            decoration: BoxDecoration(
                                color: MyColors.blueShade1,
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Row(
                              children: [
                                UIH.horzGapTiny,
                                Text(dateFromController.text),
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
                                UIH.horzGapTiny,
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                UIH.horzGapTiny,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date To',
                        style:
                            TS.sb12(clr: MyColors.greyShade2, letterSpace: 0.6),
                      ),
                      UIH.vertGapTiny,
                      GestureDetector(
                        onTap: () async {
                          DateTime d = await showDate(
                            dateToController,
                            context,
                          );

                          setState(() {
                            dateTo = d.millisecondsSinceEpoch;
                          });
                        },
                        child: Container(
                            width: double.infinity,
                            height: 35,
                            decoration: BoxDecoration(
                                color: dateFromController.text.isEmpty
                                    ? MyColors.blueShade1
                                    : MyColors.redShade1.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Row(
                              children: [
                                UIH.horzGapTiny,
                                Text(dateToController.text),
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
                                UIH.horzGapTiny,
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            UIH.vertGapSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    noteController.clear();
                    amountController.clear();
                    dateFrom = 0;
                    dateTo = 0;
                    dateFromController.clear();
                    dateToController.clear();
                    widget.onCancel();
                    context.read<SearchResultCubit>().clearSearchResults();
                  },
                  child: const Text(
                    'Cancel',
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
                UIH.horzGapTiny,
                ElevatedButton(
                  onPressed: () async {
                    if (dateFromController.text.isNotEmpty &&
                        dateToController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: MyColors.redShade1,
                          content: Text('Please Enter Date To')));
                    } else {
                      context.read<SearchResultCubit>().showSearchResults(
                              await trxDataSource.searchTransaction(
                            accountId: widget.accountId,
                            note: noteController.text.isEmpty
                                ? null
                                : noteController.text,
                            amount: amountController.text.isEmpty
                                ? null
                                : double.parse(amountController.text),
                            dateFrom: dateFromController.text.isEmpty
                                ? null
                                : dateFrom,
                            dateTo:
                                dateFromController.text.isEmpty ? null : dateTo,
                          ));
                    }
                  },
                  child: const Text(
                    'Search',
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
          ],
        ),
      ),
    );
  }
}
