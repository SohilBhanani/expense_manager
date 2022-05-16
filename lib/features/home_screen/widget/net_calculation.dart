import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/style/style.dart';
import '../../database/domain/model/account_model.dart';
import '../cubit/accounts_cubit.dart';

class NetCalculations extends StatelessWidget {
  const NetCalculations({
    Key? key,
  }) : super(key: key);
  double creditSum(List<Account> acc) {
    double totalCredit = 0;
    for (Account account in acc) {
      totalCredit += account.credit;
    }
    return totalCredit;
  }

  double paymentSum(List<Account> acc) {
    double totalPayment = 0;
    for (Account account in acc) {
      totalPayment += account.payment;
    }
    return totalPayment;
  }

  @override
  Widget build(BuildContext context) {
    // final ConfigModel configs =
    //     ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
    return BlocBuilder<AccountsCubit, List<Account>>(
      builder: (context, state) {
        double csum = creditSum(state);
        double psum = paymentSum(state);
        double balance = csum - psum;
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            decoration: UIH()
                .shadowWithRadius(radius: 6, dropShadow: MyColors.greyShade1)
                .copyWith(color: MyColors.greyShade3),
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Credit',
                      style: TS.r16(clr: MyColors.white),
                    ),
                    const Spacer(),
                    Text(
                      csum.toStringAsFixed(2),
                      style: const TS.sb16(clr: MyColors.bottomShade2),
                    ),
                    // UIH.horzGapSmall,
                    // Text(
                    //   configs.currency!.symbol!,
                    //   style: const TS.sb18(clr: MyColors.bottomShade2),
                    // )
                  ],
                ),
                UIH.vertGapTiny,
                Row(
                  children: [
                    const Text(
                      'Payment',
                      style: TS.r16(clr: MyColors.white),
                    ),
                    const Spacer(),
                    Text(
                      psum.toStringAsFixed(2),
                      style: const TS.sb16(clr: MyColors.redShade1),
                    ),
                    // UIH.horzGapSmall,
                    // Text(
                    //   configs.currency!.symbol!,
                    //   style: const TS.sb18(clr: MyColors.redShade1),
                    // )
                  ],
                ),
                UIH.vertGapTiny,
                Row(
                  children: [
                    const Text(
                      'Balance',
                      style: TS.r16(clr: MyColors.white),
                    ),
                    const Spacer(),
                    Text(
                      balance.toStringAsFixed(2),
                      style: const TS.r16(clr: MyColors.white),
                    ),
                    // UIH.horzGapSmall,
                    // Text(
                    //   configs.currency!.symbol!,
                    //   style: const TS.sb18(clr: MyColors.white),
                    // )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
