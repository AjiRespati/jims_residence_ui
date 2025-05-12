// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class EditRoomStatus extends StatefulWidget with GetItStatefulWidgetMixin {
  EditRoomStatus({required this.oldStatus, super.key});

  final String? oldStatus;

  @override
  State<EditRoomStatus> createState() => _EditRoomStatusState();
}

class _EditRoomStatusState extends State<EditRoomStatus> with GetItStateMixin {
  String? _oldStatus;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _oldStatus = widget.oldStatus;
    _selectedStatus = get<RoomViewModel>().roomStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Ubah Status Kamar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Status Kamar"),
            value: _selectedStatus,
            items:
                ['Tersedia', 'Terisi', 'Dipesan', 'Pemeliharaan', 'Rusak'].map((
                  item,
                ) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              _selectedStatus = value;
              // get<RoomViewModel>().roomStatus = value;
              setState(() {});
            },
          ),
          SizedBox(height: 70),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GradientElevatedButton(
                onPressed: () async {
                  if (_oldStatus == "Terisi") {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Kamar ini terisi"),
                          icon: Icon(Icons.meeting_room),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Kamari ini sedang terisi. Apakah anda akan mengubah status kamar ini menjadi",
                                maxLines: 3,
                              ),
                              Text(
                                _selectedStatus ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            GradientElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Batal"),
                            ),
                            SizedBox(width: 5),
                            GradientElevatedButton(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.greenAccent.shade400,
                                  Colors.greenAccent.shade700,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onPressed: () async {
                                get<RoomViewModel>().isBusy = true;
                                get<RoomViewModel>().roomStatus =
                                    _selectedStatus;
                                await get<RoomViewModel>().updateRoomStatus();
                                await Future.delayed(Durations.medium4);
                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
                              },
                              child: Text("Ya"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    get<RoomViewModel>().isBusy = true;
                    get<RoomViewModel>().roomStatus = _selectedStatus;
                    await get<RoomViewModel>().updateRoomStatus();
                    await Future.delayed(Durations.medium4);
                    Navigator.pop(context, true);
                  }
                },
                child: Text(
                  "Ubah Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (watchOnly((RoomViewModel x) => x.isBusy))
                Row(
                  children: [
                    SizedBox(width: 20),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
