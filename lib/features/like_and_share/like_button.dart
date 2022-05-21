import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';

import '../../core/style/colors.dart';
import '../../core/style/text_style.dart';
import '../../core/widgets/btn.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Btn.withIcon(
        width: 60,
        height: 60,
        onPressed: () {
          OpenStore.instance
              .open(androidAppBundleId: 'com.sohilbhanani.account_manager');
        },
        label: 'Like',
        labelStyle: const TS.sb12(clr: MyColors.greyShade3),
        icon: const Icon(
          Icons.favorite,
          color: MyColors.greyShade3,
        ));
  }
}
