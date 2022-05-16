import 'package:account_manager/features/currency_selection/data/currency_data.dart';
import 'package:account_manager/features/prefs/model/config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/style/style.dart';
import '../prefs/cubit/auth_status_cubit.dart';

class CurrencySelectionScreen extends StatefulWidget {
  final bool isPopable;
  const CurrencySelectionScreen({Key? key})
      : isPopable = false,
        super(key: key);
  const CurrencySelectionScreen.pop({Key? key})
      : isPopable = true,
        super(key: key);

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  CurrencyModel? selectedCurrency;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            UIH.vertGapMedium,
            Text(
              'Almost there..',
              style: TS.sb14(clr: MyColors.greyShade2, letterSpace: 0.6),
            ),
            UIH.vertGapSmall,
            Text(
              'Select Currency',
              style: TS.b20(clr: MyColors.greyShade3),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: CurrencyData.jsonList.length,
                itemBuilder: (context, index) {
                  CurrencyModel currency =
                      CurrencyModel.fromJson(CurrencyData.jsonList[index]);
                  return CurrencyListTile(
                    currency: currency,
                    isSelected: selectedCurrency == null
                        ? false
                        : selectedCurrency!.country == currency.country
                            ? true
                            : false,
                    onSelected: (CurrencyModel curr) {
                      setState(() {
                        selectedCurrency = curr;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: UIH()
                .shadowWithRadius(dropShadow: MyColors.greyShade1)
                .copyWith(color: MyColors.blueShade2),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Row(
                children: [
                  if (selectedCurrency != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCurrency!.country!,
                          style: const TS.sb16(clr: MyColors.white),
                        ),
                        Text(
                          selectedCurrency!.currencyCode! +
                              " (${selectedCurrency!.symbol!})",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: MyColors.blueShade1.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  const Spacer(),
                  UIH.horzGapMedium,
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCurrency == null) {
                        Fluttertoast.showToast(msg: 'Please select a currency');
                      } else {
                        context
                            .read<AuthStatusCubit>()
                            .updateAuthStatusModel(currency: selectedCurrency);
                        if (widget.isPopable) Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Done',
                      style: TS.sb12(clr: MyColors.blueShade2),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        primary: MyColors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CurrencyListTile extends StatelessWidget {
  const CurrencyListTile({
    Key? key,
    required this.currency,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);

  final CurrencyModel currency;
  final bool isSelected;
  final Function(CurrencyModel currency) onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelected(currency);
      },
      child: Container(
        color: isSelected ? MyColors.blueShade1 : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: isSelected ? MyColors.blueShade2 : null,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: MyColors.blueShade2),
                ),
                child: isSelected
                    ? Center(
                        child: Text(
                          currency.symbol!,
                          style: TextStyle(
                              color: MyColors.blueShade1.withOpacity(0.5)),
                        ),
                      )
                    : null,
              ),
              UIH.horzGapSmall,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.country!,
                    style: const TS.sb16(),
                  ),
                  Text(
                    currency.currencyCode!,
                    style: const TS.sb14(clr: MyColors.greyShade2),
                  )
                ],
              ),
              const Spacer(),
              Text(
                currency.symbol!,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: MyColors.greyShade1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
