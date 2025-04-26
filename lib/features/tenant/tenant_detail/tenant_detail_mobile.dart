// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
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

  void _submit() async {
    await get<RoomViewModel>().updateTenant(
      tenantId: _tenant['id'],
      imageWeb: _imageWeb,
      imageDevice: _imageDevice,
    );
    Navigator.pushNamed(context, tenantRoute);
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
                        _tenant['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        _tenant['boardingHouseName'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
                                _imageDevice = await ApiService()
                                    .pickImageMobile(ImageSource.camera);
                                setState(() {});
                              },
                            ),
                          if (!kIsWeb) SizedBox(width: 10),
                          if (!kIsWeb)
                            ElevatedButton.icon(
                              icon: Icon(Icons.photo),
                              label: Text("Gallery"),
                              onPressed: () async {
                                _imageDevice = await ApiService()
                                    .pickImageMobile(ImageSource.gallery);
                                setState(() {});
                              },
                              // () => _pickImageMobile(ImageSource.gallery),
                            ),
                          if (kIsWeb) // ✅ Web: File Picker
                            GradientElevatedButton(
                              onPressed: () async {
                                _imageWeb = await ApiService().pickImageWeb();
                                setState(() {});
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

                      //TODO: TENANT PAYMENTS LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _tenant?['Invoices'].length,
                        itemBuilder: (context, index) {
                          final item = _tenant['Invoices'][index];
                          return Card(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Tanggal: "),
                                    Text(formatDateString(item['issueDate'])),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Total: "),
                                    Text(
                                      formatCurrency(item['totalAmountDue']),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: item?['Charges'].length,
                                  itemBuilder: (context, index) {
                                    final item0 = item['Charges'][index];
                                    return Row(
                                      children: [
                                        SizedBox(width: 20),
                                        Text(item0['name'] + ": "),
                                        Text(formatCurrency(item0['amount'])),
                                      ],
                                    );
                                  },
                                ),
                                Row(
                                  children: [
                                    Text("Batas pembayaran: "),
                                    Text(formatDateString(item['dueDate'])),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Jumlah terbayar: "),
                                    Text(
                                      formatCurrency(item['totalAmountPaid']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // TextField(
                      //   controller: _nameController,
                      //   decoration: InputDecoration(labelText: "Name"),
                      // ),
                      // SizedBox(height: 4),
                      // TextField(
                      //   controller: _descriptionController,
                      //   decoration: InputDecoration(labelText: "Description"),
                      // ),
                      // SizedBox(height: 4),
                      // TextField(
                      //   controller: _priceController,
                      //   decoration: InputDecoration(labelText: "Price"),
                      //   keyboardType: TextInputType.number,
                      // ),
                      // SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 30),
            GradientElevatedButton(
              onPressed: _submit,
              child: Text(
                "Update Tenant",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
