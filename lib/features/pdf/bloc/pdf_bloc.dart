import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:account_manager/features/database/data/account_datasource.dart';
import 'package:account_manager/features/pdf/summary_report_pdf.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../database/data/transaction_datasource.dart';
import '../../database/domain/model/account_model.dart';
import '../../database/domain/model/transaction_model.dart';
import '../../prefs/model/config_model.dart';
import '../../prefs/prefs.dart';
import '../account_specific_pdf.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  Future<void> saveFile({
    required Uint8List data,
    required String fileName,
  }) async {
    try {
      final params = SaveFileDialogParams(
        data: data,
        fileName: fileName +
            '_' +
            math.Random().nextInt(100).toString() +
            '_' +
            DateFormat("dd-MM-yyyy").format(
              DateTime.now(),
            ) +
            '.pdf',
      );

      await FlutterFileDialog.saveFile(params: params);
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
    }
  }

  PdfBloc() : super(PdfInitial()) {
    final transactionDataSource = TransactionDataSource();
    final accDataSource = AccountDataSource();
    final ConfigModel configs =
        ConfigModel.fromJson(jsonDecode(Prefs.getString('authStatus')!));
    on<GenerateAccSpecificPdfEvent>((event, emit) async {
      emit(PdfLoading());
      List<Transaction> transactions = await transactionDataSource.getAllTxnOf(
        event.accountData.id!,
        configs.settings!.sorting == Sorting.chronological.name,
      );
      if (transactions.isEmpty) {
        Fluttertoast.showToast(msg: "No Transactions on this account.");
        return;
      }

      final pdf = pw.Document();
      final font = await rootBundle.load("fonts/BalooBhai2-Regular.ttf");
      final ttf = pw.Font.ttf(font);

      pdf.addPage(
          accountSpecificPdfFormat(transactions, event.accountData, ttf));

      await saveFile(
        data: await pdf.save(),
        fileName: event.accountData.accountName,
      );

      emit(PdfGenerated());
    });

    on<GenerateSummaryReportPdfEvent>((event, emit) async {
      emit(PdfLoading());
      List<Account> accounts = await accDataSource.getAllAccounts();
      if (accounts.isEmpty) {
        Fluttertoast.showToast(msg: "Please add account to generate PDF.");
        return;
      }
      final pdf = pw.Document();
      final font = await rootBundle.load("fonts/BalooBhai2-Regular.ttf");
      final ttf = pw.Font.ttf(font);

      pdf.addPage(summaryReportPdfFormat(accounts, ttf));

      await saveFile(
        data: await pdf.save(),
        fileName: 'report_summary',
      );

      emit(PdfGenerated());
    });
  }
}
