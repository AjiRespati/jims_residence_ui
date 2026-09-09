import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/services/tenant_api_service.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TenantContractImage extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantContractImage({required this.tenant, required this.isMobile, super.key});
  final dynamic tenant;
  final bool isMobile;

  @override
  State<TenantContractImage> createState() => _TenantContractImageState();
}

class _TenantContractImageState extends State<TenantContractImage>
    with GetItStateMixin {
  bool _isUploading = false;

  Future<void> _submit() async {
    setState(() => _isUploading = true);
    await get<RoomViewModel>().fetchTenant();
    setState(() => _isUploading = false);
  }

  Future<void> _pickAndUpload() async {
    Uint8List? webBytes;
    dynamic deviceFile;
    if (kIsWeb) {
      webBytes = await TenantApiService().pickPdfWeb();
      if (webBytes == null) return;
    } else {
      deviceFile = await TenantApiService().pickPdfMobile();
      if (deviceFile == null) return;
    }
    await get<RoomViewModel>().updateTenant(
      tenantId: widget.tenant['id'],
      name: null,
      phone: null,
      nik: null,
      status: null,
      checkinDate: null,
      startDate: null,
      endDate: null,
      imageWeb: null,
      imageDevice: null,
      contractImageWeb: webBytes,
      contractImageDevice: deviceFile,
    );
    await _submit();
  }

  Future<void> _openContract() async {
    final path = widget.tenant['contractImagePath'];
    if (path == null) return;
    final url = '${ApplicationInfo.baseUrl}$path';

    if (kIsWeb) {
      await launchUrl(Uri.parse(url));
      return;
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return;
      final dir = await getTemporaryDirectory();
      final name = path.split('/').last;
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(response.bodyBytes);
      await launchUrl(Uri.file(file.path));
    } catch (_) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasContract = widget.tenant?['contractImagePath'] != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kontrak Sewa (signed PDF)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (hasContract)
                      InkWell(
                        onTap: _openContract,
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "${widget.tenant['name']} - kontrak.pdf",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.tenant['tenancyStatus'] != 'Inactive')
                _isUploading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        tooltip: "Upload PDF Kontrak",
                        onPressed: _pickAndUpload,
                        icon: Icon(
                          Icons.upload_file,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
            ],
          ),
        ],
      ),
    );
  }
}
