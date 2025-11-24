// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/calendar_with_sunday.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html; // Wasm-safe

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
  return DateFormat('dd MMMM yyyy HH:mm:ss', "id").format(date.toLocal());
}

String formatDateFromYearToDay(DateTime? date) {
  if (date != null) {
    return DateFormat('dd MMMM yyyy', "id").format(date.toLocal());
  } else {
    return " -";
  }
}

String getYesOrNo(bool condition) {
  return condition ? 'Yes' : 'No';
}

String formatDateString(String? dateTimeString) {
  String result = " -";
  if (dateTimeString != null) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy');
    result = formatter.format(dateTime);
  }
  return result;
}

String formatDateMinuteString(String? dateTimeString) {
  String result = " -";
  if (dateTimeString != null) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy, HH:mm', 'id_ID');
    result = formatter.format(dateTime);
  }
  return result;
}

String formatHariDateString(String? dateTimeString) {
  String result = " -";
  if (dateTimeString != null) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    result = formatter.format(dateTime);
  }
  return result;
}

String formatHariTglBulThnDateString(String? dateTimeString) {
  String result = " -";
  if (dateTimeString != null) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('EEEE, d MMM yyyy', 'id_ID');
    result = formatter.format(dateTime);
  }
  return result;
}

String formatBulanTahun(DateTime? dateTime) {
  String result = " -";
  if (dateTime != null) {
    final formatter = DateFormat('MMMM yyyy', 'id_ID');
    result = formatter.format(dateTime.toLocal());
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
  return await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 450, maxHeight: 500),
          child: CalendarWithRedSunday(),
        ),
      );
    },
  );
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
      _showSnackBar(
        context,
        "Please re-login",
        color: Colors.red.shade400,
        duration: Duration(seconds: 2),
      );
      model.isNoSession = false;
      Navigator.pushNamed(context, signInRoute);
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
      return 'Bayar sebagian';
    default:
      return status;
  }
}

Future<void> saveImage(
  BuildContext context,
  Uint8List bytes,
  String name,
  String format,
) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = '${name}_$timestamp.$format';

  if (kIsWeb) {
    try {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image download started')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download not supported in this environment'),
        ),
      );
    }
  }
}

Future<void> downloadImageAndClosePopup(
  BuildContext dialogContext,
  String imageUrl,
  String name,
) async {
  // setState(() {
  //   isDownloading = true;
  // });
  final response = await http.get(Uri.parse(imageUrl));
  // if (response.statusCode == 200) {
  //   setState(() {
  //     imageData = response.bodyBytes;
  //     isDownloading = false;
  //   });
  await saveImage(dialogContext, response.bodyBytes, name, 'jpg');
  Navigator.of(dialogContext).pop();
}

void showPopup(
  BuildContext context,
  Uint8List? imageData,
  String imageUrl,
  String name,
  bool isMobile,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.black87,
        child: SizedBox(
          width: isMobile ? null : MediaQuery.of(context).size.width / 2,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child:
                    imageData != null
                        ? Image.memory(
                          imageData,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        )
                        : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.download, color: Colors.blue.shade700),
                      onPressed:
                          () => downloadImageAndClosePopup(
                            dialogContext,
                            imageUrl,
                            name,
                          ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.blue.shade700),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
