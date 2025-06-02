// Кастомное исключение для ошибок API
class ApiException implements Exception {
  int statusCode;
  String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}