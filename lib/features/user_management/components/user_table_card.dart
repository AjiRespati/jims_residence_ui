// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/features/user_management/components/update_level_content.dart';
import 'package:residenza/features/user_management/components/update_password_content.dart';
import 'package:residenza/features/user_management/components/update_status_content.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:residenza/widgets/copy_to_clipboard.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UserTableCard extends StatelessWidget with GetItMixin {
  UserTableCard({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap: () async {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      user['name'] ?? " N/A",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                left: 24,
                                right: 24,
                                top: 24,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    UpdatePasswordContent(
                                      id: user['id'],
                                      username: user['username'],
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(Icons.key_rounded, size: 18),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Username: "),
                  Flexible(
                    child: Text(
                      user['email'] ?? " N/A",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  CopyToClipboard(user['email'], isMobile: true),
                ],
              ),
              Row(
                children: [
                  Text("Phone: "),
                  Flexible(
                    child: Text(
                      user['phone'] ?? " N/A",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  CopyToClipboard(
                    user['phone'] ?? " N/A",
                    isMobile: true,
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Hapus User"),
                            content: Text(
                              "Yakin ingin menghapus \"${user['name'] ?? user['username']}\"?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: Text("Hapus"),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await get<SystemViewModel>().deleteUser(
                            id: user['id'],
                          );
                          await get<SystemViewModel>().getAllUser();
                        }
                      },
                      child: Icon(
                        Icons.delete_forever,
                        size: 26,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Level/Role: "),
                  Flexible(
                    child: Text(
                      "${user['level'].toString()} - ${user['levelDesc'] ?? "Penjaga Kost"}",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.green[800],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 24,
                                right: 24,
                                top: 24,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    UpdateLevelContent(
                                      id: user['id'],
                                      username: user['username'],
                                      level: user['level'],
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(Icons.edit_rounded, size: 18),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Status: "),
                  Text(
                    user['status'].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: _generateColor(user['status'].toUpperCase()),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 40),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 24,
                                right: 24,
                                top: 24,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    UpdateStatusContent(
                                      id: user['id'],
                                      username: user['username'],
                                      oldStatus: user['status'],
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(Icons.edit_rounded, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _generateColor(String status) {
    switch (status) {
      case "NEW":
        return Colors.amber.shade800;
      case "ACTIVE":
        return Colors.green.shade700;
      default:
        return Colors.red.shade600;
    }
  }
}
