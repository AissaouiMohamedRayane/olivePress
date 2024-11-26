import 'package:frontend/services/models/User.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:barcode/barcode.dart' ;


import 'package:flutter/services.dart' show rootBundle;

import '../services/models/Customer.dart';
import '../services/models/Company.dart';

Future _loadLocationImage() async {
  final data = await rootBundle.load('assets/images/location.png');
  return data.buffer.asUint8List();
}

Future _loadPhoneImage() async {
  final data = await rootBundle.load('assets/images/phone.jpg');
  return data.buffer.asUint8List();
}

String getCurrentDate() {
  final DateTime now = DateTime.now();
  final String formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  return formattedDate;
}

String getCurrentTime() {
  final DateTime now = DateTime.now();
  final String formattedTime =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  return formattedTime;
}

Future<pw.Font> _loadArabicFont() async {
  final fontData = await rootBundle.load(
      "assets/fonts/NotoNaskhArabic-Regular.ttf"); // Replace with your Arabic font file path
  return pw.Font.ttf(fontData);
}

Future<pw.Font> _loadArabicBoldFont() async {
  final fontData = await rootBundle.load(
      "assets/fonts/NotoNaskhArabic-Bold.ttf"); // Replace with your Arabic font file path
  return pw.Font.ttf(fontData);
}

Future<File> generatePdf(CompanyProvider companyProvider,
    UserProvider userProvider, Customer customer, int totalSum, pw.Document pdf,
    [int? id]) async {
  final locationImageBytes = await _loadLocationImage();
  final locationImage = pw.MemoryImage(locationImageBytes);
  final phoneImageBytes = await _loadPhoneImage();
  final phoneImage = pw.MemoryImage(phoneImageBytes);
  final arabicFont = await _loadArabicFont();
  final arabicBoldFont = await _loadArabicBoldFont();

  final String data = 'test';
  final barcode = Barcode.code128();
  final svg = barcode.toSvg(
    data, width: 160, height: 25,
    drawText: false, // This removes the text under the barcode
  );
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, 130 * PdfPageFormat.mm),
      build: (pw.Context context) {
        return pw.Padding(
            padding: pw.EdgeInsets.all(10),
            child: pw.Container(
                width: double.infinity,
                height: 330,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(
                    color: PdfColors.black, // Border color
                    width: 3.0, // Border width
                  ),
                ),
                child: pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Padding(
                      padding:
                          pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Center(
                              child: pw.Text(companyProvider.company!.name,
                                  style: pw.TextStyle(
                                    font: arabicBoldFont,
                                    fontSize: 23,
                                  )),
                            ),
                            pw.Row(children: [
                              pw.Image(locationImage, width: 12, height: 12),
                              pw.SizedBox(width: 5),
                              pw.Text(companyProvider.company!.address,
                                  style: pw.TextStyle(
                                      font: arabicFont,
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.normal))
                            ]),
                            pw.Row(children: [
                              pw.Image(phoneImage, width: 12, height: 12),
                              pw.SizedBox(width: 5),
                              pw.Text(companyProvider.company!.phone1,
                                  style: pw.TextStyle(
                                      font: arabicFont,
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.normal)),
                              pw.SizedBox(width: 30),
                              if (companyProvider.company!.phone2 != '')
                                pw.Text(companyProvider.company!.phone2!,
                                    style: pw.TextStyle(
                                        font: arabicFont,
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.normal))
                            ]),
                            pw.SizedBox(height: 5),
                            pw.SvgImage(svg: svg),
                            pw.Row(
                              children: [
                                pw.Text('الرقم: ',
                                    style: pw.TextStyle(
                                        decoration: pw.TextDecoration.underline,
                                        decorationColor: PdfColors.black,
                                        font: arabicBoldFont,
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.normal)),
                                pw.SizedBox(width: 30),
                                pw.Text(
                                    id != null
                                        ? id.toString().padLeft(6,
                                            '0') // Pads with zeros if id is not null
                                        : customer.id != null
                                            ? customer.id.toString().padLeft(6,
                                                '0') // Pads with zeros if customer.id is not null
                                            : '000000', // Default value if both are null

                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(width: 30),
                                pw.Text(
                                    customer.oliveType == 1
                                        ? 'أخضر'
                                        : customer.oliveType == 2
                                            ? 'أحمر'
                                            : 'أسود',
                                    style: pw.TextStyle(
                                        font: arabicFont,
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal))
                              ],
                            ),
                            pw.Row(children: [
                              pw.Text('التاريخ: ',
                                  style: pw.TextStyle(
                                      font: arabicFont,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal)),
                              pw.SizedBox(width: 30),
                              pw.Text(getCurrentDate(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal)),
                              pw.SizedBox(width: 25),
                              pw.Text('المستخدم: ',
                                  style: pw.TextStyle(
                                      decoration: pw.TextDecoration.underline,
                                      decorationColor: PdfColors.black,
                                      font: arabicFont,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal)),
                            ]),
                            pw.Row(children: [
                              pw.Text('الوقت: ',
                                  style: pw.TextStyle(
                                      font: arabicFont,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal)),
                              pw.SizedBox(width: 40),
                              pw.Text(getCurrentTime(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal)),
                              pw.SizedBox(width: 40),
                              pw.Text(userProvider.user!.username,
                                  style: pw.TextStyle(
                                      font: arabicFont,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal)),
                            ]),
                            pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Table(
                                    columnWidths: const {
                                      0: pw.FractionColumnWidth(.2),
                                      1: pw.FractionColumnWidth(.4),
                                      2: pw.FractionColumnWidth(.4)
                                    },
                                    border: pw.TableBorder(
                                      top: const pw.BorderSide(
                                          width: 1, color: PdfColors.black),
                                      bottom: const pw.BorderSide(
                                          width: 1, color: PdfColors.black),
                                      horizontalInside:
                                          const pw.BorderSide(width: .2),
                                    ),
                                    children: [
                                      pw.TableRow(children: [
                                        pw.Text('',
                                            style: pw.TextStyle(
                                                fontSize:
                                                    8)), // Empty Unit Column
                                        pw.Row(children: [
                                          pw.SizedBox(width: 1),
                                          pw.Text(customer.name,
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ]),
                                        pw.Row(children: [
                                          pw.SizedBox(width: 4),
                                          pw.Text('الاسم الكامل',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ]),
                                      ]),
                                      pw.TableRow(children: [
                                        pw.Row(children: [
                                          pw.SizedBox(width: 4),
                                          pw.Text('صندوق',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ]),
                                        pw.Text(
                                            customer.bags!
                                                .map((bag) => bag.number)
                                                .fold(
                                                    0,
                                                    (sum, number) =>
                                                        sum + number!)
                                                .toString(),
                                            style: pw.TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    pw.FontWeight.normal)),
                                        pw.Row(children: [
                                          pw.SizedBox(width: 4),
                                          pw.Text('عدد الصناديق',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ])
                                      ]),
                                      pw.TableRow(children: [
                                        pw.Row(children: [
                                          pw.SizedBox(width: 3),
                                          pw.Text('كغ',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ]),
                                        pw.Text(
                                            customer.bags!
                                                .map((bag) => bag.weight)
                                                .fold(
                                                    0,
                                                    (sum, number) =>
                                                        sum + number!)
                                                .toString(),
                                            style: pw.TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    pw.FontWeight.normal)),
                                        pw.Row(children: [
                                          pw.SizedBox(width: 3),
                                          pw.Text('الوزن',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ])
                                      ]),
                                      pw.TableRow(children: [
                                        pw.Row(children: [
                                          pw.SizedBox(width: 3),
                                          pw.Text('الاوعية',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ]),
                                        pw.Text(
                                            customer.containers![0].number
                                                .toString(),
                                            style: pw.TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    pw.FontWeight.normal)),
                                        pw.Row(children: [
                                          pw.SizedBox(width: 4),
                                          pw.Text('عدد الاوعية',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ])
                                      ]),
                                      pw.TableRow(children: [
                                        pw.Row(children: [
                                          pw.SizedBox(width: 3),
                                          pw.Text('ل',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ]),
                                        pw.Text(
                                            customer.containers![0].capacity
                                                .toString(),
                                            style: pw.TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    pw.FontWeight.normal)),
                                        pw.Row(children: [
                                          pw.SizedBox(width: 3),
                                          pw.Text('السعة',
                                              style: pw.TextStyle(
                                                  font: arabicFont,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ])
                                      ]),
                                    ])),
                            pw.SizedBox(height: 5),
                            pw.Row(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text('صافي الدفع عند إستلام الزيت: ',
                                      style: pw.TextStyle(
                                          font: arabicFont,
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal)),
                                  pw.SizedBox(width: 5),
                                  pw.Container(
                                      padding: pw.EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color:
                                              PdfColors.black, // Border color
                                          width: 1.0, // Border width
                                        ),
                                      ),
                                      child: pw.Row(children: [
                                        pw.Text(totalSum.toString(),
                                            style: pw.TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    pw.FontWeight.normal)),
                                        pw.SizedBox(width: 13),
                                        pw.Text('دج',
                                            style: pw.TextStyle(
                                                font: arabicFont,
                                                fontSize: 10,
                                                fontWeight:
                                                    pw.FontWeight.normal))
                                      ]))
                                ]),
                            pw.SizedBox(height: 5),
                            pw.Center(
                                child: pw.Text(companyProvider.company!.sign!,
                                    style: pw.TextStyle(
                                        font: arabicBoldFont,
                                        fontSize: 18,
                                        fontWeight: pw.FontWeight.bold)))
                          ]),
                    )))); // Center
      }));

  // Save the PDF to a file
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/receipt.pdf");
  await file.writeAsBytes(await pdf.save());

  // Open the PDF using the default viewer
  return file;
}
Future<void> generateBagsPdf(
    Containers container, pw.Document pdf, int id, Customer customer) async {
  final arabicFont = await _loadArabicFont();
  final barcode = Barcode.code128();

  for (int i = 1; i <= container.number!; i++) {
    final String oliveType = customer.oliveType == 1
        ? 'vert'
        : customer.oliveType == 2
            ? 'rouge'
            : 'noir';
    final String data =
        '${id.toString().padLeft(5, '0')}-${i.toString().padLeft(2, '0')} $oliveType'; // Example EAN-13 code

    final svg = barcode.toSvg(
      data, width: 80, height: 20,
      drawText: false, // This removes the text under the barcode
    );
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(40 * PdfPageFormat.mm, 20 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Padding(
              padding: pw.EdgeInsets.all(4),
              child: pw.Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    border: pw.Border.all(
                      color: PdfColors.black, // Border color
                      width: 3.0, // Border width
                    ),
                  ),
                  child: pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Column(children: [
                            pw.SvgImage(svg: svg),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                      '${id.toString().padLeft(5, '0')}-${i.toString().padLeft(2, '0')}',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                      )),
                                  pw.SizedBox(width: 8),
                                  pw.Text('خ',
                                      style: pw.TextStyle(
                                          font: arabicFont,
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal)),
                                ])
                          ])))));
        }));
  }
  }

  