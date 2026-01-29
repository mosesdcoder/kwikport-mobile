import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:kwik_port/api/model/transaction_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  static final GlobalKey _receiptKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, dd MMM yyyy').format(transaction.createdAt);
    final time = DateFormat('hh:mm a').format(transaction.createdAt);
    final amount = NumberFormat.currency(locale: 'en_NG', symbol: '₦')
        .format(transaction.amount);

    Color statusColor() {
      final s = transaction.paymentStatus.toLowerCase();
      if (s.contains('success')) return colorCodes.mediumSeaGreen;
      if (s.contains('fail') || s.contains('declin')) return Colors.redAccent;
      if (s.contains('pending')) return Colors.orangeAccent;
      return colorCodes.black;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorCodes.white,
        elevation: 0,
        iconTheme: IconThemeData(color: colorCodes.black),
        title: Text(
          'Transaction Details',
          style: kwikTextStlye(16.0, FontWeight.w600, colorCodes.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RepaintBoundary(
              key: _receiptKey,
              child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorCodes.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x0D000000),
                    blurRadius: 20.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Kwiport.png',
                        height: 36,
                        width: 36,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KwikPort',
                            style: kwikTextStlye(16.0, FontWeight.w700, colorCodes.black),
                          ),
                          Text(
                            'Exporting simplified for everyone.',
                            style: kwikTextStlye(11.0, FontWeight.w400, colorCodes.graniteGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Transaction Receipt',
                    style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: colorCodes.whiteSmoke,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Text(
                            '₦',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _paymentTypeLabel(transaction.paymentType),
                              style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction.paymentProvider,
                              style: kwikTextStlye(12.0, FontWeight.w400, colorCodes.graniteGrey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        amount,
                        style: kwikTextStlye(16.0, FontWeight.w600, statusColor()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _kv('Status', transaction.paymentStatus, valueColor: statusColor()),
                  _kv('Reference', transaction.reference),
                  // _kv('Provider Ref', transaction.providerReference),
                  _kv('Currency', transaction.currency),
                  _kv('Date', date),
                  _kv('Time', time),
                ],
              ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorCodes.azureBlue,
                      foregroundColor: colorCodes.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _downloadPdf(context),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Download PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: colorCodes.azureBlue),
                      foregroundColor: colorCodes.azureBlue,
                    ),
                    onPressed: () => _saveAsImage(context),
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Save as Image'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String key, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              key,
              style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.graniteGrey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: kwikTextStlye(12.0, FontWeight.w500, valueColor ?? colorCodes.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _paymentTypeLabel(String backendType) {
    switch (backendType) {
      case 'KwikTicketFunding':
        return 'Kwik Ticket Funding';
      case 'AgencyPayment':
        return 'Agency Payment';
      case 'WalletTopup':
        return 'Wallet Top-up';
      case 'Payout':
        return 'Payout';
      case 'KwikTicketFundingFromWallet':
        return 'Kwik Ticket Funding (Wallet)';
      default:
        return backendType.replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2');
    }
  }

  Future<void> _saveAsImage(BuildContext context) async {
    try {
      final boundary = _receiptKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final uiImage = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final dir = await getDownloadsDirectory();
      final file = File('${dir!.path}/kwikport_receipt_${transaction.reference}.png');
      await file.writeAsBytes(bytes);
      print('Image saved to: ${file.path}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to: ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    }
  }

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final doc = pw.Document();
      // Load logo
      pw.MemoryImage? logoImage;
      try {
        final logoBytes = await rootBundle.load('assets/images/Kwiport.png');
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {}

      final amount = NumberFormat.currency(locale: 'en_NG', symbol: '₦')
          .format(transaction.amount);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context ctx) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header with logo and brand
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      if (logoImage != null)
                        pw.Container(
                          height: 40,
                          width: 40,
                          margin: const pw.EdgeInsets.only(right: 12),
                          child: pw.Image(logoImage),
                        ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('KwikPort',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              )),
                          pw.Text('Exporting simplified for everyone.',
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 16),
                  pw.Divider(),
                  pw.SizedBox(height: 8),

                  pw.Text('Transaction Receipt',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(height: 12),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Payment Type')),
                    pw.Text(_paymentTypeLabel(transaction.paymentType)),
                  ]),
                  pw.SizedBox(height: 6),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Status')),
                    pw.Text(transaction.paymentStatus),
                  ]),
                  pw.SizedBox(height: 6),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Amount')),
                    pw.Text(amount),
                  ]),
                  pw.SizedBox(height: 6),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Currency')),
                    pw.Text(transaction.currency),
                  ]),
                  pw.SizedBox(height: 6),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Reference')),
                    pw.Text(transaction.reference),
                  ]),
                  // pw.SizedBox(height: 6),
                  // pw.Row(children: [
                  //   pw.Expanded(child: pw.Text('Provider Ref')),
                  //   pw.Text(transaction.providerReference),
                  // ]),
                  pw.SizedBox(height: 6),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Date')),
                    pw.Text(DateFormat('EEE, dd MMM yyyy').format(transaction.createdAt)),
                  ]),
                  pw.SizedBox(height: 6),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Time')),
                    pw.Text(DateFormat('hh:mm a').format(transaction.createdAt)),
                  ]),
                ],
              ),
            );
          },
        ),
      );

      final bytes = await doc.save();

      // Save to Downloads folder
      final dir = await getDownloadsDirectory();
      final fileName = 'kwikport_receipt_${transaction.reference}.pdf';
      final file = File('${dir!.path}/$fileName');
      await file.writeAsBytes(bytes);
      print('PDF saved to: ${file.path}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to: ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }
}
