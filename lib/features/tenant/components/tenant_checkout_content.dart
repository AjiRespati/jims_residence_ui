// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';

class TenantCheckoutContent extends StatefulWidget
    with GetItStatefulWidgetMixin {
  TenantCheckoutContent({
    required this.tenantId,
    required this.name,
    required this.boardingHouseName,
    super.key,
  });

  final String tenantId;
  final String name;
  final String boardingHouseName;

  @override
  State<TenantCheckoutContent> createState() => _TenantCheckoutContentState();
}

class _TenantCheckoutContentState extends State<TenantCheckoutContent>
    with GetItStateMixin {
  DateTime? _checkoutDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12),
          Text(
            "Checkout",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Text(
            "Apakah ${widget.name} akan keluar dari kost ${widget.boardingHouseName} ?",
          ),

          SizedBox(height: 15),

          Column(
            children: [
              Row(
                children: [
                  if (_checkoutDate != null)
                    Text("Tanggal keluar", style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: _buildDatePicker(
                      context,
                      "Tanggal keluar",
                      "",
                      _checkoutDate,
                      (date) {
                        _checkoutDate = date;
                        setState(() {
                          _checkoutDate = date;
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
              SizedBox(height: 26),
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
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade800,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        elevation: 3,
                        onPressed: () async {
                          await get<RoomViewModel>().checkoutTenant(
                            id: widget.tenantId,
                            checkoutDate: _checkoutDate,
                          );
                          Navigator.pop(context);
                        },
                        child: Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),

          SizedBox(height: 16),
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
