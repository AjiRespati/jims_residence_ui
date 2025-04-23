import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';

class TenantCard extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantCard({super.key, required this.item});

  final dynamic item;

  @override
  State<TenantCard> createState() => _TenantCardState();
}

class _TenantCardState extends State<TenantCard> with GetItStateMixin {
  XFile? _imageMobile;
  Uint8List? _imageWeb;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
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
                            "Mulai: ${formatDateString(widget.item['startDate'])}",
                          ),
                          Text(
                            "Fotocopy KTP: ${(widget.item['isNIKCopyDone'] == true) ? "Sudah" : "Belum"}",
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:
                            (widget.item['Payments'] as List?)
                                ?.map((p) => Text(p['description'] ?? ''))
                                .toList() ??
                            [],
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
