import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/features/tenant/components/contract_pdf.dart';
import 'package:residenza/services/tenant_api_service.dart';
import 'package:residenza/utils/share_url.dart';

class ContractPreviewDialog extends StatefulWidget {
  final Map<String, dynamic> tenant;
  final Map<String, dynamic>? room;

  const ContractPreviewDialog({
    super.key,
    required this.tenant,
    this.room,
  });

  @override
  State<ContractPreviewDialog> createState() => _ContractPreviewDialogState();
}

class _ContractPreviewDialogState extends State<ContractPreviewDialog> {
  bool _sharing = false;

  Future<void> _share(
    BuildContext _,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final bytes = await build(pageFormat);
      final contractNumber = ContractPdf.buildContractNumber(
        tenant: widget.tenant,
        room: widget.room,
      );
      final fileSafeName =
          'KONTRAK SEWA_${contractNumber.replaceAll('/', '-')}.pdf';
      final path = await TenantApiService().uploadContractPdf(
        bytesWeb: bytes,
        fileDevice: null,
        filename: fileSafeName,
      );
      if (path == null) throw Exception('Upload returned no path');
      final url = '${ApplicationInfo.baseUrl}$path';
      final result = await shareUrl(url, subject: 'Kontrak Sewa');
      if (!mounted) return;
      switch (result) {
        case ShareUrlResult.copied:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Link kontrak disalin ke clipboard')),
          );
        case ShareUrlResult.failed:
          await _showLinkDialog(context, url);
        case ShareUrlResult.shared:
          break;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membagikan: $e')),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _download(
    BuildContext _,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    try {
      final bytes = await build(pageFormat);
      final contractNumber = ContractPdf.buildContractNumber(
        tenant: widget.tenant,
        room: widget.room,
      );
      final fileSafeName =
          'KONTRAK SEWA_${contractNumber.replaceAll('/', '-')}.pdf';
      await Printing.sharePdf(bytes: bytes, filename: fileSafeName);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunduh: $e')),
      );
    }
  }

  Future<void> _showLinkDialog(BuildContext context, String url) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Link Kontrak Sewa'),
        content: SelectableText(url),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () async {
              final ok = await copyToClipboard(url);
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? 'Link disalin ke clipboard'
                        : 'Gagal menyalin link'),
                  ),
                );
              }
            },
            child: const Text('Salin'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contractNumber = ContractPdf.buildContractNumber(
      tenant: widget.tenant,
      room: widget.room,
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
                    "Kontrak Sewa - ${widget.tenant['name'] ?? ''}",
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
                allowSharing: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                initialPageFormat: PdfPageFormat.a4,
                pdfFileName: fileSafeName,
                loadingWidget: const Center(
                  child: CircularProgressIndicator(),
                ),
                actions: [
                  PdfPreviewAction(
                    icon: _sharing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.share),
                    onPressed: _share,
                  ),
                  PdfPreviewAction(
                    icon: const Icon(Icons.download),
                    onPressed: _download,
                  ),
                ],
                build: (format) => ContractPdf.build(
                  contractNumber: contractNumber,
                  tenant: widget.tenant,
                  room: widget.room,
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
