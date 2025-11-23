import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:residenza/utils/helpers.dart';
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory

class TransferOwnerApiService extends BaseApiService {
  Future<bool> createExpense({
    required String? boardingHouseId,
    required double amount,
    required DateTime transferDate,
    required String? description, // Optional
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/transferOwner'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'boardingHouseId': boardingHouseId,
          'amount': amount,
          'transferDate': generateDateString(transferDate),
          'description': description,
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

  Future<dynamic> getAllTransferOwner({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    String url = "$baseUrl/expense";
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
