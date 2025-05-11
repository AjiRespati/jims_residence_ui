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
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.item['name'] ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(widget.item['phone'] ?? 'N/A'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((widget.item['isNIKCopyDone'] == false))
                              Text(
                                "Fotocopy KTP belum ada!",
                                style: TextStyle(
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (widget.item['Invoices'].length != 0)
                              Text(
                                "Ada tagihan belum lunas!",
                                style: TextStyle(
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text("Mulai:"),
                          SizedBox(width: 5),
                          Text(
                            formatDateString(widget.item['startDate']),
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("  s/d "),
                          SizedBox(width: 5),
                          Text(
                            formatDateString(widget.item['endDate']),
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
