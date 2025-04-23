// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';

class RoomViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _isUpdating = false;
  bool _isBusy = false;
  bool _isNoSession = false;
  bool? _isError;
  bool _isSuccess = false;
  String? _errorMessage;
  String? _successMessage;

  final formKey = GlobalKey<FormState>();

  bool get isUpdating => _isUpdating;
  set isUpdating(bool val) {
    _isUpdating = val;
    notifyListeners();
  }

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  bool get isNoSession => _isNoSession;
  set isNoSession(bool val) {
    _isNoSession = val;
    notifyListeners();
  }

  bool get isSuccess => _isSuccess;
  set isSuccess(bool val) {
    _isSuccess = val;
    notifyListeners();
  }

  bool? get isError => _isError;
  set isError(bool? val) {
    _isError = val;
    notifyListeners();
  }

  String? get errorMessage => _errorMessage;
  set errorMessage(String? val) {
    _errorMessage = val;
    notifyListeners();
  }

  String? get successMessage => _successMessage;
  set successMessage(String? val) {
    _successMessage = val;
    notifyListeners();
  }

  String _roomId = "";
  String? _roomKostName;
  String? _roomKostId;
  String _roomNumber = "";
  String _roomSize = "";
  dynamic _selectedRoomSize;
  String? _roomStatus;
  double _basicPrice = 0.0;
  double _totalPrice = 0.0;
  String _description = "";
  DateTime? _startDate;
  DateTime? _dueDate;
  DateTime? _paymentDate;
  String _paymentStatus = "";
  List<dynamic> _rooms = [];
  dynamic _room;
  // dynamic _selectedRoomPrice;

  String get roomId => _roomId;
  set roomId(String val) {
    _roomId = val;
    notifyListeners();
  }

  String? get roomKostName => _roomKostName;
  set roomKostName(String? val) {
    _roomKostName = val;
    notifyListeners();
  }

  String? get roomKostId => _roomKostId;
  set roomKostId(String? val) {
    _roomKostId = val;
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

  String? get roomStatus => _roomStatus;
  set roomStatus(String? val) {
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

  dynamic get room => _room;
  set room(dynamic val) {
    _room = val;
    notifyListeners();
  }

  dynamic get selectedRoomSize => _selectedRoomSize;
  set selectedRoomSize(dynamic val) {
    _selectedRoomSize = val;
    notifyListeners();
  }

  // TODO: TENANT STATE
  String _tenantName = "";
  String _tenantPhone = "";
  String _tenantIdNumber = "";
  String? _idImagePath;
  bool _isIdCopied = false;
  String? _isIdCopiedText;
  String _tenantStatus = "";
  String? _tenantRoomStatus = "";
  List<dynamic> _tenants = [];

  String _tenantId = "";
  dynamic _tenant;

  DateTime? _tenantStartDate;
  DateTime? _tenantPaymentDate;
  DateTime? _tenantDueDate;

  String get tenantName => _tenantName;
  set tenantName(String val) {
    _tenantName = val;
    notifyListeners();
  }

  String get tenantPhone => _tenantPhone;
  set tenantPhone(String val) {
    _tenantPhone = val;
    notifyListeners();
  }

  String get tenantIdNumber => _tenantIdNumber;
  set tenantIdNumber(String val) {
    _tenantIdNumber = val;
    notifyListeners();
  }

  String? get idImagePath => _idImagePath;
  set idImagePath(String? val) {
    _idImagePath = val;
    notifyListeners();
  }

  bool get isIdCopied => _isIdCopied;
  set isIdCopied(bool val) {
    _isIdCopied = val;
    notifyListeners();
  }

  String get tenantStatus => _tenantStatus;
  set tenantStatus(String val) {
    _tenantStatus = val;
    notifyListeners();
  }

  String? get tenantRoomStatus => _tenantRoomStatus;
  set tenantRoomStatus(String? val) {
    _tenantRoomStatus = val;
    notifyListeners();
  }

  String? get isIdCopiedText => _isIdCopiedText;
  set isIdCopiedText(String? val) {
    _isIdCopiedText = val;
    notifyListeners();
  }

  List<dynamic> get tenants => _tenants;
  set tenants(List<dynamic> val) {
    _tenants = val;
    notifyListeners();
  }

  String get tenantId => _tenantId;
  set tenantId(String val) {
    _tenantId = val;
    notifyListeners();
  }

  dynamic get tenant => _tenant;
  set tenant(dynamic val) {
    _tenant = val;
    notifyListeners();
  }

  DateTime? get tenantStartDate => _tenantStartDate;
  set tenantStartDate(DateTime? val) {
    _tenantStartDate = val;
    notifyListeners();
  }

  DateTime? get tenantPaymentDate => _tenantPaymentDate;
  set tenantPaymentDate(DateTime? val) {
    _tenantPaymentDate = val;
    notifyListeners();
  }

  DateTime? get tenantDueDate => _tenantDueDate;
  set tenantDueDate(DateTime? val) {
    _tenantDueDate = val;
    notifyListeners();
  }

  String _addPriceName = "";
  double _addPriceAmount = 0.0;
  String? _addPriceDesc = "";

  String get addPriceName => _addPriceName;
  set addPriceName(String val) {
    _addPriceName = val;
    notifyListeners();
  }

  double get addPriceAmount => _addPriceAmount;
  set addPriceAmount(double val) {
    _addPriceAmount = val;
    notifyListeners();
  }

  String? get addPriceDesc => _addPriceDesc;
  set addPriceDesc(String? val) {
    _addPriceDesc = val;
    notifyListeners();
  }

  List<dynamic> _kosts = [];
  String _kostName = "";
  String _kostAddress = "";
  String _kostDescription = "";

  List<dynamic> get kosts => _kosts;
  set kosts(List<dynamic> val) {
    _kosts = val;
    notifyListeners();
  }

  String get kostName => _kostName;
  set kostName(String val) {
    _kostName = val;
    notifyListeners();
  }

  String get kostAddress => _kostAddress;
  set kostAddress(String val) {
    _kostAddress = val;
    notifyListeners();
  }

  String get kostDescription => _kostDescription;
  set kostDescription(String val) {
    _kostDescription = val;
    notifyListeners();
  }

  //TODO PRICE STATE

  List<dynamic> _prices = [];
  List<dynamic> _pricesByKost = [];
  String _priceName = "";
  double _priceAmount = 0;
  String? _priceRoomSize;
  String? _priceDescription;

  List<dynamic> _additionalPrices = [];
  List<dynamic> _otherCost = [];
  List<dynamic> _updatedAdditionalPrices = [];
  List<dynamic> _updatedOtherCost = [];

  List<dynamic> get prices => _prices;
  set prices(List<dynamic> val) {
    _prices = val;
    notifyListeners();
  }

  List<dynamic> get pricesByKost => _pricesByKost;
  set pricesByKost(List<dynamic> val) {
    _pricesByKost = val;
    notifyListeners();
  }

  String get priceName => _priceName;
  set priceName(String val) {
    _priceName = val;
    notifyListeners();
  }

  double get priceAmount => _priceAmount;
  set priceAmount(double val) {
    _priceAmount = val;
    notifyListeners();
  }

  String? get priceRoomSize => _priceRoomSize;
  set priceRoomSize(String? val) {
    _priceRoomSize = val;
    notifyListeners();
  }

  String? get priceDescription => _priceDescription;
  set priceDescription(String? val) {
    _priceDescription = val;
    notifyListeners();
  }

  List<dynamic> get additionalPrices => _additionalPrices;
  set additionalPrices(List<dynamic> val) {
    _additionalPrices = val;
    notifyListeners();
  }

  List<dynamic> get otherCost => _otherCost;
  set otherCost(List<dynamic> val) {
    _otherCost = val;
    notifyListeners();
  }

  List<dynamic> get updatedAdditionalPrices => _updatedAdditionalPrices;
  set updatedAdditionalPrices(List<dynamic> val) {
    _updatedAdditionalPrices = val;
    notifyListeners();
  }

  List<dynamic> get updatedOtherCost => _updatedOtherCost;
  set updatedOtherCost(List<dynamic> val) {
    _updatedOtherCost = val;
    notifyListeners();
  }

  /// ################## ///
  ///       METHOD       ///
  /// ################## ///

  Future<void> updateRoomStatus() async {
    try {
      dynamic resp = await apiService.updateRoomStatus(
        roomId: roomId,
        roomStatus: roomStatus ?? "",
      );

      roomStatus = resp['data']['roomStatus'];
      isBusy = false;
      successMessage = "Berhasil mengubah status";
      isSuccess = true;
      notifyListeners();
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isBusy = false;
        isError = true;
      }
    }
  }

  Future<void> addTenant({required BuildContext context}) async {
    try {
      isBusy = true;

      await apiService.createTenant(
        roomId: roomId,
        name: tenantName,
        phone: tenantPhone,
        idNumber: tenantIdNumber,
        idImagePath: idImagePath,
        isNIKCopyDone: isIdCopied,
        startDate: tenantStartDate,
        paymentDate: tenantPaymentDate,
        dueDate: tenantStartDate?.add(Duration(days: 7)),
        banishDate: tenantStartDate?.add(Duration(days: 14)),
        paymentStatus: "unpaid",
        tenancyStatus: tenantStatus,
        roomStatus: tenantRoomStatus,
      );

      await fetchRoom();

      roomId = "";
      tenantName = "";
      tenantPhone = "";
      tenantIdNumber = "";
      idImagePath = null;
      isIdCopied = false;
      tenantStartDate = null;
      tenantPaymentDate = null;
      tenantDueDate = null;
      tenantStatus = "";
      tenantRoomStatus = "";

      isBusy = false;
      isSuccess = true;
      successMessage = "Berhasil menambah harga";
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isBusy = false;
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  Future<bool> fetchTenants() async {
    isBusy = true;
    dynamic resp = await apiService.fetchTenants();
    tenants = resp['data'];
    isBusy = false;
    return tenants.isNotEmpty;
  }

  Future<bool> fetchTenant() async {
    print('hmmmm');
    isBusy = true;
    dynamic resp = await apiService.fetchTenant(id: tenantId);
    print(resp);
    tenant = resp['data'];
    isBusy = false;
    return tenant != null;
  }

  // TODO: KOST (Boarding House) Section
  // TODO: BOILERPLATE FOR ALL CONTROLLERS

  Future<void> createKost() async {
    try {
      isBusy = true;
      await apiService.createKost(
        name: kostName,
        address: kostAddress,
        description: kostDescription,
      );
      await fetchKosts();
      isSuccess = true;
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isBusy = false;
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  Future<void> fetchKosts() async {
    try {
      isBusy = true;
      kosts = await apiService.fetchKosts();
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  // TODO: ROOM  Section
  // TODO: Core logic for this app

  Future<void> addRoom() async {
    try {
      isBusy = true;

      await apiService.createRoom(
        boardingHouseId: roomKostId,
        roomNumber: roomNumber,
        roomSize: selectedRoomSize['roomSize'],
        roomStatus: roomStatus ?? "",
        description: description,
        priceId: selectedRoomSize['id'],
      );

      await fetchRooms();

      roomKostId = null;
      roomNumber = "";
      roomSize = "";
      roomStatus = "";
      basicPrice = 0;
      isSuccess = true;
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isBusy = false;
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  Future<void> fetchRooms() async {
    try {
      isBusy = true;
      var resp = await apiService.fetchRooms();
      rooms = resp['data'];
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  Future<void> fetchRoom() async {
    try {
      if (roomId.isNotEmpty) {
        isBusy = true;
        var resp = await apiService.fetchRoom(roomId: roomId);
        room = resp['data'];
      }
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  Future<void> updateRoom() async {
    try {
      if (roomId.isNotEmpty) {
        isBusy = true;
        var resp = await apiService.updateRoom(
          roomId: roomId,
          roomUpdateData: {},
          additionalPrices: updatedAdditionalPrices,
          otherCost: updatedOtherCost,
        );
        room = resp['data'];
        isBusy = false;
      }
      isBusy = false;
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  // TODO: PRICE  Section
  // TODO: Core logic for this app

  Future<void> createPrice() async {
    try {
      isBusy = true;
      await apiService.createPrice(
        boardingHouseId: roomKostId,
        name: "Harga Kamar $priceRoomSize",
        amount: priceAmount,
        roomSize: priceRoomSize,
        description: priceDescription,
      );
      await fetchPrices();

      priceName = "";
      priceAmount = 0;
      priceRoomSize = "Standard";
      priceDescription = null;
      roomKostName = null;
      isSuccess = true;
      successMessage = "Berhasil menambah harga";
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isBusy = false;
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isBusy = false;
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }

  Future<void> fetchPrices() async {
    isBusy = true;
    try {
      var resp = await apiService.fetchPrices();
      prices = resp['data'];
    } catch (e) {
      if (e.toString().contains("please reLogin")) {
        isNoSession = true;
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isError = true;
      }
    } finally {
      isBusy = false;
    }
  }
}
