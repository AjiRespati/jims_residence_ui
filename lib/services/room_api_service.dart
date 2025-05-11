import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory
import 'package:residenza/utils/helpers.dart'; // Assuming helpers.dart is in the utils directory

class RoomApiService extends BaseApiService {
  Future<bool> createRoom({
    required String? boardingHouseId,
    required String roomNumber,
    required String roomSize,
    required String roomStatus,
    required String description,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
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

  Future<dynamic> fetchRooms({
    required String? boardingHouseId,
    required DateTime? dateFrom,
    required DateTime? dateTo,
  }) async {
    String url = "$baseUrl/room";
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

  Future<dynamic> fetchRoom({required String roomId}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/room/$roomId'),
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

  Future<dynamic> updateRoom({
    required String roomId,
    required dynamic roomUpdateData,
    required List<dynamic> additionalPrices,
    required List<dynamic> otherCost,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.put(
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

  Future<dynamic> updateRoomStatus({
    required String roomId,
    required String roomStatus,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.put(
        Uri.parse('$baseUrl/room/$roomId'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({'roomStatus': roomStatus}),
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
