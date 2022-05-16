import 'package:account_manager/core/style/style.dart';
import 'package:account_manager/core/widgets/btn.dart';
import 'package:account_manager/core/widgets/expanded_section.dart';
import 'package:account_manager/features/backup_and_restore/backup_and_restore.dart';
import 'package:account_manager/features/database/data/account_datasource.dart';
import 'package:account_manager/features/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pdf/bloc/pdf_bloc.dart';
import '../cubit/accounts_cubit.dart';

class ExpansionDrawer extends StatelessWidget {
  const ExpansionDrawer({required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    BackupAndRestore backupAndRestore = BackupAndRestore();
    final accounts = AccountDataSource();
    return ExpandedSection(
      expand: isExpanded,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Btn.withIcon(
                    width: 60,
                    height: 60,
                    onPressed: () async {
                      await backupAndRestore.backup();
                    },
                    label: 'Backup',
                    labelStyle: const TS.sb12(clr: MyColors.greyShade3),
                    icon: const Icon(
                      Icons.memory,
                      color: MyColors.greyShade3,
                    )),
                UIH.horzGapSmall,
                Btn.withIcon(
                    width: 60,
                    height: 60,
                    onPressed: () async {
                      backupAndRestore.restore().then((value) {
                        context.read<AccountsCubit>().getAccountsList();
                      });
                    },
                    label: 'Restore',
                    labelStyle: const TS.sb12(clr: MyColors.greyShade3),
                    icon: const Icon(
                      Icons.settings_backup_restore,
                      color: MyColors.greyShade3,
                    )),
                UIH.horzGapSmall,
                Expanded(
                  child: Btn(
                      height: 60,
                      onPressed: () async {
                        context.read<PdfBloc>().add(
                              GenerateSummaryReportPdfEvent(
                                accountList: await accounts.getAllAccounts(),
                              ),
                            );
                      },
                      child: const Text(
                        "Save as PDF",
                        style: TS.sb14(clr: MyColors.greyShade3),
                      )),
                )
              ],
            ),
            UIH.vertGapSmall,
            Row(
              children: [
                Expanded(
                  child: Btn(
                      height: 60,
                      onPressed: () {
                        UIH().navigate(context, const Settings());
                      },
                      child: const Text(
                        "Settings",
                        style: TS.sb14(clr: MyColors.greyShade3),
                      )),
                ),
                UIH.horzGapSmall,
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
