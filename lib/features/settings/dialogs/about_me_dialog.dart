import 'package:flutter/material.dart';

import '../../../core/style/style.dart';

class AboutMeDialog extends StatelessWidget {
  const AboutMeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 38,
                  color: MyColors.greyShade1,
                ),
                UIH.horzGapSmall,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Sohil Bhanani",
                      style: TS.sb16(),
                    ),
                    Text(
                      "sbhananis@gmail.com",
                      style: TS.sb14(clr: MyColors.greyShade1),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: const [
                // IconButton(
                //     onPressed: () {},
                //     icon: FaIcon(

                //       FontAwesomeIcons.,
                //       color: MyColors.greyShade1,
                //       size: 30,
                //     )),
                // IconButton(
                //     onPressed: () {},
                //     icon: Icon(
                //       Icons.,
                //       color: MyColors.greyShade1,
                //       size: 30,
                //     ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
