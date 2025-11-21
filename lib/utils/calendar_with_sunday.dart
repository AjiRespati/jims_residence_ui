// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWithRedSunday extends StatefulWidget {
  const CalendarWithRedSunday({super.key});

  @override
  State<CalendarWithRedSunday> createState() => _CalendarWithRedSundayState();
}

class _CalendarWithRedSundayState extends State<CalendarWithRedSunday> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'id_ID',
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: (selected, focused) async {
        setState(() {
          selectedDay = selected;
          focusedDay = focused;
        });
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.of(context).pop(selectedDay);
      },
      calendarStyle: CalendarStyle(
        weekendTextStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
    );
  }
}
