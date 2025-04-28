import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmPassword extends StatelessWidget with GetItMixin {
  ConfirmPassword({super.key});

  @override
  Widget build(BuildContext context) {
    watchOnly((SystemViewModel x) => x.showPassword);
    return TextFormField(
      controller: get<SystemViewModel>().confirmpasswordController,
      obscureText: !get<SystemViewModel>().showPassword,
      // onEditingComplete: () async {
      //   bool isLogin = await get<SystemViewModel>().onLogin();

      //   if (isLogin) {
      //     Navigator.pushReplacementNamed(context, dashboardRoute);
      //   } else {
      //     ScaffoldMessenger.of(
      //       context,
      //     ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
      //   }
      // },
      onTap: () {
        log('tapped');
      },
      decoration: InputDecoration(
        hintText: "Confirm Password",
        hintStyle: GoogleFonts.inter(fontSize: 12),
        label: Text("Confirm Password", style: GoogleFonts.inter(fontSize: 12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        prefixIcon: const Icon(Icons.lock, size: 20),
        suffixIcon: IconButton(
          splashRadius: 20,
          icon: Icon(
            get<SystemViewModel>().showPassword
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () {
            get<SystemViewModel>().showPassword =
                !get<SystemViewModel>().showPassword;
          },
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Confirm Password can't be empty";
        } else if (watchOnly(
          (SystemViewModel x) => x.passwordController.text != value,
        )) {
          return "Confirm password not match.";
        }

        return null;
      },
    );
  }
}
