import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/auth/login_content.dart';
import 'package:residenza/features/auth/register_content.dart';
import 'package:residenza/view_models/system_view_model.dart';

class LoginDesktop extends StatelessWidget with GetItMixin {
  LoginDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Welcome"), automaticallyImplyLeading: false),
      body: Row(
        children: [
          const SizedBox(width: 900),
          Column(
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: 600,
                  maxWidth: 350,
                ),
                child:
                    watchOnly((SystemViewModel x) => x.isLoginView)
                        ? LoginContent()
                        : RegisterContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
