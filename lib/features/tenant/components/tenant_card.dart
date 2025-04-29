import 'package:flutter/material.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TenantCard extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantCard({super.key, required this.item});

  final dynamic item;

  @override
  State<TenantCard> createState() => _TenantCardState();
}

class _TenantCardState extends State<TenantCard> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 2,
        child: ClipRRect(
          child: InkWell(
            onTap: () {
              get<RoomViewModel>().tenantId = widget.item['id'];
              Navigator.pushNamed(context, tenantDetailRoute);
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.item['boardingHouseName']} ${widget.item['roomNumber']}',
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.item['name'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.item['phone'] ?? 'N/A'),
                            SizedBox(height: 4),
                            Text(
                              "Fotocopy KTP: ${(widget.item['isNIKCopyDone'] == true) ? "Sudah" : "Belum"}",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''),
                            Text("Mulai:"),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Text(
                                  formatDateString(widget.item['startDate']),
                                ),
                              ],
                            ),
                            Text("Sampai:"),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Text(formatDateString(widget.item['endDate'])),
                              ],
                            ),
                            // Text("Batas Pembayaran:"),
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Text(formatDateString(widget.item['dueDate'])),
                            //   ],
                            // ),
                            // Text("Batas tinggal:"),
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Text(formatDateString(widget.item['banishDate'])),
                            //   ],
                            // ),
                          ],
                          // (widget.item['Payments'] as List?)
                          //     ?.map((p) => Text(p['description'] ?? ''))
                          //     .toList() ??
                          // [],
                        ),
                      ),
                    ],
                  ),
                  if (widget.item['Invoices'].length == 0)
                    Column(
                      children: [
                        Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.greenAccent.shade700,
                        ),
                        Text("Lunas"),
                      ],
                    ),
                  if (widget.item['Invoices'].length != 0)
                    Column(
                      children: [
                        Text(
                          "!",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            color: Colors.amber.shade900,
                          ),
                        ),
                        Text("Ada"),
                        Text("Tagihan"),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
