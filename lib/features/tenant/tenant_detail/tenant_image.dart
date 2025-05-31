import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/services/tenant_api_service.dart';
import 'package:residenza/view_models/room_view_model.dart';

class TenantImage extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantImage({required this.tenant, super.key});
  final dynamic tenant;

  @override
  State<TenantImage> createState() => _TenantImageState();
}

class _TenantImageState extends State<TenantImage> with GetItStateMixin {
  XFile? _imageDevice;
  Uint8List? _imageWeb;

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
                ? Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Image.network(
                    ApplicationInfo.baseUrl + widget.tenant['NIKImagePath'],
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
            child: Center(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    _imageDevice = await TenantApiService().pickImageMobile(
                      ImageSource.camera,
                    );
                    setState(() {});
                    await _submit();
                  },
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
                    _imageDevice = await TenantApiService().pickImageMobile(
                      ImageSource.gallery,
                    );
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
