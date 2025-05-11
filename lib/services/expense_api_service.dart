import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory

class ExpenseApiService extends BaseApiService {
  Future<bool> createExpense({
    required String? boardingHouseId,
    required String? category, // Optional
    required String name,
    required double amount,
    required DateTime expenseDate,
    required String? paymentMethod,
    required String? description, // Optional
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/expense'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'boardingHouseId': boardingHouseId,
          'category': category,
          'name': name,
          'amount': amount,
          'expenseDate': expenseDate,
          'paymentMethod': paymentMethod,
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

  Future<dynamic> getAllExpenses({
    required String? boardingHouseId,
    required String? category,
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
    if (category != null) {
      url =
          url.contains("?")
              ? "$url&category=$category"
              : "$url?category=$category";
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
