// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/currency_text_field.dart';

class CreateOtherCostContent extends StatefulWidget
    with GetItStatefulWidgetMixin {
  CreateOtherCostContent({required this.roomId, super.key});

  final String roomId;

  @override
  State<CreateOtherCostContent> createState() => _CreateOtherCostContentState();
}

class _CreateOtherCostContentState extends State<CreateOtherCostContent>
    with GetItStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? paymentMethod = "Bank Transfer";
  TextEditingController descriptionController = TextEditingController();
  double amount = 0;
  bool isOneTime = true;
  DateTime? invoiceIssueDate;
  DateTime? invoiceDueDate;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
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
                "Biaya Lain",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 30),

          Column(
            children: [
              Row(
                children: [
                  if (invoiceIssueDate != null)
                    Text("Tanggal Penagihan", style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: _buildDatePicker(
                      context,
                      "Tanggal Penagihan",
                      "",
                      invoiceIssueDate,
                      (date) {
                        invoiceIssueDate = date;
                        setState(() {
                          invoiceIssueDate = date;
                        });
                      },
                      dateTextStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      labelTextStyle: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),

          SizedBox(height: 15),

          Column(
            children: [
              Row(
                children: [
                  if (invoiceDueDate != null)
                    Text(
                      "Batas Waktu Pembayaran",
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: _buildDatePicker(
                      context,
                      "Batas Waktu Pembayaran",
                      "",
                      invoiceDueDate,
                      (date) {
                        invoiceDueDate = date;
                        setState(() {
                          invoiceDueDate = date;
                        });
                      },
                      dateTextStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      labelTextStyle: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),
          CurrencyTextField(
            controller: amountController,
            label: "Jumlah",
            onChanged: (value) => amount = double.parse(value),
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Untuk Pembayaran"),
            ),
            keyboardType: TextInputType.name,
            controller: nameController,
          ),
          SizedBox(height: 12),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Keterangan"),
            ),
            controller: descriptionController,
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
                      await get<RoomViewModel>().createOtherCost(
                        roomId: widget.roomId,
                        name: nameController.text,
                        amount: amount,
                        description: descriptionController.text,
                        isOneTime: isOneTime,
                        invoiceIssueDate: invoiceIssueDate,
                        invoiceDueDate: invoiceDueDate,
                      );

                      if (get<RoomViewModel>().isSuccess) {
                        await get<RoomViewModel>().fetchTenant();
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Bayar"),
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
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
              selectedDate == null ? placeholder : label,
              style: labelTextStyle,
            ),
            Text(
              selectedDate == null ? "" : formatDateFromYearToDay(selectedDate),
              // (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
              style: dateTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
