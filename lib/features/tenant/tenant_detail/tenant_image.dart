import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/services/tenant_api_service.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:universal_html/html.dart' as html;

class TenantImage extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantImage({required this.tenant, super.key});
  final dynamic tenant;

  @override
  State<TenantImage> createState() => _TenantImageState();
}

class _TenantImageState extends State<TenantImage> with GetItStateMixin {
  XFile? _imageDevice;
  Uint8List? _imageWeb;
  String format = 'jpg';
  Uint8List? imageData;
  bool isDownloading = false;

  Future<void> saveImage(Uint8List bytes, String name) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${name}_$timestamp.$format';

    if (kIsWeb) {
      try {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image download started')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download not supported in this environment'),
          ),
        );
      }
    }
    //  else {
    //   final status = await Permission.storage.request();
    //   if (status.isGranted) {
    //     final downloads = Directory('/storage/emulated/0/Download');
    //     final file = File('${downloads.path}/$fileName');
    //     await file.writeAsBytes(bytes);
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(SnackBar(content: Text('Image saved as $fileName')));
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Storage permission denied')),
    //     );
    //   }
    // }
  }

  Future<void> downloadImageAndClosePopup(
    BuildContext dialogContext,
    String imageUrl,
    String name,
  ) async {
    Navigator.of(dialogContext).pop();
    setState(() {
      isDownloading = true;
    });
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      setState(() {
        imageData = response.bodyBytes;
        isDownloading = false;
      });
      await saveImage(response.bodyBytes, name);
    }
  }

  void showPopup(BuildContext context, String imageUrl, String name) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.black87,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child:
                    imageData != null
                        ? Image.memory(
                          imageData!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        )
                        : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.download, color: Colors.blue.shade700),
                      onPressed:
                          () => downloadImageAndClosePopup(
                            dialogContext,
                            imageUrl,
                            name,
                          ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.blue.shade700),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    await get<RoomViewModel>().updateTenant(
      tenantId: widget.tenant['id'],
      name: null,
      phone: null,
      nik: null,
      status: null,
      startDate: null,
      endDate: null,
      imageWeb: _imageWeb,
      imageDevice: _imageDevice,
    );
    // Navigator.pushNamed(context, tenantRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Column(
          children: [
            SizedBox(height: 10),
            // ✅ Image Preview
            (_imageDevice != null || _imageWeb != null)
                ? Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child:
                      kIsWeb
                          ? Image.memory(_imageWeb!)
                          : Image.file(File(_imageDevice!.path)),
                )
                : widget.tenant?['NIKImagePath'] != null
                ? GestureDetector(
                  onTap:
                      () => showPopup(
                        context,
                        ApplicationInfo.baseUrl + widget.tenant['NIKImagePath'],
                        "${widget.tenant['name']}",
                      ),
                  child: Container(
                    height: 120,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.network(
                      ApplicationInfo.baseUrl + widget.tenant['NIKImagePath'],
                    ),
                  ),
                )
                : Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                ),
          ],
        ),

        // ✅ Pick Image Buttons
        if (kIsWeb) // ✅ Web: File Picker
          Expanded(
            child:
                (widget.tenant['tenancyStatus'] == 'Inactive')
                    ? SizedBox()
                    : Center(
                      child: IconButton(
                        onPressed: () async {
                          _imageWeb = await TenantApiService().pickImageWeb();
                          setState(() {});
                          await _submit();
                        },
                        icon: Icon(
                          Icons.cloud_upload_outlined,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ),
          ),
        if (!kIsWeb) // ✅ Mobile: Camera & Gallery
          Expanded(
            child:
                (widget.tenant['tenancyStatus'] == 'Inactive')
                    ? SizedBox()
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: () async {
                            _imageDevice = await TenantApiService()
                                .pickImageMobile(ImageSource.camera);
                            setState(() {});
                            await _submit();
                          },
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: () async {
                            _imageDevice = await TenantApiService()
                                .pickImageMobile(ImageSource.gallery);
                            setState(() {});
                            await _submit();
                          },
                        ),
                      ],
                    ),
          ),
      ],
    );
  }
}
