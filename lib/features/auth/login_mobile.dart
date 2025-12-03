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
                ? Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage('assets/images/main_logo.png'),
                          ),
                          shape: BoxShape.rectangle,
                        ),
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      ),
                    ),
                    LoginContent(),
                  ],
                )
                : RegisterContent(),
      ),
    );
  }
}
