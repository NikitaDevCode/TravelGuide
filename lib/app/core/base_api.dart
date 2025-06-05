import '/libraries/enums.dart';
import '/libraries/classes.dart';
import '/libraries/configs.dart';
import '/libraries/custom_packages.dart' as http;
import '/libraries/system_packages.dart';
abstract class BaseApi {
  String baseUrl = ApiConfig.baseUrl;
  Future<http.Response> _makeRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      return _handleResponse(response);
    }
    on SocketException catch (_) {
      throw ApiException(-1, 'Нет подключения к интернету');
    }
    on TimeoutException catch (_) {
      throw ApiException(-2, 'Время ожидания истекло');
    }
    catch (e) {
      throw ApiException(-3, e.toString());
    }
  }
  Future<http.Response> httpMethod(ApiMethod apiMethod, String endpoint, {Object? body, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    return _makeRequest(() {
      switch (apiMethod) {
        case ApiMethod.get:
        return http.get(
          uri,
          headers: _defaultHeaders(headers)
        );
        case ApiMethod.post:
        return http.post(
          uri,
          body: body != null ? jsonEncode(body) : null,
          headers: _defaultHeaders(headers)
        );
        case ApiMethod.delete:
        return http.delete(
          uri,
          body: body != null ? jsonEncode(body) : null,
          headers: _defaultHeaders(headers)
        );
        case ApiMethod.put:
        return http.put(
          uri,
          body: body != null ? jsonEncode(body) : null,
          headers: _defaultHeaders(headers)
        );
      }
      
    });
  }
  Map<String, String> _defaultHeaders(Map<String, String>? headers) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300 && response.statusCode != 401) {
      final message = _parseErrorMessage(response);
      throw ApiException(response.statusCode, message);
    }
    return response;
  }
  String _parseErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body.toString();
    } 
    catch (e) {
      return 'Ошибка сервера';
    }
  }
}