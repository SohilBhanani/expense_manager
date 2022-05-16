import 'package:account_manager/core/widgets/expanded_section.dart';
import 'package:account_manager/features/pdf/bloc/pdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/style/style.dart';
import '../../core/widgets/btn.dart';
import '../database/domain/model/account_model.dart';

class AccountScreenExpansionDrawer extends StatelessWidget {
  const AccountScreenExpansionDrawer(
      {required this.isExpanded, required this.accountData});
  final Account accountData;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return ExpandedSection(
      expand: isExpanded,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
        child: Row(
          children: [
            Btn.withIcon(
                width: 60,
                height: 60,
                onPressed: () {},
                label: 'Like',
                labelStyle: const TS.sb12(clr: MyColors.greyShade3),
                icon: const Icon(
                  Icons.favorite,
                  color: MyColors.greyShade3,
                )),
            UIH.horzGapSmall,
            Btn.withIcon(
                width: 60,
                height: 60,
                onPressed: () {},
                label: 'Share',
                labelStyle: const TS.sb12(clr: MyColors.greyShade3),
                icon: const Icon(
                  Icons.share,
                  color: MyColors.greyShade3,
                )),
            UIH.horzGapSmall,
            Expanded(
              child: Btn(
                  height: 60,
                  onPressed: () {
                    context.read<PdfBloc>().add(
                        GenerateAccSpecificPdfEvent(accountData: accountData));
                  },
                  child: const Text(
                    "Save as PDF",
                    style: TS.sb14(clr: MyColors.greyShade3),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
