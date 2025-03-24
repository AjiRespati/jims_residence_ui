import 'package:flutter/material.dart';
import 'package:frontend/view_models/system_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginButton extends StatelessWidget with GetItMixin {
  LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: GradientElevatedButton(
        onPressed: () {
          get<SystemViewModel>().onLogin(context: context);
        },
        borderRadius: 15,
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
