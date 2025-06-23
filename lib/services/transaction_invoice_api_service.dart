import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<dynamic> getAllTransactions() async {
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

  Future<dynamic> getAllCharges() async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/transaction/charges'),
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

  Future<bool> deleteTransaction({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/transaction/$id'),
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

  Future<bool> deleteInvoice({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/invoice/$id'),
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

  Future<dynamic> uploadInvoiceProof({
    required String invoiceId,
    required Uint8List? imageWeb,
    required XFile? imageDevice,
  }) async {
    String? token = await getToken(); // Using the base class method

    var request = http.MultipartRequest(
      "PUT",
      Uri.parse('$baseUrl/invoice/$invoiceId'),
    );
    request.headers['Authorization'] = "Bearer $token";

    if (kIsWeb && imageWeb != null) {
      Uint8List imageBytes = imageWeb;
      try {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: "invoice.png",
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

  Future<bool> deleteCharge({required String id}) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/transaction/remCharge'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({'id': id}),
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

  Future<bool> createOtherCost({
    required String roomId,
    required String name,
    required double amount,
    required String description,
    required bool isOneTime,
    required DateTime invoiceIssueDate,
    required DateTime invoiceDueDate,
  }) async {
    final response = await performAuthenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/otherCost'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'roomId': roomId,
          'name': name,
          'amount': amount,
          'description': description,
          'isOneTime': isOneTime,
          'invoiceIssueDate': generateDateString(invoiceIssueDate),
          'invoiceDueDate': generateDateString(invoiceDueDate),
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
}
