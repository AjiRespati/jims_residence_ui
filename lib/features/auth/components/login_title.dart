import 'package:flutter/material.dart';
import 'package:residenza/application_info.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              ApplicationInfo.appVersion,
              // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
