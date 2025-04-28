import 'dart:math';

import 'package:flutter/material.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:intl/intl.dart';

String generateRandomValueKey() {
  var random = Random();
  var randomValueKey = random.nextInt(999999).toString();
  return randomValueKey;
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  if (text.length == 1) return text.toUpperCase();
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String formatDateFromYearToSecond(DateTime date) {
  return DateFormat('dd MMMM yyyy HH:mm:ss', "id").format(date);
}

String formatDateFromYearToDay(DateTime date) {
  return DateFormat('dd MMMM yyyy', "id").format(date);
}

String getYesOrNo(bool condition) {
  return condition ? 'Yes' : 'No';
}

String formatDateString(String? dateTimeString) {
  String result = " -";
  if (dateTimeString != null) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat('dd-MM-yyyy');
    result = formatter.format(dateTime);
  }
  return result;
}

String formatDateMinuteString(String? dateTimeString) {
  String result = " -";
  if (dateTimeString != null) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat('dd-MM-yyyy, HH:mm', 'id_ID');
    result = formatter.format(dateTime);
  }
  return result;
}

String formatHariDateString(String? dateTimeString) {
  String result = " -";
  if (dateTimeString != null) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    result = formatter.format(dateTime);
  }
  return result;
}

String formatCurrency(num number) {
  // Floor rounding the number
  int roundedNumber = number.floor();

  // Create a NumberFormat for Indonesian Rupiah
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0, // No decimal digits
  );

  // Format the rounded number
  return currencyFormatter.format(roundedNumber);
}

String generateDateString(DateTime time) {
  return time.toIso8601String();
  // final formatter = DateFormat('yyyy-MM-dd');
  // return formatter.format(time);
}

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
}) async {
  DateTime? selectedDate;

  await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        child: CalendarDatePicker(
          initialDate: initialDate, // DateTime.now(),
          firstDate: firstDate, //DateTime(1900),
          lastDate: DateTime(3000),
          onDateChanged: (DateTime date) {
            selectedDate = date;
            Navigator.of(context).pop(date); // Close and return date
          },
        ),
      );
    },
  );

  return selectedDate;
}

Color generateRoomStatusColor({required String? roomSatus}) {
  // 'Tersedia', 'Terisi', 'Dipesan', 'Pemeliharaan', 'Rusak'
  switch (roomSatus) {
    case 'Tersedia':
      return Colors.green;
    case 'Terisi':
      return Colors.deepPurpleAccent.shade700;
    case 'Dipesan':
      return Colors.blue;
    case 'Pemeliharaan':
      return Colors.amber;
    case 'Rusak':
      return Colors.red;
    default:
      return Colors.black;
  }
}

void snackbarGenerator(BuildContext context, RoomViewModel model) {
  return WidgetsBinding.instance.addPostFrameCallback((_) {
    if (model.isNoSession) {
      Navigator.pushNamed(context, signInRoute);
      model.isNoSession = false;
    } else if (model.isError == true) {
      _showSnackBar(
        context,
        model.errorMessage ?? "Error",
        color: Colors.red.shade400,
        duration: Duration(seconds: 2),
      );
      model.isError = null;
      model.errorMessage = null;
    } else if (model.isSuccess) {
      _showSnackBar(
        context,
        model.successMessage ?? "Success",
        color: Colors.green.shade400,
        duration: Duration(seconds: 2),
      );
      model.isSuccess = false;
      model.successMessage = null;
    }
  });
}

// Helper function to show SnackBars
void _showSnackBar(
  BuildContext context,
  String message, {
  Color color = Colors.blue,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: duration,
    ),
  );
}

String invoiceStatusText(String status) {
  // 'Draft', 'Issued', 'Unpaid', 'PartiallyPaid', 'Paid', 'Void'
  switch (status) {
    case 'Paid':
      return 'Lunas';
    case 'Issued':
      return 'Belum dibayar';
    case 'Unpaid':
      return 'Belum dibayar';
    case 'PartiallyPaid':
      return 'Sebagian';
    default:
      return status;
  }
}
