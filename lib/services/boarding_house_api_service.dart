import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory

class BoardingHouseApiService extends BaseApiService {
  Future<bool> createKost({
    required String name,
    required String address,
    required String description,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
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

  Future<dynamic> fetchKosts() async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/boardingHouse'),
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
