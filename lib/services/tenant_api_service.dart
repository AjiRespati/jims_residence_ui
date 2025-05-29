import 'dart:convert';
import 'dart:typed_data'; // Required for Uint8List
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Required for kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Required for MediaType
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory
import 'package:residenza/utils/helpers.dart'; // Assuming helpers.dart is in the utils directory

class TenantApiService extends BaseApiService {
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
    required DateTime? endDate,
    required String paymentStatus,
    required double priceAmount,
    required String? priceName,
    required String? priceDescription,
    required String? priceRoomSize,
    required List<dynamic>? additionalPrices,
    required List<dynamic>? otherCosts,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
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
          'endDate': endDate == null ? null : generateDateString(endDate),
          'NIKImagePath': idImagePath,
          'isNIKCopyDone': isNIKCopyDone,
          'tenancyStatus': tenancyStatus,
          'roomStatus': roomStatus,
          'paymentDate':
              paymentDate == null ? null : generateDateString(paymentDate),
          'paymentStatus': paymentStatus,
          'priceAmount': priceAmount,
          'priceName': priceName,
          'priceDescription': priceDescription,
          'priceRoomSize': priceRoomSize,
          'additionalPrices': additionalPrices,
          'otherCosts': otherCosts,
        }),
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchTenants({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    String url = "$baseUrl/tenant";
    if (boardingHouseId != null && boardingHouseId.isNotEmpty) {
      url =
          url.contains("?")
              ? "$url&boardingHouseId=$boardingHouseId"
              : "$url?boardingHouseId=$boardingHouseId";
    }
    if (dateFrom != null) {
      url =
          url.contains("?")
              ? "$url&dateFrom=${generateDateString(dateFrom)}" // Using helper
              : "$url?dateFrom=${generateDateString(dateFrom)}"; // Using helper
    }
    if (dateTo != null) {
      url =
          url.contains("?")
              ? "$url&dateTo=${generateDateString(dateTo)}"
              : "$url?dateTo=${generateDateString(dateTo)}"; // Using helper
    }

    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> fetchTenant({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/tenant/$id'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }

  Future<dynamic> updateTenant({
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
    String? token = await getToken(); // Using the base class method

    var request = http.MultipartRequest(
      "PUT",
      Uri.parse('$baseUrl/tenant/$tenantId'),
    );
    request.headers['Authorization'] = "Bearer $token";

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
      } catch (e) {
        rethrow;
      }
    } else if (!kIsWeb && imageDevice != null) {
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
        rethrow;
      }
    }

    if (name != null) {
      request.fields['name'] = name;
    }
    if (phone != null) {
      request.fields['phone'] = phone;
    }
    if (nik != null) {
      request.fields['NIKNumber'] = nik;
    }
    if (status != null) {
      request.fields['tenancyStatus'] = status;
    }
    if (startDate != null) {
      request.fields['startDate'] = generateDateString(startDate);
    }
    if (endDate != null) {
      request.fields['endDate'] = generateDateString(endDate);
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        token = await refreshAccessToken(); // Using the base class method
        if (token == null) throw Exception("please reLogin");
        // Retry the request with the new token
        request.headers['Authorization'] = "Bearer $token";
        streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception(
          'Failed to update tenant. Status: ${response.statusCode}. Body: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating tenant: $e');
    }
  }

  Future<XFile?> pickImageMobile(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: source);
  }

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
    final response = await performAuthenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/tenant/$id'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Internal service error',
      );
    }
  }
}
