import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/user_management/components/user_table_card.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:residenza/widgets/page_container.dart';

class UserManagementDesktop extends StatefulWidget
    with GetItStatefulWidgetMixin {
  UserManagementDesktop({super.key});

  @override
  State<UserManagementDesktop> createState() => _UserManagementDesktopState();
}

class _UserManagementDesktopState extends State<UserManagementDesktop>
    with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    watchOnly((SystemViewModel x) => x.users);
    watchOnly((SystemViewModel x) => x.isBusy);
    return Scaffold(
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      // IconButton(
                      //   onPressed: () => Navigator.pop(context),
                      //   icon: Icon(Icons.arrow_back_ios_new, size: 25),
                      // ),
                      Text(
                        "Pengaturan Pengguna",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    SizedBox(
                      child:
                          watchOnly((SystemViewModel x) => x.isBusy)
                              ? SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              )
                              : watchOnly(
                                (SystemViewModel x) => x.users,
                              ).isEmpty
                              ? Text("user not found")
                              : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      get<SystemViewModel>().users.length,
                                  itemBuilder: (context, index) {
                                    var item =
                                        get<SystemViewModel>().users[index];
                                    // print(item);
                                    return UserTableCard(
                                      key: ValueKey(index + 19000),
                                      user: item,
                                    );
                                  },
                                ),
                              ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
