import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

Future<File> generatePdf(CompanyProvider companyProvider, Customer customer,
    int totalSum, pw.Document pdf,
    [int? id]) async {
  final locationImageBytes = await _loadLocationImage();
  final locationImage = pw.MemoryImage(locationImageBytes);
  final phoneImageBytes = await _loadPhoneImage();
  final phoneImage = pw.MemoryImage(phoneImageBytes);
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
            width: double.infinity,
            height: 1000,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(
                color: PdfColors.black, // Border color
                width: 3.0, // Border width
              ),
            ),
            child: pw.Padding(
              padding: pw.EdgeInsets.all(16),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(companyProvider.company!.name,
                          style: pw.TextStyle(
                              fontSize: 50, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(children: [
                      pw.Image(locationImage, width: 30, height: 30),
                      pw.SizedBox(width: 20),
                      pw.Text(companyProvider.company!.address,
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.normal))
                    ]),
                    pw.Row(children: [
                      pw.Image(phoneImage, width: 30, height: 30),
                      pw.SizedBox(width: 20),
                      pw.Text(companyProvider.company!.phone1,
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(width: 20),
                      if (companyProvider.company!.phone2 != '')
                        pw.Text(companyProvider.company!.phone2!)
                    ]),
                    pw.SizedBox(height: 15),
                    pw.Row(
                      children: [
                        pw.Text('id: ',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.SizedBox(width: 80),
                        pw.Text(id.toString() ?? '00000',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.SizedBox(width: 80),
                        pw.Text(
                            customer.oliveType == 1
                                ? 'green'
                                : customer.oliveType == 2
                                    ? 'red'
                                    : 'black',
                            style: pw.TextStyle(
                                fontSize: 30, fontWeight: pw.FontWeight.normal))
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(children: [
                      pw.Text('date: ',
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(width: 15),
                      pw.Text(getCurrentDate(),
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.normal))
                    ]),
                    pw.SizedBox(height: 5),
                    pw.Row(children: [
                      pw.Text('time: ',
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(width: 15),
                      pw.Text(getCurrentTime(),
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.normal))
                    ]),
                    pw.SizedBox(height: 5),
                    pw.Table(columnWidths: const {
                      0: pw.FractionColumnWidth(.6),
                      1: pw.FractionColumnWidth(.2),
                      2: pw.FractionColumnWidth(.2)
                    }, children: [
                      pw.TableRow(children: [
                        pw.Text('Full name',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text(customer.name,
                            style: pw.TextStyle(
                                fontSize: 30, fontWeight: pw.FontWeight.normal))
                      ]),
                      pw.TableRow(children: [
                        pw.Text('nombre de sac',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text(
                            customer.bags!
                                .map((bag) => bag.number)
                                .fold(0, (sum, number) => sum + number!)
                                .toString(),
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text('sac',
                            style: pw.TextStyle(
                                fontSize: 30, fontWeight: pw.FontWeight.normal))
                      ]),
                      pw.TableRow(children: [
                        pw.Text('Weight',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text(
                            customer.bags!
                                .map((bag) => bag.weight)
                                .fold(0, (sum, number) => sum + number!)
                                .toString(),
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text('Kg',
                            style: pw.TextStyle(
                                fontSize: 30, fontWeight: pw.FontWeight.normal))
                      ]),
                      pw.TableRow(children: [
                        pw.Text('containers number',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text(customer.containers![0].number.toString(),
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text('container',
                            style: pw.TextStyle(
                                fontSize: 30, fontWeight: pw.FontWeight.normal))
                      ]),
                      pw.TableRow(children: [
                        pw.Text('Capacity',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text(customer.containers![0].capacity.toString(),
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: pw.FontWeight.normal)),
                        pw.Text('L',
                            style: pw.TextStyle(
                                fontSize: 30, fontWeight: pw.FontWeight.normal))
                      ]),
                    ]),
                    pw.SizedBox(height: 5),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text('Payment upon reciept: ',
                              style: pw.TextStyle(
                                  fontSize: 30,
                                  fontWeight: pw.FontWeight.normal)),
                          pw.SizedBox(width: 5),
                          pw.Container(
                              padding: pw.EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                  color: PdfColors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: pw.Row(children: [
                                pw.Text(totalSum.toString(),
                                    style: pw.TextStyle(
                                        fontSize: 30,
                                        fontWeight: pw.FontWeight.normal)),
                                pw.SizedBox(width: 5),
                                pw.Text('Da')
                              ]))
                        ]),
                    pw.SizedBox(height: 10),
                    pw.Center(
                        child: pw.Text(companyProvider.company!.sign ?? '',
                            style: pw.TextStyle(
                                fontSize: 40, fontWeight: pw.FontWeight.bold)))
                  ]),
            )); // Center
      }));

  // Save the PDF to a file
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/receipt.pdf");
  await file.writeAsBytes(await pdf.save());

  // Open the PDF using the default viewer
  return file;
}
