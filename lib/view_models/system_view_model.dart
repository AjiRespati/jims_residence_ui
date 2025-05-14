// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/routes/route_names.dart';
// import 'package:residenza/services/api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:residenza/services/auth_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemViewModel extends ChangeNotifier {
  // final ApiService apiService = ApiService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isBusy = false;
  bool _isLoginView = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  bool _showPassword = false;
  int _currentPageIndex = 0;

  dynamic _user;
  List<dynamic> _users = [];
  List<String> levelList = ["Penjaga Kost", "Admin", "Pemilik"];
  int _level = 0;
  String _username = " -";
  String _levelDesc = " -";
  String _status = " -";

  //====================//
  //  GETTER n SETTER   //
  //====================//

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  bool get isLoginView => _isLoginView;
  set isLoginView(bool val) {
    _isLoginView = val;
    notifyListeners();
  }

  bool get showPassword => _showPassword;
  set showPassword(bool val) {
    _showPassword = val;
    notifyListeners();
  }

  int get currentPageIndex => _currentPageIndex;
  set currentPageIndex(int val) {
    _currentPageIndex = val;
    notifyListeners();
  }

  List<dynamic> get users => _users;
  set users(List<dynamic> val) {
    _users = val;
    notifyListeners();
  }

  dynamic get user => _user;
  set user(dynamic val) {
    _user = val;
    notifyListeners();
  }

  int get level => _level;
  set level(int val) {
    _level = val;
    notifyListeners();
  }

  String get levelDesc => _levelDesc;
  set levelDesc(String val) {
    _levelDesc = val;
    notifyListeners();
  }

  String get status => _status;
  set status(String val) {
    _status = val;
    notifyListeners();
  }

  String get username => _username;
  set username(String val) {
    _username = val;
    notifyListeners();
  }

  //====================//
  //       METHOD       //
  //====================//

  /// call this method after mounted
  checkSession({required BuildContext context}) async {
    isBusy = true;
    SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('accessToken');

    if (!isTokenExpired(token)) {
      Navigator.pushNamed(context, homeRoute);
    }
    isBusy = false;
  }

  bool isTokenExpired(String? token) {
    if (token == null) {
      return true;
    }
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }

    // bool isNeedRefresh = JwtDecoder.isExpired(token);
    // if (isNeedRefresh) {
    //   apiService.refreshAccessToken();
    // }
    // return JwtDecoder.isExpired(token);
  }

  void onLogin({required BuildContext context}) async {
    bool isLogin = await AuthApiService().login(
      usernameController.text,
      passwordController.text,
    );
    if (isLogin) {
      usernameController.text = "";
      passwordController.text = "";
      Navigator.pushReplacementNamed(context, homeRoute);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    }
  }

  Future<bool> register() async {
    return await AuthApiService().register(
      emailController.text,
      passwordController.text,
    );
  }

  Future<bool> logout() async {
    isBusy = true;
    return await AuthApiService().logout();
  }

  Future<bool> self({required BuildContext context}) async {
    SharedPreferences prefs = await _prefs;
    String? refreshToken = prefs.getString('refreshToken');
    try {
      isBusy = true;
      user = await AuthApiService().self(refreshToken: refreshToken ?? "-");
      level = user['level'];
      status = user['status'];
      username = user['username'];
      levelDesc = user['levelDesc'];
      isBusy = false;
      return true;
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
        Navigator.pushNamed(context, signInRoute);
        return false;
      } else {
        isBusy = false;
        return false;
      }
    }
  }

  Future<void> getAllUser() async {
    isBusy = true;
    try {
      dynamic resp = await AuthApiService().getAllUsers();
      users = resp;
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
      } else {
        isBusy = false;
      }
    }
  }

  Future<bool> updateUser({
    required String id,
    required int? level,
    required String? status,
  }) async {
    try {
      isBusy = true;
      var resp = await AuthApiService().updateUser(
        id: id,
        level: level,
        status: status,
      );
      isBusy = false;
      return resp;
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
      } else {
        isBusy = false;
      }
      isBusy = false;
      return false;
    }
  }

  Future<bool> genericTable({required String table}) async {
    return AuthApiService().generic(table);
  }
}
