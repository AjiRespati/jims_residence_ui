import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residenza/utils/helpers.dart';
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory

class TransferOwnerApiService extends BaseApiService {
  Future<bool> createTransferOwner({
    required String? boardingHouseId,
    required double amount,
    required DateTime transferDate,
    required String? description, // Optional
    required Uint8List? imageWeb,
    required XFile? imageDevice,
  }) async {
    // final response = await performAuthenticatedRequest(
    //   (token) => http.post(
    //     Uri.parse('$baseUrl/transferOwner'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       "Authorization": "Bearer $token",
    //     },
    //     body: jsonEncode({
    //       'boardingHouseId': boardingHouseId,
    //       'amount': amount,
    //       'transferDate': generateDateString(transferDate),
    //       'description': description,
    //     }),
    //   ),
    // );

    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   throw Exception(
    //     jsonDecode(response.body)['message'] ?? 'Internal service error',
    //   );
    // }

    String? token = await getToken(); // Using the base class method

    var request = http.MultipartRequest(
      "POST",
      Uri.parse('$baseUrl/transferOwner'),
    );
    request.headers['Authorization'] = "Bearer $token";

    if (kIsWeb && imageWeb != null) {
      Uint8List imageBytes = imageWeb;
      try {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: "bukti_transfer.png",
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

    if (boardingHouseId != null) {
      request.fields['boardingHouseId'] = boardingHouseId;
    }
    request.fields['amount'] = amount.toString();
    request.fields['transferDate'] = generateDateString(transferDate);
    if (description != null) {
      request.fields['description'] = description;
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        token = await refreshAccessToken(); // Using the base class method
        if (token == null) throw Exception("Please re-login");
        // Retry the request with the new token
        request.headers['Authorization'] = "Bearer $token";
        streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      }

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to transferOwner. Status: ${response.statusCode}. Body: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error transferOwner: $e');
    }
  }

  Future<dynamic> getAllTransferOwner({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    String url = "$baseUrl/transferOwner";
    if (boardingHouseId != null && boardingHouseId.isNotEmpty) {
      url =
          url.contains("?")
              ? "$url&boardingHouseId=$boardingHouseId"
              : "$url?boardingHouseId=$boardingHouseId";
    }
    if (dateFrom != null) {
      url =
          url.contains("?")
              ? "$url&dateFrom=$dateFrom"
              : "$url?dateFrom=$dateFrom";
    }
    if (dateTo != null) {
      url = url.contains("?") ? "$url&dateTo=$dateTo" : "$url?dateTo=$dateTo";
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
}
