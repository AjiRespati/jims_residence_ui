// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class EditRoomStatus extends StatefulWidget with GetItStatefulWidgetMixin {
  EditRoomStatus({super.key});

  @override
  State<EditRoomStatus> createState() => _EditRoomStatusState();
}

class _EditRoomStatusState extends State<EditRoomStatus> with GetItStateMixin {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
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
              get<RoomViewModel>().roomStatus = value;
              setState(() {});
            },
          ),
          SizedBox(height: 70),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GradientElevatedButton(
                onPressed: () async {
                  get<RoomViewModel>().isBusy = true;
                  await get<RoomViewModel>().updateRoomStatus();
                  await Future.delayed(Durations.medium4);
                  Navigator.pop(context);
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
