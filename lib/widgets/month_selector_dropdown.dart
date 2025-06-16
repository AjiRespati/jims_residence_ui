import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelectorDropdown extends StatefulWidget {
  const MonthSelectorDropdown({
    required this.selectedMonth,
    required this.onMonthSelected,
    super.key,
  });

  final DateTime? selectedMonth;
  final Function(DateTime dateFrom, DateTime dateTo) onMonthSelected;

  @override
  State<MonthSelectorDropdown> createState() => _MonthSelectorDropdownState();
}

class _MonthSelectorDropdownState extends State<MonthSelectorDropdown> {
  late List<DateTime> availableMonths;
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    _generateMonths();
  }

  void _generateMonths() {
    final now = DateTime.now();
    selectedMonth =
        widget.selectedMonth != null
            ? (DateTime(
              widget.selectedMonth!.year,
              widget.selectedMonth!.month,
            ))
            : DateTime(now.year, now.month);

    availableMonths = [];

    // Generate 13 months before
    for (int i = 13; i > 0; i--) {
      final date = DateTime(now.year, now.month - i);
      availableMonths.add(date);
    }

    // Add current month
    availableMonths.add(DateTime(now.year, now.month));

    // Generate 3 months after
    for (int i = 1; i <= 2; i++) {
      final date = DateTime(now.year, now.month + i);
      availableMonths.add(date);
    }
    availableMonths = availableMonths.reversed.toList();
  }

  void _notifyParent() {
    final dateFrom = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final dateTo = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    widget.onMonthSelected(dateFrom, dateTo);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DateTime>(
      decoration: InputDecoration(labelText: "Periode", isDense: true),
      value: selectedMonth,
      items:
          availableMonths.map((date) {
            final formatted = DateFormat('MMMM yyyy').format(date);
            final isSelected =
                date.year == selectedMonth.year &&
                date.month == selectedMonth.month;

            return DropdownMenuItem<DateTime>(
              value: date,
              child: Text(
                formatted,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
      onChanged: (DateTime? newValue) {
        if (newValue != null) {
          setState(() {
            selectedMonth = newValue;
            _notifyParent();
          });
        }
      },
      menuMaxHeight: 300,
    );
  }
}
