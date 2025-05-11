import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory

class PriceApiService extends BaseApiService {
  Future<bool> createPrice({
    required String? roomSize,
    required String? boardingHouseId,
    required String name,
    required double amount,
    required String? description,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
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

  Future<dynamic> fetchPrices() async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/price'),
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

  Future<dynamic> fetchPrice({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/price/$id'),
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

  Future<dynamic> updatePrice({
    required String id,
    required dynamic updateItems,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.put(
        Uri.parse('$baseUrl/price/$id'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(updateItems),
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

  Future<bool> deletePrice({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/price/$id'),
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
