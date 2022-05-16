import 'package:flutter/material.dart';

import '../../../core/style/style.dart';
import '../../database/domain/model/account_model.dart';
import '../dialogs/add_new_account_dialog.dart';

class AddAccountHeader extends SliverPersistentHeaderDelegate {
  AddAccountHeader({required this.onSubmit});

  final Function(Account account) onSubmit;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: MyColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Row(
          children: [
            const Text(
              'Ledgers',
              style: TS.sb14(),
            ),
            const Spacer(),
            ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext ctx) {
                        return AddNewAccountDialog(
                          onSubmit: onSubmit,
                        );
                      });
                },
                icon: const Icon(
                  Icons.add,
                  size: 18,
                ),
                label: const Text(
                  'Add',
                  style: TS.sb14(clr: MyColors.white),
                ))
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
