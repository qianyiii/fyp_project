import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class OrderSuccessPage extends StatelessWidget {
  final double totalAmount;
  final int numberOfItems;

  OrderSuccessPage({required this.totalAmount, required this.numberOfItems});

  @override
  Widget build(BuildContext context) {
    // Generate a random invoice number
    String invoiceNumber = '#${DateTime.now().millisecondsSinceEpoch}';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Successful!',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text('Paid: RM $totalAmount'),
            Text('Items: $numberOfItems'),
            Text('Invoice Number: $invoiceNumber'),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Generate and save PDF invoice
                    await generateInvoice(invoiceNumber, totalAmount, numberOfItems);
                  },
                  child: Text('Generate Invoice'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the home page
                    Navigator.pushReplacementNamed(context, 'home');
                  },
                  child: Text('Back to Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateInvoice(String invoiceNumber, double totalAmount, int numberOfItems) async {
    // Get the directory for saving the PDF file
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/invoice.pdf';

    // Create a PDF document
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Invoice Number: $invoiceNumber', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 16),
            pw.Text('Total Amount: RM $totalAmount', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Number of Items: $numberOfItems', style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    // Save the PDF file
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    print('PDF Invoice generated and saved at: $path');
  }
}

