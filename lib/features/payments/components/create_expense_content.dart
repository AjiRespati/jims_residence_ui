// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/currency_text_field.dart';

class CreateExpenseContent extends StatefulWidget
    with GetItStatefulWidgetMixin {
  CreateExpenseContent({super.key});

  @override
  State<CreateExpenseContent> createState() => _CreateExpenseContentState();
}

class _CreateExpenseContentState extends State<CreateExpenseContent>
    with GetItStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? paymentMethod = "Bank Transfer";
  TextEditingController descriptionController = TextEditingController();
  double amount = 0;
  DateTime? expenseDate;

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
                "Pengeluaran",
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
            expenseDate,
            (date) {
              // get<RoomViewModel>().tenantStartDate = date;
              setState(() {
                expenseDate = date;
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
              label: Text("Untuk Pembayaran"),
            ),
            keyboardType: TextInputType.name,
            controller: nameController,
            // onChanged: (value) => get<RoomViewModel>().tenantName = value,
          ),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Metode Pembayaran"),
            ),
            value: paymentMethod,
            items:
                ['Bank Transfer', 'Online Payment', 'Cash', 'Other'].map((
                  item,
                ) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              paymentMethod = value ?? "Bank Transfer";
              setState(() {});
            },
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Keterangan"),
            ),
            keyboardType: TextInputType.number,
            controller: descriptionController,
            // onChanged: (value) => get<RoomViewModel>().tenantIdNumber = value,
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
                      await get<RoomViewModel>().createExpense(
                        category: null,
                        name: nameController.text,
                        amount: amount,
                        expenseDate: expenseDate,
                        paymentMethod: paymentMethod,
                        description: descriptionController.text,
                      );
                      Navigator.pop(context);

                      if (get<RoomViewModel>().isSuccess) {}

                      // get<RoomViewModel>().transactionAmount =
                      //     double.parse(_rawValue);
                      // get<RoomViewModel>().tenantId =
                      //     widget.item['Tenant']['id'];
                      // await get<RoomViewModel>()
                      //     .recordTransaction();
                      // _amountController.text = "";
                      // _rawValue = "";
                      // Navigator.pushNamed(
                      //   context,
                      //   tenantDetailRoute,
                      // );
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
              selectedDate == null ? placeholder : label,
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
