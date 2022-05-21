import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';

import '../../core/style/style.dart';
import '../../core/widgets/btn.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Btn.withIcon(
        width: 60,
        height: 60,
        onPressed: () {
          OpenStore.instance
              .open(androidAppBundleId: 'com.sohilbhanani.account_manager');
        },
        label: 'Share',
        labelStyle: const TS.sb12(clr: MyColors.greyShade3),
        icon: const Icon(
          Icons.share,
          color: MyColors.greyShade3,
        ));
  }
}
