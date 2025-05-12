import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:residenza/utils/helpers.dart';
import 'base_api_service.dart'; // Assuming base_api_service.dart is in the same directory

class ReportApiService extends BaseApiService {
  Future<dynamic> getMonthlyReport({
    required String? boardingHouseId,
    required int month,
    required int year,
  }) async {
    String url = "$baseUrl/report/monthly-financial";
    if (boardingHouseId != null && boardingHouseId.isNotEmpty) {
      url =
          url.contains("?")
              ? "$url&boardingHouseId=$boardingHouseId"
              : "$url?boardingHouseId=$boardingHouseId";
    }
    url = url.contains("?") ? "$url&month=$month" : "$url?month=$month";
    url = url.contains("?") ? "$url&year=$year" : "$url?year=$year";

    var response = await performAuthenticatedRequest(
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

  Future<dynamic> getFinancialOverview({
    required String? boardingHouseId,
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async {
    String url = "$baseUrl/report/financial-overview";
    if (boardingHouseId != null && boardingHouseId.isNotEmpty) {
      url =
          url.contains("?")
              ? "$url&boardingHouseId=$boardingHouseId"
              : "$url?boardingHouseId=$boardingHouseId";
    }
    url =
        url.contains("?")
            ? "$url&dateFrom=${generateDateString(dateFrom)}"
            : "$url?dateFrom=${generateDateString(dateFrom)}";
    url =
        url.contains("?")
            ? "$url&dateTo=${generateDateString(dateTo)}"
            : "$url?dateTo=${generateDateString(dateTo)}";

    var response = await performAuthenticatedRequest(
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
