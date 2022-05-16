import 'dart:convert';

import 'package:account_manager/features/currency_selection/currency_selection.dart';
import 'package:account_manager/features/settings/change_security_questions.dart';
import 'package:account_manager/features/settings/dialogs/change_pin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/style/colors.dart';
import '../../core/style/text_style.dart';
import '../../core/style/ui_helpers.dart';
import '../prefs/model/config_model.dart';
import '../prefs/prefs.dart';
import 'dialogs/about_me_dialog.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? appVersion;
  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version + "+${packageInfo.buildNumber}";
    });
  }

  @override
  void initState() {
    getAppVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configs =
        ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text(
          'Settings',
          style: TS.b20(clr: MyColors.greyShade3),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AboutMeDialog(),
                );
              },
              icon: const Icon(
                Icons.info_outline,
                color: MyColors.greyShade3,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ChronologicalSort(configs: configs),
                  const Divider(),
                  ChangeCurrency(configs: configs),
                  const ChangePin(),
                  const ChangeSecurityQuestions(),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appVersion == null ? 'loading' : "v-$appVersion",
                style: TS.b14(clr: MyColors.greyShade1),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ChronologicalSort extends StatefulWidget {
  const ChronologicalSort({
    Key? key,
    required this.configs,
  }) : super(key: key);

  final ConfigModel configs;
  @override
  State<ChronologicalSort> createState() => _ChronologicalSortState();
}

class _ChronologicalSortState extends State<ChronologicalSort> {
  @override
  Widget build(BuildContext context) {
    final ConfigModel configs =
        ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
    return SwitchListTile(
      activeColor: MyColors.greyShade3,
      value: configs.settings == null
          ? false
          : configs.settings!.sorting == Sorting.chronological.name,
      onChanged: (bool val) async {
        ConfigModel updatedConfigs = configs.copyWith(
          settings: configs.settings == null
              ? SettingsModel().copyWith(
                  sorting: val ? Sorting.chronological.name : Sorting.none.name)
              : configs.settings!.copyWith(
                  sorting:
                      val ? Sorting.chronological.name : Sorting.none.name),
        );
        await Prefs.setString('authStatus', jsonEncode(updatedConfigs));
        setState(() {});
      },
      title: const Text('Chronological sorting'),
      subtitle: const Text('Date based sorting'),
    );
  }
}

class ChangeCurrency extends StatelessWidget {
  const ChangeCurrency({
    Key? key,
    required this.configs,
  }) : super(key: key);

  final ConfigModel configs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        UIH().replace(context, const CurrencySelectionScreen.pop());
      },
      leading: const Icon(Icons.currency_exchange),
      title: const Text(
        'Change Currency',
        style: TS.sb16(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            configs.currency!.currencyCode!,
            style: const TS.sb14(clr: MyColors.greyShade1),
          ),
          Text(
            " (" + configs.currency!.symbol! + ")",
            style: const TextStyle(color: MyColors.greyShade1),
          ),
        ],
      ),
    );
  }
}

class ChangePin extends StatelessWidget {
  const ChangePin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ChangePinDialog(),
        );
      },
      leading: const Icon(Icons.key),
      title: const Text(
        'Change Pin',
        style: TS.sb16(),
      ),
    );
  }
}

class ChangeSecurityQuestions extends StatelessWidget {
  const ChangeSecurityQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        UIH().navigate(context, const ChangeSecurityQuestionsScreen());
      },
      leading: const Icon(Icons.add_moderator_outlined),
      title: const Text(
        'Change Security Questions',
        style: TS.sb16(),
      ),
    );
  }
}
