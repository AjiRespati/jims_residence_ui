import 'package:flutter/material.dart';
import 'package:residenza/features/auth/login_content.dart';
import 'package:residenza/features/auth/register_content.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginMobile extends StatelessWidget with GetItMixin {
  LoginMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Welcome"), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
            watchOnly((SystemViewModel x) => x.isLoginView)
                ? LoginContent()
                : RegisterContent(),
      ),
    );
  }
}
