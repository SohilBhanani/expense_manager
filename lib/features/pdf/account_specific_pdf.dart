import 'package:account_manager/features/database/domain/model/account_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../database/domain/model/transaction_model.dart';

Page accountSpecificPdfFormat(
    List<Transaction> transactions, Account accountData, Font ttf) {
  double totalCredit = 0;
  double totalPayment = 0;
  for (var trx in transactions) {
    totalCredit += trx.credit;
    totalPayment += trx.payment;
  }
  double balance = totalCredit - totalPayment;
  return Page(
    pageFormat: PdfPageFormat.a4,
    build: (Context context) => Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  height: 15,
                  color: PdfColor.fromHex('#80393D'),
                  child: Center(
                    child: Text(accountData.accountName,
                        style: TextStyle(color: PdfColor.fromHex('#FFFFFF'))),
                  )),
            )
          ],
        ),
        Table(
            border: TableBorder.all(color: PdfColor.fromHex('#3E4756')),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  decoration: BoxDecoration(color: PdfColor.fromHex('#FFBEC1')),
                  children: [
                    Expanded(
                      child: Column(children: [
                        Text('#', style: const TextStyle(fontSize: 12.0))
                      ]),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(children: [
                        Text('Date', style: const TextStyle(fontSize: 12.0))
                      ]),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(children: [
                        Text('Note', style: const TextStyle(fontSize: 12.0))
                      ]),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(children: [
                        Text('Payment', style: const TextStyle(fontSize: 12.0)),
                      ]),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(children: [
                        Text('Credit', style: const TextStyle(fontSize: 12.0))
                      ]),
                    ),
                  ]),
              ...List.generate(
                transactions.length,
                (index) => TableRow(children: [
                  Expanded(
                    child: Column(children: [
                      Text('${index + 1}',
                          style: const TextStyle(fontSize: 12.0))
                    ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(children: [
                      Text(
                          DateFormat("dd-MM-yyyy").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  transactions[index].transactionDate)),
                          style: const TextStyle(fontSize: 12.0))
                    ]),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                transactions[index].note ?? '--',
                                style: TextStyle(fontSize: 12.0, font: ttf),
                              ))
                        ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                  transactions[index].payment == 0
                                      ? ''
                                      : transactions[index].payment.toString(),
                                  style: const TextStyle(fontSize: 12.0)))
                        ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                  transactions[index].credit == 0
                                      ? ''
                                      : transactions[index].credit.toString(),
                                  style: const TextStyle(fontSize: 12.0)))
                        ]),
                  ),
                ]),
              ),
            ]),
        Table(
            border: TableBorder.all(color: PdfColor.fromHex('#3E4756')),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  decoration: BoxDecoration(color: PdfColor.fromHex('#FFBEC1')),
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text('Net',
                                    style: const TextStyle(fontSize: 12.0)))
                          ]),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(totalPayment.toString(),
                                    style: const TextStyle(fontSize: 12.0))),
                          ]),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(totalCredit.toString(),
                                    style: const TextStyle(fontSize: 12.0)))
                          ]),
                    ),
                  ]),
            ]),
        Table(
            border: TableBorder.all(color: PdfColor.fromHex('#3E4756')),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  decoration: BoxDecoration(color: PdfColor.fromHex('#FFBEC1')),
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text('Balance',
                                    style: const TextStyle(fontSize: 12.0)))
                          ]),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(balance.toString(),
                                    style: const TextStyle(fontSize: 12.0)))
                          ]),
                    ),
                  ]),
            ])
      ],
    ),
  );
}
