import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:residenza/features/tenant/components/contract_pdf.dart';

class ContractPreviewDialog extends StatelessWidget {
  final Map<String, dynamic> tenant;
  final Map<String, dynamic>? room;

  const ContractPreviewDialog({
    super.key,
    required this.tenant,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    final contractNumber = ContractPdf.buildContractNumber(
      tenant: tenant,
      room: room,
    );
    final fileSafeName =
        'KONTRAK SEWA_${contractNumber.replaceAll('/', '-')}.pdf';

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    "Kontrak Sewa - ${tenant['name'] ?? ''}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const Divider(height: 1),
            Expanded(
              child: PdfPreview(
                maxPageWidth: 640,
                canDebug: false,
                allowPrinting: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                initialPageFormat: PdfPageFormat.a4,
                pdfFileName: fileSafeName,
                loadingWidget: const Center(
                  child: CircularProgressIndicator(),
                ),
                build: (format) => ContractPdf.build(
                  contractNumber: contractNumber,
                  tenant: tenant,
                  room: room,
                  issuedOn: DateTime.now(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
