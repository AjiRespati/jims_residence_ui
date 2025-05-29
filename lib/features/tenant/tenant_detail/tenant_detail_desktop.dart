import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/features/payments/components/invoice_card.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_info.dart';
import 'package:residenza/services/tenant_api_service.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/page_container.dart';

class TenantDetailDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantDetailDesktop({super.key});

  @override
  State<TenantDetailDesktop> createState() => _TenantDetailDesktopState();
}

class _TenantDetailDesktopState extends State<TenantDetailDesktop>
    with GetItStateMixin {
  dynamic _tenant;
  XFile? _imageDevice;
  Uint8List? _imageWeb;

  String _name = "";
  String _phone = "";
  String _nik = "";
  String _status = "";
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _submit() async {
    await get<RoomViewModel>().updateTenant(
      tenantId: _tenant['id'],
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

  Future _setup() async {
    await get<RoomViewModel>().fetchTenant();
    setState(() {
      _tenant = get<RoomViewModel>().tenant;
    });

    _name = _tenant['name'];
    _phone = _tenant['phone'];
    _nik = _tenant['NIKNumber'];
    _status = _tenant['tenancyStatus'];

    _startDate =
        _tenant['startDate'] == null
            ? null
            : DateTime.parse(_tenant['startDate']);

    _endDate =
        _tenant['endDate'] == null ? null : DateTime.parse(_tenant['endDate']);

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
      resizeToAvoidBottomInset: true,
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new, size: 25),
                      ),
                      Text(
                        "Detail Penghuni",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (_tenant == null)
                          Center(child: Text("waiting for data...")),
                        if (_tenant != null)
                          Text(
                            "${_tenant['boardingHouseName']} ${_tenant['roomNumber']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        if (_tenant != null)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Column(
                                        children: [
                                          SizedBox(height: 10),
                                          // ✅ Image Preview
                                          (_imageDevice != null ||
                                                  _imageWeb != null)
                                              ? Container(
                                                height: 150,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child:
                                                    kIsWeb
                                                        ? Image.memory(
                                                          _imageWeb!,
                                                        )
                                                        : Image.file(
                                                          File(
                                                            _imageDevice!.path,
                                                          ),
                                                        ),
                                              )
                                              : _tenant?['NIKImagePath'] != null
                                              ? Container(
                                                height: 150,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child: Image.network(
                                                  ApplicationInfo.baseUrl +
                                                      _tenant['NIKImagePath'],
                                                ),
                                              )
                                              : Container(
                                                height: 150,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 100,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        ],
                                      ),

                                      // ✅ Pick Image Buttons
                                      if (kIsWeb) // ✅ Web: File Picker
                                        Expanded(
                                          child: Center(
                                            child: IconButton(
                                              onPressed: () async {
                                                _imageWeb =
                                                    await TenantApiService()
                                                        .pickImageWeb();
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.camera),
                                                onPressed: () async {
                                                  _imageDevice =
                                                      await TenantApiService()
                                                          .pickImageMobile(
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
                                                  _imageDevice =
                                                      await TenantApiService()
                                                          .pickImageMobile(
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
                                  ),

                                  SizedBox(height: 10),
                                  Divider(),
                                  SizedBox(height: 10),

                                  TenantInfo(
                                    id: _tenant['id'],
                                    name: _name,
                                    phone: _phone,
                                    nik: _nik,
                                    status: _status,
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  ),

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
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
