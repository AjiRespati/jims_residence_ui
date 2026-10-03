// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UpdatePasswordContent extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdatePasswordContent({
    required this.id,
    required this.username,
    super.key,
  });

  final String id;
  final String username;

  @override
  State<UpdatePasswordContent> createState() => _UpdatePasswordContentState();
}

class _UpdatePasswordContentState extends State<UpdatePasswordContent>
    with GetItStateMixin {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isBusy = false;
  bool showPassword = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              widget.username,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text("Update Password", style: TextStyle(fontSize: 12)),
            SizedBox(height: 40),
            TextFormField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                isDense: true,
                label: Text("Password Baru"),
                suffixIcon: IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => showPassword = !showPassword),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password can't be empty";
                } else if (value.length < 6) {
                  return "Minimal 6 karakter";
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                isDense: true,
                label: Text("Konfirmasi Password"),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Confirm password can't be empty";
                } else if (passwordController.text != value) {
                  return "Confirm password not match.";
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  GradientElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      setState(() => _isBusy = true);
                      final ok = await get<SystemViewModel>().updateUser(
                        id: widget.id,
                        level: null,
                        status: null,
                        password: passwordController.text,
                      );
                      setState(() => _isBusy = false);
                      if (!mounted) return;
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Password berhasil diubah"),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Gagal mengubah password"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Update Password',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (_isBusy)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 5),
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
