import 'package:account_manager/core/style/colors.dart';
import 'package:flutter/material.dart';

import '../style/ui_helpers.dart';

class Btn extends ElevatedButton {
  Btn({
    required VoidCallback? onPressed,
    required Widget? child,
    Color color = MyColors.blueShade1,
    double width = double.infinity,
    double height = 50,
  }) : super(
            onPressed: onPressed,
            child: child,
            // style: ElevatedButton.styleFrom(
            //   primary: color,
            //   minimumSize: Size(width, height),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(6.0),
            //   ),
            // ),
            style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(Size(width, height)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(color),
                overlayColor: MaterialStateProperty.all<Color>(
                    MyColors.greyShade1.withOpacity(0.4))));

  Btn.withIcon({
    required VoidCallback? onPressed,
    required String label,
    required Widget icon,
    Color bgcolor = MyColors.blueShade1,
    TextStyle? labelStyle,
    double width = double.infinity,
    double height = double.infinity,
  }) : super(
          onPressed: onPressed,
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                UIH.vertGapTiny,
                Text(label, style: labelStyle),
              ],
            ),
          ),
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(width, height)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              )),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              backgroundColor: MaterialStateProperty.all<Color>(bgcolor),
              overlayColor: MaterialStateProperty.all<Color>(
                  MyColors.greyShade1.withOpacity(0.4))),
        );
}
