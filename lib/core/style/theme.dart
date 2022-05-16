import 'package:flutter/material.dart';

import 'colors.dart';

const Color _whiteColor = MyColors.white;

// //! Values
const double _appBarElevation = 0.0;

ThemeData appTheme() => ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // primaryColor: _primaryColor,
    canvasColor: MyColors.white,

    //* APP BAR THEME
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: _whiteColor),
      backgroundColor: MyColors.white,
      actionsIconTheme: IconThemeData(color: _whiteColor),
      elevation: _appBarElevation,
      iconTheme: IconThemeData(color: MyColors.greyShade3),
    ),
    scaffoldBackgroundColor: MyColors.white);
