import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:account_manager/features/database/database.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// const String defaultDatabasePath =
//     '/data/data/com.sohilbhanani.account_manager/databases/account_database.db';

class BackupAndRestore {
  //for generating unique name everytime user backup
  String _randomInteger() {
    return math.Random().nextInt(100).toString();
  }

  //for appending date to backup name
  String _backupDate() {
    return DateFormat("dd-MM-yyyy").format(DateTime.now());
  }

  String _backupFileName() {
    return 'backup_' + _randomInteger() + '_' + _backupDate() + '.db';
  }

  Future<void> backup() async {
    //path of database file
    final String path = await getDatabasesPath();
    // File source1 = File(defaultDatabasePath);
    log("~~~~~~~~~~" + join(path, 'account_database.db'));
    File source1 = File(join(path, 'account_database.db'));

    final params = SaveFileDialogParams(
      sourceFilePath: source1.path,
      fileName: _backupFileName(),
    );

    await FlutterFileDialog.saveFile(params: params);
    Fluttertoast.showToast(msg: 'Backup Success');
  }

  Future<void> restore() async {
    //select backup file from folder
    const params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.document,
      sourceType: SourceType.photoLibrary,
      fileExtensionsFilter: ['db'],
    );
    try {
      String? dbPath = await FlutterFileDialog.pickFile(params: params);

      if (dbPath != null) {
        log(dbPath);

        final String path = await getDatabasesPath();

        await deleteDatabase(join(path, 'account_database.db'));
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (e) {
          log("Error at dri: $e");
        }

        List<int> bytes = await File(dbPath).readAsBytes();
        await File(join(path, 'account_database.db'))
            .writeAsBytes(bytes, flush: true);

        await AccountDatabase.init();
      } else {
        Fluttertoast.showToast(msg: 'No File Selected');
      }
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      Fluttertoast.showToast(msg: 'Invalid File Selected');
    }
  }
}
