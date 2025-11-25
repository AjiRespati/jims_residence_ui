// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/currency_text_field.dart';

class CreateTransferOwnerContent extends StatefulWidget
    with GetItStatefulWidgetMixin {
  CreateTransferOwnerContent({super.key});

  @override
  State<CreateTransferOwnerContent> createState() =>
      _CreateTransferOwnerContentState();
}

class _CreateTransferOwnerContentState extends State<CreateTransferOwnerContent>
    with GetItStateMixin {
  TextEditingController amountController = TextEditingController();
  String? paymentMethod = "Bank Transfer";
  TextEditingController descriptionController = TextEditingController();
  double amount = 0;
  DateTime? transferDate;

  final ImagePicker _picker = ImagePicker();
  XFile? imageDevice;
  Uint8List? imageWeb;

  // ✅ Pick Image for Mobile
  Future<void> _pickImageMobile(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    setState(() {
      imageDevice = pickedImage;
    });
    // await _submit();
  }

  // ✅ Pick Image for Web
  Future<void> _pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        imageWeb = result.files.first.bytes;
      });
      // await _submit();
    }
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Transfer Ke Pemilik",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 30),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Pilih Kost", isDense: true),
            value: get<RoomViewModel>().roomKostName,
            items:
                get<RoomViewModel>().kosts.map((item) {
                  final isSelected =
                      item['name'] == get<RoomViewModel>().roomKostName;

                  return DropdownMenuItem<String>(
                    value: item['name'],
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
            onChanged: (value) async {
              get<RoomViewModel>().roomKostName = value;
              var item =
                  get<RoomViewModel>().kosts
                      .where((el) => el['name'] == value)
                      .toList()
                      .first;
              get<RoomViewModel>().roomKostId = item['id'];
            },
          ),
          SizedBox(height: 12),
          _buildDatePicker(
            context,
            "Tanggal",
            "Tanggal:  ",
            transferDate,
            (date) {
              setState(() {
                transferDate = date;
              });
            },
            dateTextStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            labelTextStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          CurrencyTextField(
            controller: amountController,
            label: "Jumlah",
            onChanged: (value) => amount = double.parse(value),
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Keterangan"),
            ),
            controller: descriptionController,
          ),
          SizedBox(height: 30),

          // ✅ Image Preview
          (imageDevice != null || imageWeb != null)
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child:
                        kIsWeb
                            ? Image.memory(imageWeb!)
                            : Image.file(File(imageDevice!.path)),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
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
                          child: Icon(Icons.upload, size: 30),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Upload bukti transfer",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          SizedBox(height: 12),
          SizedBox(height: 30),
          SizedBox(
            height: 35,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GradientElevatedButton(
                    elevation: 3,
                    onPressed: () => Navigator.pop(context),
                    child: Text("Kembali"),
                  ),
                  GradientElevatedButton(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    elevation: 3,
                    onPressed: () async {
                      await get<RoomViewModel>().createTransferOwner(
                        amount: amount,
                        transferDate: transferDate,
                        description: descriptionController.text,
                        imageDevice: imageDevice,
                        imageWeb: imageWeb,
                      );

                      if (get<RoomViewModel>().isSuccess) {
                        // await get<RoomViewModel>().getFinancialOverview(
                        //   boardingHouseId: get<RoomViewModel>().roomKostId,
                        //   dateFrom: null,
                        //   dateTo: null,
                        // );
                        await get<RoomViewModel>().getAllTransferOwners(
                          boardingHouseId: get<RoomViewModel>().roomKostId,
                          dateFrom: null,
                          dateTo: null,
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Transfer"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String placeholder,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected, {
    TextStyle? dateTextStyle,
    TextStyle? labelTextStyle,
  }) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.zero,
        ),
        onPressed: () async {
          DateTime? pickedDate = await showCustomDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
          );
          // );
          if (pickedDate != null) onDateSelected(pickedDate);
        },
        child: Row(
          children: [
            Text(
              " ${(selectedDate == null) ? placeholder : label}",
              style: labelTextStyle,
            ),
            Text(
              (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
              style: dateTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
