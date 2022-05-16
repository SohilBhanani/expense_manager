import 'package:account_manager/core/style/colors.dart';
import 'package:flutter/material.dart';

class UIH {
  //! UI Spaces
  static const double _tinySpace = 5.0;
  static const double _smallSpace = 10.0;
  static const double _mediumSpace = 25.0;

//* Horizontal Space
  static const Widget horzGapTiny = SizedBox(width: _tinySpace);
  static const Widget horzGapSmall = SizedBox(width: _smallSpace);
  static const Widget horzGapMedium = SizedBox(width: _mediumSpace);

//Variable Horizontal Space
  Widget horzGap(double width) => SizedBox(width: width);

//* Vertical Space
  static const Widget vertGapTiny = SizedBox(height: _tinySpace);
  static const Widget vertGapSmall = SizedBox(height: _smallSpace);
  static const Widget vertGapMedium = SizedBox(height: _mediumSpace);

//Variable Vertical Space
  Widget vertGap(double height) => SizedBox(height: height);

//! EdgeInsets Symmetric
  EdgeInsets symEdgeInsets0 = EdgeInsets.zero;
  EdgeInsets sEdgeVert16 = const EdgeInsets.symmetric(vertical: 16);
  EdgeInsets sEdgeHorz16 = const EdgeInsets.symmetric(horizontal: 16);
  EdgeInsets sEdgeBoth10 =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 10);
  EdgeInsets sEdgeHorz(double val) => EdgeInsets.symmetric(horizontal: val);
  EdgeInsets sEdgeVert(double val) => EdgeInsets.symmetric(vertical: val);

//! Rounded Corners

  BorderRadiusGeometry roundedCorner(double radius) =>
      BorderRadius.circular(radius);

  ShapeBorder roundedCornerShape(double radius) =>
      RoundedRectangleBorder(borderRadius: roundedCorner(radius));

//! Screen Size
  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

//! Navigation
  Future<dynamic> navigate(BuildContext context, Widget child) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (BuildContext context) => child));

  Future<dynamic> replace(BuildContext context, Widget child) =>
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => child));
  AnimatedSwitcher blocNavigator({required Widget child}) => AnimatedSwitcher(
        switchOutCurve: const Threshold(0),
        duration: const Duration(milliseconds: 300),
        child: child,
      );
//!Shadow Decoration
  BoxDecoration shadowWithRadius({
    double radius = 4,
    Color dropShadow = MyColors.greyShade3,
  }) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: dropShadow,
            offset: const Offset(
              0.0,
              1.0,
            ),
            blurRadius: 4.0,
            spreadRadius: 1.1,
          ), //BoxShadow
          const BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      );

//! Color Pallate
  static const List<Map<String, dynamic>> colorPallete = [
    {
      "id": 1,
      "border": MyColors.greyShade2,
      "bg": MyColors.greyShade1,
    },
    {
      "id": 2,
      "border": MyColors.greenShade2,
      "bg": MyColors.greenShade1,
    },
    {
      "id": 3,
      "border": MyColors.yellowShade2,
      "bg": MyColors.yellowShade1,
    },
    {
      "id": 4,
      "border": MyColors.peachShade2,
      "bg": MyColors.peachShade1,
    },
    {
      "id": 5,
      "border": MyColors.purpleShade3,
      "bg": MyColors.purpleShade2,
    },
    {
      "id": 6,
      "border": MyColors.blueGreyShade2,
      "bg": MyColors.blueGreyShade1,
    },
    {
      "id": 7,
      "border": MyColors.skyShade2,
      "bg": MyColors.skyShade1,
    },
  ];

  static Color setColor(int colorId) {
    switch (colorId) {
      case 1:
        return MyColors.greyShade1;
      case 2:
        return MyColors.greenShade1;
      case 3:
        return MyColors.yellowShade2;
      case 4:
        return MyColors.peachShade1;
      case 5:
        return MyColors.purpleShade2;
      case 6:
        return MyColors.blueGreyShade1;
      case 7:
        return MyColors.skyShade1;

      default:
        return MyColors.blueShade1;
    }
  }
}
