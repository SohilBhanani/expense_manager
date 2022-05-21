import 'dart:convert';
import 'dart:developer';

import 'package:account_manager/features/pdf/bloc/pdf_bloc.dart';
import 'package:account_manager/features/prefs/cubit/auth_status_cubit.dart';
import 'package:flutter/material.dart';

import 'core/style/style.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/currency_selection/currency_selection.dart';
import 'features/pin_screen/pin_screen.dart';
import 'features/prefs/model/config_model.dart';
import 'features/prefs/prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/onboarding/onboarding.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(Prefs.getString('authStatus').toString());
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthStatusCubit(
              Prefs.getString('authStatus') == null
                  ? ConfigModel()
                  : ConfigModel.fromJson(
                      jsonDecode(Prefs.getString('authStatus')!))),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => PdfBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        builder: (context, child) {
          // final mediaQueryData = MediaQuery.of(context);
          // final scale = MediaQuery.of(context).textScaleFactor > 1.0
          //     ? mediaQueryData.textScaleFactor.clamp(0.8, 0.8)
          //     : mediaQueryData.textScaleFactor.clamp(0.8, 1.0);
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        home: BlocBuilder<AuthStatusCubit, ConfigModel>(
          builder: (context, state) {
            if (state.pin == null) {
              return UIH().blocNavigator(child: const Onboarding());
            } else if (state.currency == null) {
              return UIH()
                  .blocNavigator(child: const CurrencySelectionScreen());
            } else {
              return UIH().blocNavigator(child: const PinScreen());
            }
          },
        ),
      ),
    );
  }
}
