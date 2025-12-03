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
          SizedBox(
            width: 900,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
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
                  SizedBox(
                    width: 400,
                    child: Text(
                      "Residenza Indonesia",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
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
