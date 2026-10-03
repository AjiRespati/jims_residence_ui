// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUserContent extends StatefulWidget with GetItStatefulWidgetMixin {
  AddUserContent({super.key});

  @override
  State<AddUserContent> createState() => _AddUserContentState();
}

class _AddUserContentState extends State<AddUserContent>
    with GetItStateMixin {
  bool _isBusy = false;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showPassword = false;
  String levelChoosen = "Penjaga Kost";
  String? ownerIdChoosen;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
              "Tambah User",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text("Register user baru", style: TextStyle(fontSize: 12)),
            SizedBox(height: 40),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text("Nama", style: GoogleFonts.inter(fontSize: 12)),
                hintText: "Nama",
                hintStyle: GoogleFonts.inter(fontSize: 12),
                prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUnfocus,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama can't be empty";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                label: Text("Email", style: GoogleFonts.inter(fontSize: 12)),
                hintText: "Email",
                hintStyle: GoogleFonts.inter(fontSize: 12),
                prefixIcon: const Icon(Icons.person_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUnfocus,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email can't be empty";
                } else if (!EmailValidator.validate(value)) {
                  return "Invalid email format";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                label: Text("Telepon", style: GoogleFonts.inter(fontSize: 12)),
                hintText: "Telepon",
                hintStyle: GoogleFonts.inter(fontSize: 12),
                prefixIcon: const Icon(Icons.phone_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUnfocus,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Telepon can't be empty";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                label: Text("Password", style: GoogleFonts.inter(fontSize: 12)),
                hintText: "Password",
                hintStyle: GoogleFonts.inter(fontSize: 12),
                prefixIcon: const Icon(Icons.lock, size: 20),
                suffixIcon: IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => showPassword = !showPassword);
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password can't be empty";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                label: Text(
                  "Confirm Password",
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                hintText: "Confirm Password",
                hintStyle: GoogleFonts.inter(fontSize: 12),
                prefixIcon: const Icon(Icons.lock, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Confirm Password can't be empty";
                } else if (passwordController.text != value) {
                  return "Confirm password not match.";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: Text("Level/Role", style: GoogleFonts.inter(fontSize: 12)),
                isDense: true,
              ),
              initialValue: levelChoosen,
              items:
                  (get<SystemViewModel>().level == 1
                          ? ["Penjaga Kost"]
                          : ["Pemilik", "Penjaga Kost"])
                      .map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
              onChanged: (value) {
                setState(() {
                  levelChoosen = value ?? "Penjaga Kost";
                  ownerIdChoosen = null;
                });
              },
            ),
            if (get<SystemViewModel>().level == 2 &&
                levelChoosen == "Penjaga Kost") ...[
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  label: Text(
                    "Pemilik",
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  isDense: true,
                ),
                hint: const Text("Pilih Pemilik"),
                initialValue: ownerIdChoosen,
                items:
                    get<SystemViewModel>()
                        .users
                        .where((u) => u['level'] == 1)
                        .map((u) {
                          return DropdownMenuItem<String>(
                            value: u['id'] as String,
                            child: Text(
                              u['name'] ?? u['username'] ?? u['id'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                onChanged: (value) {
                  setState(() => ownerIdChoosen = value);
                },
              ),
            ],
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  GradientElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      setState(() => _isBusy = true);
                      int level = get<SystemViewModel>().levelList.indexOf(
                        levelChoosen,
                      );
                      bool isRegistered = await get<SystemViewModel>().register(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        level: level,
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        ownerId:
                            levelChoosen == "Penjaga Kost"
                                ? ownerIdChoosen
                                : null,
                      );
                      setState(() => _isBusy = false);

                      if (isRegistered) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Registrasi sukses"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        await get<SystemViewModel>().getAllUser();
                        if (context.mounted) Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.red.shade400,
                            content: Text(
                              "Registrasi gagal",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Register User',
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
