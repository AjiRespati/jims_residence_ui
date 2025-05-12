import 'package:flutter/material.dart';
import 'package:residenza/utils/helpers.dart';

class ResumeItem extends StatelessWidget {
  const ResumeItem({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                item["boardingHouseName"],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Text(formatBulanTahun(DateTime(item['year'], item['month']))),
              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pemasukan",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              formatCurrency(item['totalMonthlyIncome'] ?? 0),
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Text(
                          "Pengeluaran",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              formatCurrency(item['totalMonthlyExpenses'] ?? 0),
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Laba/Rugi",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              formatCurrency(item['netProfitLoss'] ?? 0),
                              style: TextStyle(
                                color:
                                    (item['netProfitLoss'] ?? 0) <= 0
                                        ? Colors.red.shade700
                                        : Colors.blue.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
