
import 'package:get/get.dart';

class ApiClient extends GetConnect {
  static const String apiBaseUrl = 'http://10.0.2.2:3000/api';
  static const String reportEndpoint = '/events';

  @override
  void onInit() {
    httpClient.baseUrl = apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 20);
    super.onInit();
  }

  Future<Response<dynamic>> getRequest(String endpoint) async {
    return await get(endpoint);
  }

  Future<Response<dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    // ignore: avoid_print
    print('API POST: ${httpClient.baseUrl}$endpoint');
    // ignore: avoid_print
    print('Request body: $body');

    final response = await post(endpoint, body);

    // ignore: avoid_print
    print('Response status: ${response.statusCode}');
    // ignore: avoid_print
    print('Response body: ${response.body}');

    return response;
  }
}
