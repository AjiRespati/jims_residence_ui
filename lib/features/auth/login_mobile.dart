import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login_content.dart';

class LoginMobile extends StatelessWidget {
  const LoginMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome"), automaticallyImplyLeading: false),
      body: Padding(padding: const EdgeInsets.all(20), child: LoginContent()),
    );
  }
}
