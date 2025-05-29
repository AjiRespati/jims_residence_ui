// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residenza/services/boarding_house_api_service.dart';
import 'package:residenza/services/expense_api_service.dart';
import 'package:residenza/services/price_api_serevice.dart';
import 'package:residenza/services/report_api_service.dart';
import 'package:residenza/services/room_api_service.dart';
import 'package:residenza/services/tenant_api_service.dart';
import 'package:residenza/services/transaction_invoice_api_service.dart';

class RoomViewModel extends ChangeNotifier {
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
  String _kostId = "";
  String _kostName = "";
  String _kostAddress = "";
  String _kostDescription = "";

  List<dynamic> get kosts => _kosts;
  set kosts(List<dynamic> val) {
    _kosts = val;
    notifyListeners();
  }

  String get kostId => _kostId;
  set kostId(String val) {
    _kostId = val;
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

  // TODO:  TRANSACTION AND INVOICE STATE

  List<dynamic> _invoices = [];
  dynamic _invoice;
  String _choosenInvoiceId = "";
  List<dynamic> _transactions = [];
  dynamic _transaction;
  String _choosenTransactionId = "";
  double _totalInvoicesPaid = 0;

  String _invoiceId = "";
  String _transactionMethod = "";
  double _transactionAmount = 0;
  DateTime _transactionDate = DateTime.now();
  String _transactionDescription = "";

  List<dynamic> _expenses = [];
  double _totalExpensesAmount = 0;

  List<dynamic> _kostMonthlyReport = [];

  List<dynamic> _transactionsTable = [];

  List<dynamic> get invoices => _invoices;
  set invoices(List<dynamic> val) {
    _invoices = val;
    notifyListeners();
  }

  dynamic get invoice => _invoice;
  set invoice(dynamic val) {
    _invoice = val;
    notifyListeners();
  }

  String get choosenInvoiceId => _choosenInvoiceId;
  set choosenInvoiceId(String val) {
    _choosenInvoiceId = val;
    notifyListeners();
  }

  List<dynamic> get transactions => _transactions;
  set transactions(List<dynamic> val) {
    _transactions = val;
    notifyListeners();
  }

  dynamic get transaction => _transaction;
  set transaction(dynamic val) {
    _transaction = val;
    notifyListeners();
  }

  String get choosenTransactionId => _choosenTransactionId;
  set choosenTransactionId(String val) {
    _choosenTransactionId = val;
    notifyListeners();
  }

  String get invoiceId => _invoiceId;
  set invoiceId(String val) {
    _invoiceId = val;
    notifyListeners();
  }

  String get transactionMethod => _transactionMethod;
  set transactionMethod(String val) {
    _transactionMethod = val;
    notifyListeners();
  }

  double get transactionAmount => _transactionAmount;
  set transactionAmount(double val) {
    _transactionAmount = val;
    notifyListeners();
  }

  DateTime get transactionDate => _transactionDate;
  set transactionDate(DateTime val) {
    _transactionDate = val;
    notifyListeners();
  }

  String get transactionDescription => _transactionDescription;
  set transactionDescription(String val) {
    _transactionDescription = val;
    notifyListeners();
  }

  List<dynamic> get expenses => _expenses;
  set expenses(List<dynamic> val) {
    _expenses = val;
    notifyListeners();
  }

  double get totalInvoicesPaid => _totalInvoicesPaid;
  set totalInvoicesPaid(double val) {
    _totalInvoicesPaid = val;
    notifyListeners();
  }

  double get totalExpensesAmount => _totalExpensesAmount;
  set totalExpensesAmount(double val) {
    _totalExpensesAmount = val;
    notifyListeners();
  }

  List<dynamic> get kostMonthlyReport => _kostMonthlyReport;
  set kostMonthlyReport(List<dynamic> val) {
    _kostMonthlyReport = val;
    notifyListeners();
  }

  List<dynamic> get transactionsTable => _transactionsTable;
  set transactionsTable(List<dynamic> val) {
    _transactionsTable = val;
    notifyListeners();
  }

  /// ################## ///
  ///       METHOD       ///
  /// ################## ///

  Future<void> updateRoomStatus() async {
    try {
      dynamic resp = await RoomApiService().updateRoomStatus(
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

  Future<void> addTenant() async {
    try {
      isBusy = true;
      if (tenantName.isEmpty) {
        isError = true;
        errorMessage = "Nama harus diisi";
      } else if (tenantPhone.isEmpty) {
        isError = true;
        errorMessage = "Telepon harus diisi";
      } else if (tenantIdNumber.isEmpty) {
        isError = true;
        errorMessage = "NIK harus diisi";
      } else if (tenantStartDate == null) {
        isError = true;
        errorMessage = "Tanggal mulai harus diisi";
      } else if (priceAmount < 1000) {
        isError = true;
        errorMessage = "Harga harus diisi";
      } else {
        await TenantApiService().createTenant(
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
          endDate: tenantStartDate?.add(Duration(days: 30)),
          paymentStatus: "unpaid",
          tenancyStatus: tenantStatus,
          roomStatus: tenantRoomStatus,
          priceAmount: priceAmount,
          priceName: priceName,
          priceDescription: priceDescription,
          priceRoomSize: priceRoomSize,
          additionalPrices: updatedAdditionalPrices,
          otherCosts: updatedOtherCost,
        );

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
        priceAmount = 0.0;
        priceName = "";
        priceDescription = null;
        priceRoomSize = 'Standard';
        updatedAdditionalPrices = [];
        updatedOtherCost = [];

        isBusy = false;
        isSuccess = true;
        successMessage = "Berhasil menambah penghuni";
      }
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

  Future<bool> fetchTenants({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    isBusy = true;
    dynamic resp = await TenantApiService().fetchTenants(
      boardingHouseId: boardingHouseId,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    tenants = resp['data'];
    isBusy = false;
    return tenants.isNotEmpty;
  }

  Future<bool> fetchTenant() async {
    isBusy = true;
    dynamic resp = await TenantApiService().fetchTenant(id: tenantId);
    tenant = resp['data'];
    isBusy = false;
    return tenant != null;
  }

  Future<void> updateTenant({
    required String tenantId,
    required String? name,
    required String? phone,
    required String? nik,
    required String? status,
    required DateTime? startDate,
    required DateTime? endDate,
    required Uint8List? imageWeb,
    required XFile? imageDevice,
  }) async {
    try {
      isBusy = true;
      dynamic resp = await TenantApiService().updateTenant(
        tenantId: tenantId,
        name: name,
        phone: phone,
        nik: nik,
        status: status,
        startDate: startDate,
        endDate: endDate,
        imageWeb: imageWeb,
        imageDevice: imageDevice,
      );
      tenant = resp['data'];
      isBusy = false;
      isSuccess = true;
      successMessage = "Berhasil update data tenant";
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

  // TODO: KOST (Boarding House) Section
  // TODO: BOILERPLATE FOR ALL CONTROLLERS

  Future<void> createKost() async {
    try {
      isBusy = true;
      await BoardingHouseApiService().createKost(
        name: kostName,
        address: kostAddress,
        description: kostDescription,
      );
      await fetchKosts();
      isSuccess = true;
      successMessage = "Berhasil create kost ";
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
      var resp = await BoardingHouseApiService().fetchKosts();
      kosts = resp['data'];
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

      await RoomApiService().createRoom(
        boardingHouseId: roomKostId,
        roomNumber: roomNumber,
        roomSize: 'Standard',
        roomStatus: roomStatus ?? "",
        description: description,
      );

      await fetchRooms(
        boardingHouseId: roomKostId,
        dateFrom: null,
        dateTo: null,
      );

      roomKostId = null;
      roomKostName = null;
      roomNumber = "";
      roomSize = "";
      selectedRoomSize = null;
      roomStatus = "Tersedia";
      basicPrice = 0;
      successMessage = "Tambah kamar berhasil.";
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

  Future<void> fetchRooms({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    try {
      isBusy = true;
      var resp = await RoomApiService().fetchRooms(
        boardingHouseId: boardingHouseId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
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
        var resp = await RoomApiService().fetchRoom(roomId: roomId);
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
        var resp = await RoomApiService().updateRoom(
          roomId: roomId,
          roomUpdateData: {},
          additionalPrices: updatedAdditionalPrices,
          otherCost: updatedOtherCost,
        );
        room = resp['data'];
        isSuccess = true;
        successMessage = "Berhasil menambah harga";
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
      await PriceApiService().createPrice(
        boardingHouseId: roomKostId,
        name: priceName,
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
      var resp = await PriceApiService().fetchPrices();
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

  // TODO:  TRANSACTION AND INVOICE

  Future<void> fetchInvoicesx({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    isBusy = true;
    try {
      var resp = await TransactionInvoiceApiService().getAllInvoices(
        boardingHouseId: boardingHouseId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      invoices = resp['data'];
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

  Future<void> fetchInvoice() async {
    isBusy = true;
    try {
      var resp = await TransactionInvoiceApiService().getInvoice(
        id: choosenInvoiceId,
      );
      invoice = resp['data'];
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

  Future<void> recordTransaction() async {
    try {
      isBusy = true;
      await TransactionInvoiceApiService().recordTransaction(
        invoiceId: invoiceId,
        transactionDate: transactionDate,
        method: transactionMethod,
        amount: transactionAmount,
        description: transactionDescription,
      );
      // await fetchPrices();

      invoiceId = "";
      transactionAmount = 0;
      transactionMethod = "";
      transactionDescription = "";
      transactionDate = DateTime.now();
      isSuccess = true;
      successMessage = "Pembayaran berhasil";
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

  Future<void> createExpense({
    required String? category, // Optional
    required String name,
    required double amount,
    required DateTime? expenseDate,
    required String? paymentMethod,
    required String? description, // Optional
  }) async {
    isBusy = true;
    try {
      if (expenseDate == null) {
        isError = true;
        errorMessage = "Tanggal pembayaran harus diisi";
      } else if (name.isEmpty) {
        isError = true;
        errorMessage = "Peruntukan pembayaran harus diisi";
      } else if (amount < 1000) {
        isError = true;
        errorMessage = "Jumlah harus diisi";
      } else if (roomKostId == null) {
        isError = true;
        errorMessage = "Kost harus dipilih";
      } else {
        await ExpenseApiService().createExpense(
          boardingHouseId: roomKostId,
          category: category,
          name: name,
          amount: amount,
          expenseDate: expenseDate,
          paymentMethod: paymentMethod,
          description: description,
        );

        isSuccess = true;
        successMessage = "Pembayaran berhasil";
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

  Future<void> getMonthlyReport({
    required String? boardingHouseId,
    required int month,
    required int year,
  }) async {
    isBusy = true;
    try {
      var resp = await ReportApiService().getMonthlyReport(
        boardingHouseId: boardingHouseId,
        month: month,
        year: year,
      );

      kostMonthlyReport = resp['data'];
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

  Future<void> getFinancialOverview({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    isBusy = true;
    final now = DateTime.now();

    try {
      var resp = await ReportApiService().getFinancialOverview(
        boardingHouseId: boardingHouseId,
        dateFrom: dateFrom ?? DateTime(now.year, now.month),
        dateTo:
            dateTo ??
            DateTime(now.year, now.month + 1).subtract(Duration(seconds: 1)),
      );

      invoices = resp['data']['invoices'];
      expenses = resp['data']['expenses'];
      totalInvoicesPaid = resp['data']['totalInvoicesPaid'].toDouble();
      totalExpensesAmount = resp['data']['totalExpensesAmount'].toDouble();
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

  Future<void> getFinancialTransactions({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    isBusy = true;
    transactionsTable = [];
    totalInvoicesPaid = 0;
    totalExpensesAmount = 0;

    final now = DateTime.now();

    try {
      var resp = await ReportApiService().getFinancialTransactions(
        boardingHouseId: boardingHouseId,
        dateFrom: dateFrom ?? DateTime(now.year, now.month),
        dateTo:
            dateTo ??
            DateTime(now.year, now.month + 1).subtract(Duration(seconds: 1)),
      );

      transactionsTable = resp['data'];
      totalInvoicesPaid = resp['summary']['totalInvoicesPaid'].toDouble();
      totalExpensesAmount = resp['summary']['totalExpensesAmount'].toDouble();
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
