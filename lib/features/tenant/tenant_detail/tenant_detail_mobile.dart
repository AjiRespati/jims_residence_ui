// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/features/payments/components/invoice_card.dart';
import 'package:residenza/services/tenant_api_service.dart';
// import 'package:residenza/services/api_service.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';

class TenantDetailMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantDetailMobile({super.key});

  @override
  State<TenantDetailMobile> createState() => _TenantDetailMobileState();
}

class _TenantDetailMobileState extends State<TenantDetailMobile>
    with GetItStateMixin {
  dynamic _tenant;
  XFile? _imageDevice;
  Uint8List? _imageWeb;

  Future<void> _submit() async {
    await get<RoomViewModel>().updateTenant(
      tenantId: _tenant['id'],
      imageWeb: _imageWeb,
      imageDevice: _imageDevice,
    );
    // Navigator.pushNamed(context, tenantRoute);
  }

  Future _setup() async {
    await get<RoomViewModel>().fetchTenant();
    _tenant = get<RoomViewModel>().tenant;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tenant Detail")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (_tenant == null)
              Center(child: Text("waiting for data..."))
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        _tenant?['name'] ?? "-",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        _tenant['boardingHouseName'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _tenant['roomNumber'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      // ✅ Image Preview
                      (_imageDevice != null || _imageWeb != null)
                          ? Container(
                            height: 150,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child:
                                kIsWeb
                                    ? Image.memory(_imageWeb!)
                                    : Image.file(File(_imageDevice!.path)),
                          )
                          : _tenant?['NIKImagePath'] != null
                          ? Container(
                            height: 150,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Image.network(
                              ApplicationInfo.baseUrl + _tenant['NIKImagePath'],
                            ),
                          )
                          : Container(
                            height: 150,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),

                      SizedBox(height: 10),

                      // ✅ Pick Image Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!kIsWeb) // ✅ Mobile: Camera & Gallery
                            ElevatedButton.icon(
                              icon: Icon(Icons.camera),
                              label: Text("Camera"),
                              onPressed: () async {
                                _imageDevice = await TenantApiService()
                                    .pickImageMobile(ImageSource.camera);
                                setState(() {});
                                await _submit();
                              },
                            ),
                          if (!kIsWeb) SizedBox(width: 10),
                          if (!kIsWeb)
                            ElevatedButton.icon(
                              icon: Icon(Icons.photo),
                              label: Text("Gallery"),
                              onPressed: () async {
                                _imageDevice = await TenantApiService()
                                    .pickImageMobile(ImageSource.gallery);
                                setState(() {});
                                await _submit();
                              },
                              // () => _pickImageMobile(ImageSource.gallery),
                            ),
                          if (kIsWeb) // ✅ Web: File Picker
                            GradientElevatedButton(
                              onPressed: () async {
                                _imageWeb =
                                    await TenantApiService().pickImageWeb();
                                setState(() {});
                                await _submit();
                              },
                              buttonHeight: 30,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green,
                                  Colors.green[800] ?? Colors.greenAccent,
                                ],
                              ),
                              // inactiveDelay: Duration.zero,
                              child: Text(
                                "Ambil Image",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(),

                      SizedBox(height: 10),
                      Text(
                        "Daftar Tagihan",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),

                      //TODO: TENANT PAYMENTS LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _tenant?['Invoices'].length,
                        itemBuilder: (context, index) {
                          final item = _tenant['Invoices'][index];
                          item['Tenant'] = {'id': _tenant['id']};
                          return InvoiceCard(item: item);
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: MobileNavbar(selectedindex: 2),
    );
  }
}
