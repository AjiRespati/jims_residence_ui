import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../application_info.dart'; // Assuming application_info.dart is in the parent directory

class BaseApiService {
  final String baseUrl = ApplicationInfo.baseUrl;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
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
      // Consider adding proper error handling or logging here
      return null;
    }
  }

  // Helper method to handle token refresh and retry for common API calls
  Future<http.Response> performAuthenticatedRequest(
    Future<http.Response> Function(String? token) requestBuilder,
  ) async {
    String? token = await getToken();
    var response = await requestBuilder(token);

    if (response.statusCode == 401 || response.statusCode == 403) {
      token = await refreshAccessToken();
      if (token == null) {
        // Redirect to login or handle re-authentication
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('accessToken');
        throw Exception("Please re-login");
      }
      // Retry the request with the new token
      response = await requestBuilder(token);
    }

    return response;
  }
}
