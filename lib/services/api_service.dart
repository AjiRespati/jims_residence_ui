// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/utils/helpers.dart';

import '../../application_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // ✅ Use this one!
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = ApplicationInfo.baseUrl;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  /// AUTH ROUTES
  /// /register'
  /// /login',
  /// /refresh',
  /// /logout',

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"refreshToken": refreshToken}),
    );
    if (response.statusCode == 200) {
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    return response.statusCode < 400;
  }

  Future<String?> refreshAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode < 400) {
      String newAccessToken = jsonDecode(response.body)['accessToken'];
      await prefs.setString('accessToken', newAccessToken);
      return newAccessToken;
    } else {
      return null;
      // throw Exception(
      //   jsonDecode(response.body)['message'] ?? 'Internal service error',
      // );
    }
  }

  // TODO: ROOMS ROUTES

  Future<bool> createRoom({
    required String? boardingHouseId,
    required String roomNumber,
    required String roomSize,
    required String roomStatus,
    required String priceId,
    required String description,
  }) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/room'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'boardingHouseId': boardingHouseId,
        'roomNumber': roomNumber,
        'roomSize': roomSize,
        'roomStatus': roomStatus,
        'description': description,
        'priceId': priceId,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return createRoom(
        boardingHouseId: boardingHouseId,
        roomNumber: roomNumber,
        roomSize: roomSize,
        roomStatus: roomStatus,
        description: description,
        priceId: priceId,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchRooms() async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/room'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchRooms();
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchRoom({required String roomId}) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/room/$roomId'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchRoom(roomId: roomId);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> updateRoom({
    required String roomId,
    required dynamic roomUpdateData,
    required List<dynamic> additionalPrices,
    required List<dynamic> otherCost,
  }) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/room/$roomId'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'roomUpdateData': roomUpdateData,
        'additionalPrices': additionalPrices,
        'otherCost': otherCost,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return updateRoom(
        roomId: roomId,
        roomUpdateData: roomUpdateData,
        additionalPrices: additionalPrices,
        otherCost: otherCost,
      );
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> updateRoomStatus({
    required String roomId,
    required String roomStatus,
  }) async {
    String? token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/room/$roomId'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'roomStatus': roomStatus}),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchRoom(roomId: roomId);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  // TODO: TENANT ROUTES

  Future<bool> createTenant({
    required String roomId,
    required String name,
    required String phone,
    required String idNumber,
    required String? idImagePath,
    required bool isNIKCopyDone,
    required String tenancyStatus,
    required String? roomStatus,
    required DateTime? startDate,
    required DateTime? dueDate,
    required DateTime? banishDate,
    required DateTime? paymentDate,
    required String paymentStatus,
  }) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/tenant'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'roomId': roomId,
        'name': name,
        'phone': phone,
        'NIKNumber': idNumber,
        'startDate': startDate == null ? null : generateDateString(startDate),
        'dueDate': dueDate == null ? null : generateDateString(dueDate),
        'banishDate':
            banishDate == null ? null : generateDateString(banishDate),
        'NIKImagePath': idImagePath,
        'isNIKCopyDone': isNIKCopyDone,
        'tenancyStatus': tenancyStatus,
        'roomStatus': roomStatus,
        'paymentDate':
            paymentDate == null ? null : generateDateString(paymentDate),
        'paymentStatus': paymentStatus,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return createTenant(
        roomId: roomId,
        name: name,
        phone: phone,
        idNumber: idNumber,
        idImagePath: idImagePath,
        tenancyStatus: tenancyStatus,
        roomStatus: roomStatus,
        dueDate: dueDate,
        banishDate: banishDate,
        paymentDate: paymentDate,
        startDate: startDate,
        isNIKCopyDone: isNIKCopyDone,
        paymentStatus: paymentStatus,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchTenants() async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/tenant'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchTenants();
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchTenant({required String id}) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/tenant/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchTenant(id: id);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> updateTenant({
    required String tenantId,
    required Uint8List? imageWeb,
    required XFile? imageDevice,
  }) async {
    String? token = await _getToken();

    var request = http.MultipartRequest(
      "PUT",
      Uri.parse('$baseUrl/tenant/$tenantId'),
    );
    request.headers['Authorization'] = "Bearer $token";

    // request.fields["name"] = name;
    // request.fields["description"] = description;
    // request.fields["price"] = price.toString();
    // request.fields["metricType"] = metric; // ✅ Add metric field

    // ✅ Handle Web (File Picker)
    if (kIsWeb && imageWeb != null) {
      Uint8List imageBytes = imageWeb;
      try {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: "NIK_image.png",
            contentType: MediaType('image', 'png'),
          ),
        );
        print('NIK image file added to the request.');
      } catch (e) {
        print('Error adding NIK image file to request: $e');
        // Handle the error (e.g., file access issues)
        rethrow; // Re-throw the exception
      }
    }
    // ✅ Handle Mobile (Gallery & Camera)
    else if (!kIsWeb && imageDevice != null) {
      XFile imageFile = XFile(imageDevice.path);
      try {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', 'png'),
          ),
        );
      } catch (e) {
        print('Error adding NIK image file to request: $e');
        // Handle the error (e.g., file access issues)
        rethrow; // Re-throw the exception
      }
    }

    // var response = await request.send();

    // --- Send the Request ---
    try {
      var streamedResponse = await request.send();

      // --- Process the Response ---
      // Convert the streamed response to a standard HTTP response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        token = await refreshAccessToken();
        if (token == null) throw Exception("please reLogin");
        return updateTenant(
          tenantId: tenantId,
          imageWeb: imageWeb,
          imageDevice: imageDevice,
        );
      } else if (response.statusCode == 200) {
        // ✅ Success: You can parse the response body if your backend returns data
        final responseData = json.decode(response.body);
        return responseData; // Return the data if needed
      } else {
        // ❌ Failure: Handle different error status codes (400, 404, 500, etc.)
        // Throw an exception to indicate failure
        throw Exception(
          'Failed to update tenant. Status: ${response.statusCode}. Body: ${response.body}',
        );
      }
    } catch (e) {
      // ❌ Network or Request Error
      // Throw an exception
      throw Exception('Error updating tenant: $e');
    }
  }

  // ✅ Pick Image for Mobile (Gallery & Camera)
  Future<XFile?> pickImageMobile(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: source);
  }

  // ✅ Pick Image for Web
  Future<Uint8List?> pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      return result.files.first.bytes;
    }
    return null;
  }

  Future<bool> deleteTenant({required String id}) async {
    String? token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/tenant/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return deleteTenant(id: id);
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  // TODO: ADDITIONAL PRICES ROUTES

  Future<bool> createAdditionalPrice({
    required String roomId,
    required String name,
    required double amount,
    required String? description,
  }) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/additionalPrice'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'roomId': roomId,
        'name': name,
        'amount': amount,
        'description': description,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return createAdditionalPrice(
        roomId: roomId,
        name: name,
        amount: amount,
        description: description,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  // TODO: BOARDING HOUSE ROUTES
  /// GET /
  /// POST /

  Future<bool> createKost({
    required String name,
    required String address,
    required String description,
  }) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/boardingHouse'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'description': description,
      }),
    );
    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return createKost(name: name, address: address, description: description);
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<List<dynamic>> fetchKosts() async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/boardingHouse'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchKosts();
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  // TODO: PRICE ROUTES

  Future<bool> createPrice({
    required String? roomSize,
    required String? boardingHouseId,
    required String name,
    required double amount,
    required String? description,
  }) async {
    String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/price'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'boardingHouseId': boardingHouseId,
        'roomSize': roomSize,
        'name': name,
        'amount': amount,
        'description': description,
      }),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return createPrice(
        boardingHouseId: boardingHouseId,
        name: name,
        amount: amount,
        roomSize: roomSize,
        description: description,
      );
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchPrices() async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/price'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchPrices();
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchPrice({required String id}) async {
    String? token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/price/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return fetchPrice(id: id);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> updatePrice({
    required String id,
    required dynamic updateItems,
  }) async {
    String? token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/price/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(updateItems),
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return updatePrice(id: id, updateItems: updateItems);
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<bool> deletePrice({required String id}) async {
    String? token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/price/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      token = await refreshAccessToken();
      if (token == null) throw Exception("please reLogin");
      return deletePrice(id: id);
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }
}
