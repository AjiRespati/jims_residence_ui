import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TenantCard extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantCard({super.key, required this.item});

  final dynamic item;

  @override
  State<TenantCard> createState() => _TenantCardState();
}

class _TenantCardState extends State<TenantCard> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    print(widget.item);
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
            child: Banner(
              message: widget.item['tenancyStatus'] ?? '',
              location: BannerLocation.topEnd,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
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
                          Text(widget.item['name'] ?? 'N/A'),
                          Text(widget.item['phone'] ?? 'N/A'),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Mulai:"),
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Text(formatDateString(widget.item['startDate'])),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
