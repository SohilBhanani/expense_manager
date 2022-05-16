part of 'pdf_bloc.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class GenerateAccSpecificPdfEvent extends PdfEvent {
  const GenerateAccSpecificPdfEvent({required this.accountData});

  final Account accountData;
}

class GenerateSummaryReportPdfEvent extends PdfEvent {
  const GenerateSummaryReportPdfEvent({required this.accountList});
  final List<Account> accountList;
}
