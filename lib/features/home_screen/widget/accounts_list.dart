import 'dart:developer';

import 'package:account_manager/configs/ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/style/style.dart';
import '../../accounts_screen/accounts_screen.dart';
import '../../database/database.dart';
import '../../database/domain/model/account_model.dart';
import '../cubit/accounts_cubit.dart';
import '../dialogs/delete_confirmation_dialog.dart';
import '../dialogs/edit_account_dialog.dart';

class AccountsList extends StatefulWidget {
  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  @override
  void initState() {
    context.read<AccountsCubit>().getAccountsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsCubit, List<Account>>(
      builder: (context, state) {
        if (state.isEmpty) {
          return const Center(
            child: Text(
              'No Accounts Added',
              style: TS.sb16(),
            ),
          );
        }
        return ListView.builder(
          itemCount: state.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              child: AccountTile(
                accountData: state[index],
                onDelete: (int accountId) {
                  context.read<AccountsCubit>().deleteAccount(accountId);
                },
                onEdit: (Account acc) async {
                  context.read<AccountsCubit>().editAccount(acc);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AccountTile extends StatefulWidget {
  const AccountTile({
    required this.accountData,
    required this.onDelete,
    required this.onEdit,
  });

  final Account accountData;
  final Function(int accountId) onDelete;
  final Function(Account onEdit) onEdit;

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  @override
  void dispose() {
    _interstitialAd!.dispose();
    super.dispose();
  }

  _moveToAccountsScreen(Account accountData) async {
    UIH().navigate(
        context,
        BlocProvider.value(
          value: BlocProvider.of<AccountsCubit>(context),
          child: AccountScreen(accountData: accountData),
        ));
    _loadInterstitialAd(accountData);
  }

  void _loadInterstitialAd(Account accountData) {
    InterstitialAd.load(
      adUnitId: LiveAdIds().navigationAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
            _moveToAccountsScreen(accountData);
          }, onAdWillDismissFullScreenContent: (InterstitialAd ad) {
            _isInterstitialAdReady = false;
            ad.dispose();
          }, onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
            _isInterstitialAdReady = false;
            ad.dispose();
          }, onAdShowedFullScreenContent: (InterstitialAd ad) {
            _isInterstitialAdReady = false;
          });

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          _isInterstitialAdReady = false;
          log('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd(widget.accountData);
    }
    super.didChangeDependencies();
  }

  @override
  // await TransactionDatabase.init(accountData.id!);
  // UIH().navigate(
  //     context,
  //     BlocProvider.value(
  //       value: BlocProvider.of<AccountsCubit>(context),
  //       child: AccountScreen(accountData: accountData),
  //     ));
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await TransactionDatabase.init(widget.accountData.id!);
        if (_isInterstitialAdReady) {
          _interstitialAd?.show();
        } else {
          _moveToAccountsScreen(widget.accountData);
        }
      },
      child: Slidable(
        startActionPane: ActionPane(
            motion: const ScrollMotion(),
            closeThreshold: 0.1,
            extentRatio: 0.3,
            children: [
              SlidableAction(
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (BuildContext ct) {
                        return EditAccountDialog(
                            accountData: widget.accountData,
                            onSubmit: (Account acc) {
                              widget.onEdit(acc);
                            });
                      });
                },
                backgroundColor: UIH.setColor(widget.accountData.colorId),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                // label: 'Edit',
              ),
              SlidableAction(
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (BuildContext ct) {
                        return DeleteConfirmationDialog(
                            accountData: widget.accountData,
                            onConfirmed: () {
                              widget.onDelete(widget.accountData.id!);
                            });
                      });
                },
                backgroundColor: MyColors.greyShade1.withOpacity(0.4),
                foregroundColor: MyColors.redShade1,

                icon: Icons.delete,

                // label: 'Delete',
              ),
            ]),
        direction: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/bookmark_icon.png',
                color: UIH.colorPallete.firstWhere((element) =>
                    element['id'] == widget.accountData.colorId)['bg'],
                height: 49,
              ),
              UIH.horzGapSmall,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.accountData.accountName,
                            style: const TS.sb16(),
                          ),
                        ),
                        // Spacer(),
                        Text(
                          '${widget.accountData.credit}',
                          style: const TS.r16(clr: MyColors.bottomShade1),
                        ),
                      ],
                    ),
                    UIH.vertGapTiny,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance ${(widget.accountData.credit - widget.accountData.payment).toStringAsFixed(2)}',
                          style: const TS.r16(clr: MyColors.greyShade1),
                        ),
                        Text(
                          '${widget.accountData.payment}',
                          style: const TS.r16(clr: MyColors.redShade1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
