import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPassword extends StatelessWidget with GetItMixin {
  LoginPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: get<SystemViewModel>().passwordController,
      obscureText: !get<SystemViewModel>().showPassword,
      onEditingComplete: () {
        get<SystemViewModel>().onLogin(context: context);
      },
      onTap: () {
        log('tapped');
      },
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: GoogleFonts.inter(fontSize: 12),
        label: Text("Password", style: GoogleFonts.inter(fontSize: 12)),
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
          return "Password can't be empty";
        }

        return null;
      },
    );
  }
}
