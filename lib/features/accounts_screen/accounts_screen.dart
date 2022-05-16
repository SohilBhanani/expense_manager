import 'dart:convert';
import 'dart:developer';

import 'package:account_manager/configs/ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import '../../core/style/style.dart';
import '../../core/widgets/expanded_section.dart';
import '../database/data/total_transaction_cubit.dart';
import '../database/data/transaction_datasource.dart';
import '../database/domain/model/account_model.dart';
import '../database/domain/model/transaction_model.dart';
import '../home_screen/cubit/accounts_cubit.dart';
import '../prefs/model/config_model.dart';
import '../prefs/prefs.dart';
import 'account_screen_expansion_drawer.dart';
import 'add_new_transaction_dialog.dart';
import 'cubit/drawer_and_search_expansion_cubit.dart';
import 'cubit/search_result_cubit.dart';
import 'edit_transation_dialog.dart';
import 'search_expansion.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({required this.accountData});
  final Account accountData;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TotalTransactionCubit(),
        ),
        BlocProvider(
          create: (context) => SearchResultCubit(),
        ),
        BlocProvider(
          create: (context) => DrawerAndSearchExpansionCubit(),
        ),
      ],
      child: AccountScreenView(
        accountData: accountData,
      ),
    );
  }
}

class AccountScreenView extends StatefulWidget {
  const AccountScreenView({required this.accountData});

  final Account accountData;

  @override
  State<AccountScreenView> createState() => _AccountScreenViewState();
}

class _AccountScreenViewState extends State<AccountScreenView> {
  late final ScrollController _scrollController;
  BannerAd? accountScreenBanner;
  bool _isBannerAdReady = false;
  _scrollListener() {
    if (_scrollController.offset >= 30) {
      if (context.read<DrawerAndSearchExpansionCubit>().state is DrawerOpen) {
        context
            .read<DrawerAndSearchExpansionCubit>()
            .toggleDrawer(toggle: false);
      }
    }
    if (_scrollController.offset <= -100) {
      if (context.read<DrawerAndSearchExpansionCubit>().state is DrawerClose ||
          context.read<DrawerAndSearchExpansionCubit>().state
              is DrawerAndSearchClosed) {
        context
            .read<DrawerAndSearchExpansionCubit>()
            .toggleDrawer(toggle: true);
      }
    }
  }

  @override
  initState() {
    context.read<TotalTransactionCubit>().getSumTrx(widget.accountData);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // Ads.accountsScreenBanner.load();
    accountScreenBanner = BannerAd(
      adUnitId: LiveAdIds().accountsScreenBannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          log('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    accountScreenBanner!.load();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    accountScreenBanner!.dispose();
    super.dispose();
  }

  final ConfigModel configs =
      ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
  @override
  Widget build(BuildContext context) {
    final transactionDataSource = TransactionDataSource();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<DrawerAndSearchExpansionCubit>().toggleDrawer();
            },
            icon: const Icon(
              Icons.sort,
              color: MyColors.greyShade3,
            ),
          ),
          IconButton(
              onPressed: () async {
                List<Transaction> t = await transactionDataSource.getAllTxnOf(
                    widget.accountData.id!,
                    configs.settings!.sorting == Sorting.chronological.name);
                if (t.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('No transaction history found !')));
                } else {
                  context.read<DrawerAndSearchExpansionCubit>().toggleSearch();
                }
              },
              icon: const Icon(
                Icons.search,
                color: MyColors.greyShade3,
              )),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext ctx) =>
                        AddNewTransactionDialog(onSubmit: (Transaction txn) {
                          transactionDataSource
                              .insertTxn(txn, widget.accountData.id!)
                              .then((value) {
                            context
                                .read<TotalTransactionCubit>()
                                .getSumTrx(widget.accountData);
                            setState(() {});
                          });
                        }));
              },
              icon: const Icon(
                Icons.add,
                color: MyColors.greyShade3,
              ))
        ],
        title: Text(
          widget.accountData.accountName,
          maxLines: 2,
          style: const TS.sb16(),
        ),
      ),
      body: Column(
        children: [
          AccountScreenExpansionDrawer(
            isExpanded: context.watch<DrawerAndSearchExpansionCubit>().state
                is DrawerOpen,
            accountData: widget.accountData,
          ),
          SearchExpansion(
            accountId: widget.accountData.id!,
            isExpanded: context.watch<DrawerAndSearchExpansionCubit>().state
                is SearchOpen,
            onCancel: () {
              context
                  .read<DrawerAndSearchExpansionCubit>()
                  .toggleSearch(toggle: false);
            },
            onSearch: () {},
          ),
          BlocBuilder<TotalTransactionCubit, SumTrx>(
            buildWhen: (previous, current) {
              return previous != current;
            },
            builder: (context, state) {
              context.read<AccountsCubit>().getAccountsList();
              return AmountStatus(
                credit: state.credit,
                payment: state.payment,
                balance: state.credit - state.payment,
              );
            },
          ),
          UIH.vertGapSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: const [
                Expanded(child: Text('Date', style: TS.sb16())),
                Expanded(
                    flex: 2,
                    child: Center(child: Text('Note', style: TS.sb16()))),
                Icon(
                  Icons.call_received,
                  size: 16,
                  color: MyColors.bottomShade1,
                ),
                Text('Credit', style: TS.sb16()),
                UIH.horzGapTiny,
                Icon(
                  Icons.call_made,
                  size: 16,
                  color: MyColors.redShade1,
                ),
                Text(
                  'Payment',
                  style: TS.sb16(),
                ),
              ],
            ),
          ),
          UIH.vertGapSmall,
          BlocBuilder<SearchResultCubit, List<Transaction>>(
            builder: (context, searchResultState) {
              if (searchResultState.isEmpty) {
                return Expanded(
                  child: FutureBuilder<List<Transaction>>(
                      future: transactionDataSource.getAllTxnOf(
                          widget.accountData.id!,
                          configs.settings!.sorting ==
                              Sorting.chronological.name),
                      builder: (context, listOfTrx) {
                        if (listOfTrx.hasData) {
                          List<Transaction> trxList = listOfTrx.data!;
                          if (trxList.isEmpty) {
                            return const Center(
                                child: Text(
                              'No transactions added so far.',
                              style: TS.sb16(),
                            ));
                          }
                          return Scrollbar(
                            controller: _scrollController,
                            interactive: true,
                            radius: const Radius.circular(2),
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemCount: trxList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: index.isEven
                                      ? MyColors.greyShade1.withOpacity(0.2)
                                      : MyColors.greyShade2.withOpacity(0.2),
                                  child: trxList[index].credit == 0
                                      ? AccTableRow.payment(
                                          transaction: trxList[index],
                                          accountData: widget.accountData,
                                          onRefresh: () {
                                            setState(() {});
                                          },
                                        )
                                      : AccTableRow.credit(
                                          transaction: trxList[index],
                                          accountData: widget.accountData,
                                          onRefresh: () {
                                            setState(() {});
                                          },
                                        ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                );
              } else {
                return Expanded(
                  child: Scrollbar(
                    interactive: true,
                    radius: const Radius.circular(2),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: searchResultState.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: index.isEven
                              ? MyColors.greyShade1.withOpacity(0.2)
                              : MyColors.greyShade2.withOpacity(0.2),
                          child: searchResultState[index].credit == 0
                              ? AccTableRow.payment(
                                  transaction: searchResultState[index],
                                  accountData: widget.accountData,
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  enabled: false,
                                )
                              : AccTableRow.credit(
                                  transaction: searchResultState[index],
                                  accountData: widget.accountData,
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  enabled: false,
                                ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
          BlocBuilder<TotalTransactionCubit, SumTrx>(
            builder: (context, state) {
              return ExpandedSection(
                // expand: !isSearchExpanded,
                expand: context.watch<DrawerAndSearchExpansionCubit>().state
                    is! SearchOpen,
                child: Column(
                  children: [
                    SizedBox(
                      height: 65,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: MyColors.bottomShade1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Visibility(
                                        visible: false,
                                        maintainAnimation: true,
                                        maintainSize: true,
                                        maintainState: true,
                                        child: Icon(
                                          Icons.call_received,
                                          size: 18,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Text(
                                        'Credit',
                                        style: TS.r14(clr: MyColors.white),
                                      ),
                                      Text(
                                        ' (${configs.currency!.symbol!})',
                                        style: const TextStyle(
                                            color: MyColors.white),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.call_received,
                                        size: 18,
                                        color: MyColors.white,
                                      )
                                    ],
                                  ),
                                  UIH.vertGapTiny,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      '${state.credit}',
                                      style: const TS.sb14(clr: MyColors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: MyColors.redShade1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Visibility(
                                        visible: false,
                                        maintainAnimation: true,
                                        maintainSize: true,
                                        maintainState: true,
                                        child: Icon(
                                          Icons.call_made,
                                          size: 18,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Text(
                                        'Payment',
                                        style: TS.r14(clr: MyColors.white),
                                      ),
                                      Text(
                                        ' (${configs.currency!.symbol!})',
                                        style: const TextStyle(
                                            color: MyColors.white),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.call_made,
                                        size: 18,
                                        color: MyColors.white,
                                      )
                                    ],
                                  ),
                                  UIH.vertGapTiny,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      '${state.payment}',
                                      style: const TS.sb14(clr: MyColors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: MyColors.greyShade3,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Balance',
                                        style: TS.r14(clr: MyColors.white),
                                      ),
                                      Text(
                                        ' (${configs.currency!.symbol!})',
                                        style: const TextStyle(
                                            color: MyColors.white),
                                      ),
                                    ],
                                  ),
                                  UIH.vertGapTiny,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      (state.credit - state.payment)
                                          .toStringAsFixed(2),
                                      style: const TS.sb14(clr: MyColors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isBannerAdReady)
                      SizedBox(
                        height: 50,
                        child: AdWidget(ad: accountScreenBanner!),
                      )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class AmountStatus extends StatelessWidget {
  const AmountStatus({
    required this.credit,
    required this.payment,
    required this.balance,
  });
  final double credit;
  final double payment;
  final double balance;

  calculateFlex(double credit, double payment, double balance) {
    late double percOfpay;
    late double percOfbal;
    if (balance <= 0) {
      return [1, 0];
    } else if (payment == 0) {
      percOfpay = 0;
    } else {
      percOfpay = payment / credit * 100;
    }

    if (balance <= 0) {
      return [0, 0];
    } else if (credit == 0) {
      percOfbal = 0;
    } else {
      percOfbal = balance / credit * 100;
    }

    return [percOfpay.ceil().toInt(), percOfbal.ceil().toInt()];
  }

  @override
  Widget build(BuildContext context) {
    List<int> flexes = calculateFlex(credit, payment, balance);
    return Row(
      children: [
        Expanded(
          flex: flexes[0],
          child: Container(
            height: 4,
            decoration: BoxDecoration(
                color: MyColors.redShade1,
                borderRadius: BorderRadius.circular(2)),
          ),
        ),
        UIH.horzGapTiny,
        Expanded(
          flex: flexes[1],
          child: Container(
            height: 4,
            decoration: BoxDecoration(
                color: MyColors.bottomShade1,
                borderRadius: BorderRadius.circular(2)),
          ),
        )
      ],
    );
  }
}

class AccTableRow extends StatelessWidget {
  final Color typeColor;
  const AccTableRow.credit({
    required this.transaction,
    required this.accountData,
    required this.onRefresh,
    this.enabled = true,
  }) : typeColor = MyColors.bottomShade1;
  const AccTableRow.payment({
    required this.transaction,
    required this.accountData,
    required this.onRefresh,
    this.enabled = true,
  }) : typeColor = MyColors.redShade1;

  final Transaction transaction;
  final Account accountData;
  final VoidCallback onRefresh;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Size size = UIH().screenSize(context);
    final transactionDataSource = TransactionDataSource();
    return InkWell(
      onLongPress: enabled
          ? () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return EditTransactionDialog(
                      onSubmit: (trx) {
                        log('message');
                        transactionDataSource
                            .updateTxn(trx, accountData.id!)
                            .then((value) {
                          context
                              .read<TotalTransactionCubit>()
                              .getSumTrx(accountData);
                          onRefresh();
                        });
                      },
                      transaction: transaction,
                      onDelete: (trx) {
                        transactionDataSource
                            .deleteTxn(trx.id!, accountData.id!)
                            .then((value) {
                          context
                              .read<TotalTransactionCubit>()
                              .getSumTrx(accountData);
                          onRefresh();
                        });
                      },
                    );
                  });
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                DateFormat("dd-MM-yyyy").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        transaction.transactionDate)),
                style: TS.sb14(clr: typeColor),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                transaction.note ?? '--',
                style: TS.sb14(clr: typeColor),
                textAlign: TextAlign.center,
              ),
            ),
            UIH.horzGapTiny,
            Expanded(
              child: Center(
                  child: Text(
                '${transaction.credit}',
                style: TS.sb14(clr: typeColor),
              )),
            ),
            Expanded(
              child: Center(
                  child: Text(
                '${transaction.payment}',
                style: TS.sb14(clr: typeColor),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
