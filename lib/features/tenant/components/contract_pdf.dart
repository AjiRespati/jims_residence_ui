import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const _monthNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const _dayNames = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

// Monday-based weekday (1-7) -> index into _dayNames
String _dayName(DateTime date) => _dayNames[date.weekday - 1];

String _fullDate(DateTime date) =>
    '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

String _formatRupiah(num amount) {
  final formatter = NumberFormat('#,##0', 'id_ID');
  return 'Rp ${formatter.format(amount)}';
}

pw.Widget clause({
  required String number,
  required String term,
  required String body,
  List<String> bullets = const [],
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: '$number ',
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.TextSpan(
                text: term,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (body.isNotEmpty)
                pw.TextSpan(
                  text: ' $body',
                  style: const pw.TextStyle(fontSize: 9),
                ),
            ],
          ),
        ),
        ...bullets.map(
          (b) => pw.Padding(
            padding: const pw.EdgeInsets.only(left: 14, bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('- ', style: const pw.TextStyle(fontSize: 9)),
                pw.Expanded(
                  child: pw.Text(b, style: const pw.TextStyle(fontSize: 9)),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class ContractPdf {
  /// [No.Kamar]/RZ/[SOLO/JAKARTA]/[Bln Sewa]/[Tahun Sewa]
  static String buildContractNumber({
    required Map<String, dynamic> tenant,
    Map<String, dynamic>? room,
  }) {
    final roomNumber = '${tenant['roomNumber'] ?? '-'}';

    final kosName =
        '${room?['BoardingHouse']?['name'] ?? tenant['boardingHouseName'] ?? ''}'
            .toLowerCase();
    final kosAddress =
        '${room?['BoardingHouse']?['address'] ?? ''}'.toLowerCase();
    String city = 'JAKARTA';
    if (kosName.contains('solo') || kosAddress.contains('solo')) {
      city = 'SOLO';
    } else if (kosName.contains('jakarta') ||
        kosAddress.contains('jakarta')) {
      city = 'JAKARTA';
    }

    final DateTime rentDate = tenant['checkinDate'] != null
        ? DateTime.parse(tenant['checkinDate'])
        : DateTime.now();
    final month = rentDate.month.toString().padLeft(2, '0');
    final year = '${rentDate.year}';

    return '$roomNumber/RZ/$city/$month/$year';
  }

  static Future<Uint8List> build({
    required String contractNumber,
    required Map<String, dynamic> tenant,
    required Map<String, dynamic>? room,
    required DateTime issuedOn,
  }) async {
    final kosName = (tenant['boardingHouseName'] ?? '') as String;
    final kosAddress =
        ((room?['BoardingHouse']?['address']) as String?) ?? '';

    final startDate = tenant['checkinDate'] != null
        ? DateTime.parse(tenant['checkinDate'])
        : null;
    final signingPlace = (kosName.toLowerCase().contains('solo') ||
            kosAddress.toLowerCase().contains('solo'))
        ? 'Solo'
        : 'Jakarta';
    final endDate = tenant['endDate'] != null
        ? DateTime.parse(tenant['endDate'])
        : (startDate?.add(const Duration(days: 30)));

    final priceAmount = (room?['Price']?['amount'] ?? 0) as num;

    final ttdSarjiman = pw.MemoryImage(
      (await rootBundle.load('assets/images/ttd_sarjiman.png'))
          .buffer
          .asUint8List(),
    );

    final pdf = pw.Document(
      title: 'KONTRAK SEWA_$contractNumber',
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ),
    );

    final labelStyle = const pw.TextStyle(fontSize: 9);
    final valueStyle = pw.TextStyle(
      fontSize: 9,
      fontWeight: pw.FontWeight.bold,
    );

    pw.Widget infoRow(String label, String value) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(label, style: labelStyle),
          ),
          pw.Text(':  ', style: labelStyle),
          pw.Expanded(child: pw.Text(value, style: valueStyle)),
        ],
      ),
    );

    pw.Widget sectionTitle(String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
      child: pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: pw.BoxDecoration(
          color: const PdfColor.fromInt(0xFFF0F0F0),
          border: pw.Border.all(color: PdfColors.black, width: 0.5),
        ),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(40, 30, 40, 30),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'KONTRAK SEWA KAMAR KOS',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              'Nomor: $contractNumber',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Pada hari ini, ${_dayName(startDate ?? issuedOn)}, tanggal ${_fullDate(startDate ?? issuedOn)}, '
            'para pihak di bawah ini sepakat untuk mengadakan Kontrak Sewa Kamar Kos '
            'dengan ketentuan sebagai berikut:',
            style: const pw.TextStyle(fontSize: 9),
          ),

          // A. IDENTITAS PEMILIK / PENGELOLA
          sectionTitle('A. IDENTITAS PEMILIK / PENGELOLA'),
          infoRow('Nama Pemilik/Pengelola', 'Sarjiman'),
          infoRow('NIK', '3175071407760007'),
          infoRow(
            'Alamat',
            'Jl. Kejaksaan V G.172 RT.011/RW.011 Pondok Bambu, Duren Sawit, Jakarta Timur',
          ),
          infoRow('No. Telepon', '+6281386512061'),

          // B. IDENTITAS PENYEWA
          sectionTitle('B. IDENTITAS PENYEWA'),
          infoRow('Nama Penyewa', '${tenant['name'] ?? '-'}'),
          infoRow('NIK / No. Identitas', '${tenant['NIKNumber'] ?? '-'}'),
          infoRow('Alamat Asal', 'Sesuai kartu identitas'),
          infoRow('No. Telepon / WhatsApp', '${tenant['phone'] ?? '-'}'),

          // C. OBJEK SEWA
          sectionTitle('C. OBJEK SEWA'),
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text(
              'Pemilik/Pengelola menyewakan kepada Penyewa satu kamar kos dengan data sebagai berikut:',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          infoRow('Nama Kos', kosName),
          infoRow('Alamat Kos', kosAddress.isEmpty ? '-' : kosAddress),
          infoRow('Nomor Kamar', '${tenant['roomNumber'] ?? '-'}'),
          infoRow(
            'Periode Sewa',
            startDate == null
                ? '-'
                : '${_fullDate(startDate)} s.d. ${endDate == null ? '-' : _fullDate(endDate)}',
          ),

          // D. FASILITAS KAMAR
          sectionTitle('D. FASILITAS KAMAR'),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellPadding: const pw.EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 4,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF0F0F0),
            ),
            border: pw.TableBorder.all(
              color: PdfColors.black,
              width: 0.5,
            ),
            columnWidths: {
              0: const pw.FixedColumnWidth(32),
              1: const pw.FlexColumnWidth(),
            },
            headers: ['No.', 'Fasilitas'],
            data: const [
              ['1', 'Tempat tidur dan spring bed'],
              ['2', 'Lemari pakaian'],
              ['3', 'Meja dan kursi'],
              ['4', 'Kamar mandi [dalam/luar]'],
              ['5', 'Listrik dan lampu'],
              ['6', 'Akses Wi-Fi'],
              ['7', 'Sprei/Bantal/Guling'],
            ],
          ),

          // E. BIAYA SEWA DAN DEPOSIT
          sectionTitle('E. BIAYA SEWA DAN DEPOSIT'),
          infoRow(
            'Nominal Sewa',
            '${_formatRupiah(priceAmount)} / bulan',
          ),
          infoRow(
            'Cara Pembayaran',
            'Transfer ke rekening: Sarjiman/Mandiri: 1290014233635',
          ),
          infoRow(
            'Jatuh Tempo Pembayaran',
            'Setiap tanggal dimulai Periode Sewa',
          ),
          infoRow('Deposit / Uang Jaminan', 'Satu kali sewa per bulan'),
          infoRow(
            'Ketentuan Pengembalian Deposit',
            'Dikembalikan paling lambat 7 hari setelah masa sewa berakhir, '
            'setelah dikurangi tagihan atau kerusakan yang menjadi tanggung '
            'jawab Penyewa.',
          ),

          // F. KETENTUAN SEWA
          sectionTitle('F. KETENTUAN SEWA'),
          clause(
            number: '1.',
            term: 'Jangka waktu.',
            body:
                'Sewa berlaku sesuai periode pada bagian C. Perpanjangan sewa akan '
                'dilakukan secara otomatis, kecuali disepakati lain oleh kedua belah pihak '
                'sebelum masa sewa berakhir.',
          ),
          clause(
            number: '2.',
            term: 'Pembayaran.',
            body:
                'Penyewa wajib membayar sewa tepat waktu sesuai nominal dan cara '
                'pembayaran yang disepakati. Keterlambatan dapat dikenakan sanksi sesuai '
                'ketentuan pemilik.',
          ),
          clause(
            number: '3.',
            term: 'Penggunaan kamar.',
            body:
                'Kamar hanya digunakan sebagai tempat tinggal Penyewa. Penyewa dilarang '
                'mengalihkan, menyewakan kembali, atau meminjamkan kamar kepada pihak lain '
                'tanpa persetujuan Pemilik/Pengelola.',
          ),
          clause(
            number: '4.',
            term: 'Kebersihan dan ketertiban.',
            body:
                'Penyewa wajib menjaga kebersihan kamar dan area bersama, mematuhi tata '
                'tertib kos, serta tidak melakukan kegiatan yang mengganggu penghuni atau '
                'lingkungan sekitar.',
          ),
          clause(
            number: '5.',
            term: 'Kerusakan.',
            body:
                'Penyewa bertanggung jawab atas kerusakan fasilitas akibat kelalaian atau '
                'penggunaan yang tidak wajar. Biaya perbaikan atau penggantian dapat '
                'dipotong dari deposit atau dibayarkan terpisah.',
          ),
          clause(
            number: '6.',
            term: 'Larangan.',
            body: '',
            bullets: const [
              'Penyewa dilarang membawa atau menggunakan barang atau melakukan kegiatan '
                  'yang melanggar hukum, mengganggu ketertiban, atau membahayakan '
                  'keselamatan penghuni dan bangunan.',
              'Penyewa dilarang membawa hewan peliharaan ke dalam kos.',
            ],
          ),
          clause(
            number: '7.',
            term: 'Pengakhiran sewa.',
            body:
                'Apabila salah satu pihak melanggar ketentuan material dalam kontrak ini, '
                'pihak lainnya berhak memberikan peringatan tertulis dan mengambil tindakan '
                'sesuai kesepakatan serta peraturan yang berlaku.',
          ),
          clause(
            number: '8.',
            term: 'Identitas penyewa.',
            body:
                'Penyewa diharuskan menyerahkan foto identitas (KTP) yang masih berlaku.',
          ),
          clause(
            number: '9.',
            term: 'Penyelesaian perselisihan.',
            body:
                'Perselisihan diselesaikan terlebih dahulu secara musyawarah. Jika tidak '
                'tercapai, para pihak dapat menempuh jalur sesuai hukum yang berlaku di '
                'Indonesia.',
          ),

          // G. PENUTUP
          sectionTitle('G. PENUTUP'),
          pw.Text(
            'Kontrak ini dibuat dalam dua rangkap yang masing-masing mempunyai kekuatan hukum '
            'yang sama. Dengan menandatangani dokumen ini, kedua belah pihak menyatakan telah '
            'membaca, memahami, dan menyetujui seluruh ketentuan di dalamnya.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Tempat penandatanganan: $signingPlace    Tanggal: ${startDate != null ? _fullDate(startDate) : _fullDate(issuedOn)}',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 16),
          pw.Center(
            child: pw.Text(
              'HALAMAN TANDA TANGAN',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'Kontrak Sewa Kamar Kos',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          pw.SizedBox(height: 40),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'PEMILIK / PENGELOLA',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Image(ttdSarjiman, width: 90, height: 60),
                  pw.Text('( Sarjiman )'),
                ],
              ),
              pw.SizedBox(width: 180),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'PENYEWA',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 64),
                  pw.Text(
                    '( ${tenant['name'] ?? '................................'} )',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }
}






