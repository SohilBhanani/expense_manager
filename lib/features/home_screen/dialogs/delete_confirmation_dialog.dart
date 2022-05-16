import 'package:account_manager/features/database/domain/model/account_model.dart';
import 'package:flutter/material.dart';

import '../../../core/style/style.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog(
      {required this.accountData, required this.onConfirmed});
  final Account accountData;
  final VoidCallback onConfirmed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: MyColors.redShade1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: const [
                  Center(
                    child: Text(
                      'Delete Account',
                      style: TS.sb16(clr: MyColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Text(
              'Delete ${accountData.accountName} ? ',
              style: const TS.sb16(),
            ),
          ),
          UIH.vertGapSmall,
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TS.sb12(clr: MyColors.greyShade2),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    side:
                        const BorderSide(color: MyColors.greyShade2, width: 2),
                  ),
                ),
                UIH.horzGapMedium,
                ElevatedButton(
                  onPressed: () {
                    onConfirmed();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TS.sb12(clr: MyColors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      primary: MyColors.redShade1),
                ),
              ],
            ),
          ),
          UIH.vertGapSmall,
        ],
      ),
    );
  }
}
