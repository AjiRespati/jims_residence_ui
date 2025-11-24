import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/features/payments/components/invoice_payment.dart';
// import 'package:residenza/features/payments/components/invoice_void.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/view_models/system_view_model.dart';

class InvoiceCard extends StatefulWidget with GetItStatefulWidgetMixin {
  InvoiceCard({super.key, required this.item, required this.isMobile});

  final dynamic item;
  final bool isMobile;

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> with GetItStateMixin {
  XFile? _imageMobile;
  Uint8List? _imageWeb;
  final ImagePicker _picker = ImagePicker();
  String format = 'jpg';
  Uint8List? imageData;
  bool isDownloading = false;

  Future<void> _submit() async {
    await get<RoomViewModel>().uploadInvoiceProof(
      invoiceId: widget.item['id'],
      imageWeb: _imageWeb,
      imageDevice: _imageMobile,
    );
    // Navigator.pushNamed(context, tenantRoute);
  }

  // ✅ Pick Image for Mobile
  Future<void> _pickImageMobile(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    setState(() {
      _imageMobile = pickedImage;
    });
    await _submit();
  }

  // ✅ Pick Image for Web
  Future<void> _pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _imageWeb = result.files.first.bytes;
      });
      await _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    int level = get<SystemViewModel>().level;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                /// SISI KIRI
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.item?['Charges'].length,
                        itemBuilder: (context, index) {
                          final item0 = widget.item['Charges'][index];
                          return Row(
                            children: [
                              Text(item0['name'] + ": "),
                              Text(formatCurrency(item0['amount'])),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Jatuh Tempo: "),
                          Text(
                            formatHariTglBulThnDateString(
                              widget.item['dueDate'],
                            ),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Jumlah terbayar: "),
                          Text(
                            formatCurrency(widget.item['totalAmountPaid']),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// SISI KANAN
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        invoiceStatusText(widget.item["status"]),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: _generateColor(widget.item['status']),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Divider(),
                      SizedBox(height: 5),
                      if ((widget.item["status"] != 'Paid') &&
                          (widget.item['invoicePaymentProofPath'] == null))
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: ElevatedButton(
                            onPressed:
                                () =>
                                    kIsWeb
                                        ? _pickImageWeb()
                                        : _pickImageMobile(ImageSource.gallery),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(0), // Adjust size
                              elevation: 2, // Optional: change elevation
                              backgroundColor:
                                  Colors.amber.shade400, // Button color
                              foregroundColor: Colors.white, // Icon color
                            ),
                            child: Icon(Icons.upload, size: 20),
                          ),
                        ),
                      // SizedBox(height: 3),
                      if ((widget.item["status"] != 'Paid') &&
                          (widget.item['invoicePaymentProofPath'] == null))
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Upload bukti bayar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              color: Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      SizedBox(height: 3),
                      if ((widget.item["status"] != 'Paid') &&
                          (widget.item['invoicePaymentProofPath'] == null))
                        Divider(),

                      if (widget.item['invoicePaymentProofPath'] != null)
                        GestureDetector(
                          onTap:
                              () => showPopup(
                                context,
                                null,
                                ApplicationInfo.baseUrl +
                                    widget.item['invoicePaymentProofPath'],
                                "${widget.item['Tenant']['name']}",
                                widget.isMobile,
                              ),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Image.network(
                              ApplicationInfo.baseUrl +
                                  widget.item['invoicePaymentProofPath'],
                            ),
                          ),
                        ),

                      // Admin melakukan konfirmasi pembayaran
                      if ((widget.item['totalAmountPaid'] <
                              widget.item['totalAmountDue']) &&
                          level > 0)
                        ElevatedButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  child: SingleChildScrollView(
                                    child: InvoicePayment(item: widget.item),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5), // Adjust size
                            elevation: 4, // Optional: change elevation
                            backgroundColor:
                                Colors.amber.shade400, // Button color
                            foregroundColor: Colors.white, // Icon color
                          ),
                          child: Icon(
                            Icons.currency_exchange,
                          ), // Your desired icon
                        ),

                      if ((widget.item['totalAmountPaid'] <
                              widget.item['totalAmountDue']) &&
                          level > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "Konfirmasi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              color: Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      if (widget.item['totalAmountPaid'] >=
                          widget.item['totalAmountDue'])
                        Icon(Icons.check, color: Colors.green, size: 30),
                    ],
                  ),
                ),
              ],
            ),

            /// TOTAL STACK
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Total:  "),
                Text(
                  formatCurrency(widget.item['totalAmountDue']),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.blue.shade600,
                  ),
                ),
                Spacer(),
                if (widget.item['Transactions'].isNotEmpty)
                  Text(
                    formatHariTglBulThnDateString(
                      widget.item['Transactions'].last['transactionDate'],
                    ),
                    // formatHariDateString(item['issueDate']),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
              ],
            ),

            // /// VOID TRANSACTION
            // if ((widget.item['totalAmountPaid'] <
            //         widget.item['totalAmountDue']) &&
            //     level > 1)
            //   SizedBox(
            //     height: 200,
            //     child: Column(
            //       children: [
            //         Expanded(child: SizedBox()),
            //         Row(
            //           children: [
            //             Text(
            //               "Void this invoice!",
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.red,
            //               ),
            //             ),
            //             IconButton(
            //               onPressed: () async {
            //                 await showModalBottomSheet(
            //                   isScrollControlled: true,
            //                   context: context,
            //                   builder: (context) {
            //                     return Padding(
            //                       padding: EdgeInsets.only(
            //                         bottom:
            //                             MediaQuery.of(
            //                               context,
            //                             ).viewInsets.bottom,
            //                       ),
            //                       child: SingleChildScrollView(
            //                         child: InvoiceVoid(item: widget.item),
            //                       ),
            //                     );
            //                   },
            //                 );
            //               },
            //               icon: Icon(Icons.delete),
            //               color: Colors.red,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

/// 'Draft', 'Issued', 'Unpaid', 'PartiallyPaid', 'Paid', 'Void'
Color _generateColor(String status) {
  switch (status) {
    case "Issued":
      return Colors.amber.shade800;
    case "PartiallyPaid":
      return Colors.amber.shade800;
    case "Paid":
      return Colors.green.shade700;
    default:
      return Colors.red.shade600;
  }
}
