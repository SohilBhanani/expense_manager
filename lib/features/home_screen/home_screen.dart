import 'dart:developer';

import 'package:account_manager/configs/ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/style/style.dart';
import '../database/data/account_datasource.dart';
import '../pdf/bloc/pdf_bloc.dart';
import 'cubit/accounts_cubit.dart';
import 'widget/accounts_list.dart';
import 'widget/add_account_header.dart';
import 'widget/expansion_drawer.dart';
import 'widget/net_calculation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountsCubit(),
        ),
        BlocProvider(
          create: (context) => PdfBloc(),
        ),
      ],
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final accountData = AccountDataSource();
  bool isDrawerExpanded = false;
  late final ScrollController _scrollController;
  BannerAd? homeScreenBanner;

  _scrollListener() {
    if (_scrollController.offset >= 30) {
      if (isDrawerExpanded) {
        setState(() {
          isDrawerExpanded = false;
        });
      }
    }
    if (_scrollController.offset <= -100) {
      if (!isDrawerExpanded) {
        setState(() {
          isDrawerExpanded = true;
        });
      }
    }
  }

  @override
  void initState() {
    homeScreenBanner = BannerAd(
      adUnitId: LiveAdIds().homeScreenBannerId,
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
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    homeScreenBanner?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    homeScreenBanner!.load();
    super.didChangeDependencies();
  }

  bool _isBannerAdReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              setState(() {
                isDrawerExpanded = !isDrawerExpanded;
              });
            },
            icon: const Icon(Icons.sort),
          ),
          title: Image.asset(
            'assets/expensu_logo.png',
            height: 45,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                        [ExpansionDrawer(isExpanded: isDrawerExpanded)]),
                  ),
                  SliverList(
                      delegate:
                          SliverChildListDelegate([const NetCalculations()])),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: AddAccountHeader(
                        onSubmit: (account) async {
                          await accountData
                              .insertAccount(account)
                              .then((value) {
                            context.read<AccountsCubit>().getAccountsList();
                          });
                        },
                      )),
                  SliverList(
                      delegate: SliverChildListDelegate([AccountsList()])),
                ],
              ),
            ),
            if (_isBannerAdReady)
              SizedBox(
                  height: 50,
                  child: AdWidget(
                    ad: homeScreenBanner!,
                  ))
          ],
        ));
  }
}
