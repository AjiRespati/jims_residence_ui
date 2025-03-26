// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';

class RoomViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _isBusy = false;
  final formKey = GlobalKey<FormState>();

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  String _roomId = "";
  String _roomNumber = "";
  String _roomSize = "Standard";
  String _roomStatus = "Tersedia";
  double _basicPrice = 0.0;
  double _totalPrice = 0.0;
  String _description = "";
  DateTime? _startDate;
  DateTime? _dueDate;
  DateTime? _paymentDate;
  String _paymentStatus = "";
  List<dynamic> _rooms = [];

  String get roomId => _roomId;
  set roomId(String val) {
    _roomId = val;
    notifyListeners();
  }

  String get roomNumber => _roomNumber;
  set roomNumber(String val) {
    _roomNumber = val;
    notifyListeners();
  }

  String get roomSize => _roomSize;
  set roomSize(String val) {
    _roomSize = val;
    notifyListeners();
  }

  String get roomStatus => _roomStatus;
  set roomStatus(String val) {
    _roomStatus = val;
    notifyListeners();
  }

  double get basicPrice => _basicPrice;
  set basicPrice(double val) {
    _basicPrice = val;
    notifyListeners();
  }

  double get totalPrice => _totalPrice;
  set totalPrice(double val) {
    _totalPrice = val;
    notifyListeners();
  }

  String get description => _description;
  set description(String val) {
    _description = val;
    notifyListeners();
  }

  DateTime? get startDate => _startDate;
  set startDate(DateTime? val) {
    _startDate = val;
    notifyListeners();
  }

  DateTime? get dueDate => _dueDate;
  set dueDate(DateTime? val) {
    _dueDate = val;
    notifyListeners();
  }

  DateTime? get paymentDate => _paymentDate;
  set paymentDate(DateTime? val) {
    _paymentDate = val;
    notifyListeners();
  }

  String get paymentStatus => _paymentStatus;
  set paymentStatus(String val) {
    _paymentStatus = val;
    notifyListeners();
  }

  List<dynamic> get rooms => _rooms;
  set rooms(List<dynamic> val) {
    _rooms = val;
    notifyListeners();
  }

  /// ################## ///
  ///       METHOD       ///
  /// ################## ///

  Future<bool> addRoom({required BuildContext context}) async {
    isBusy = true;

    final resp = await apiService.createRoom(
      roomNumber: roomNumber,
      roomSize: roomSize,
      roomStatus: roomStatus,
      basicPrice: basicPrice,
    );

    if (resp) {
      await fetchRooms();
      isBusy = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kamar Berhasil ditambahkan')));
      return true;
    } else {
      isBusy = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kamar gagal ditambahkan')));
      return false;
    }
  }

  Future<bool> fetchRooms() async {
    isBusy = true;
    rooms = await apiService.fetchRooms();
    isBusy = false;
    return rooms.isNotEmpty;
  }
}
