import 'package:flutter/material.dart';

import '../../core/style/style.dart';

class KeyPad extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onDone;
  const KeyPad({required this.controller, required this.onDone});
  @override
  Widget build(BuildContext context) {
    Size size = UIH().screenSize(context);
    List<Widget> keyList = <Widget>[
      keyWidget('1'),
      keyWidget('2'),
      keyWidget('3'),
      keyWidget('4'),
      keyWidget('5'),
      keyWidget('6'),
      keyWidget('7'),
      keyWidget('8'),
      keyWidget('9'),
      backSpace(),
      keyWidget('0'),
      next(),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      crossAxisCount: 3,
      children: keyList,
    );
  }

  Material keyWidget(String value) {
    return Material(
      color: MyColors.blueShade1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        splashColor: Colors.blue,
        highlightColor: MyColors.blueShade1,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: () {
          if (controller.text.length < 4) controller.text += value;
        },
        child: Center(
          child: Text(
            value,
            style: const TS.sb18(),
          ),
        ),
      ),
    );
  }

  Material backSpace() {
    return Material(
      // color: MyColors.blueShade1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: () {
          if (controller.text.isNotEmpty) {
            controller.text =
                controller.text.substring(0, controller.text.length - 1);
          }
        },
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 24,
          ),
        ),
      ),
    );
  }

  Material next() {
    return Material(
      // color: MyColors.blueShade1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: () {
          if (controller.text.length == 4) {
            onDone();
          }
        },
        child: const Center(
          child: Icon(
            Icons.forward_outlined,
            size: 30,
            color: MyColors.blueShade2,
          ),
        ),
      ),
    );
  }
}
