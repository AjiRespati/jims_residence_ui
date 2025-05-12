import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory
import 'package:residenza/utils/helpers.dart'; // Assuming helpers.dart is in the utils directory

class TransactionInvoiceApiService extends BaseApiService {
  Future<dynamic> getAllInvoices({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    String url = "$baseUrl/invoice";
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

  Future<dynamic> getInvoice({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/invoice/$id'),
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

  Future<bool> recordTransaction({
    required String invoiceId,
    required DateTime transactionDate,
    required String method,
    required double amount,
    required String? description,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/transaction'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'invoiceId': invoiceId,
          'transactionDate': generateDateString(
            transactionDate,
          ), // Using helper
          'method': method,
          'amount': amount,
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

  Future<dynamic> getAllTransacations() async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/transaction'),
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

  Future<dynamic> getTransaction({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/transaction/$id'),
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
