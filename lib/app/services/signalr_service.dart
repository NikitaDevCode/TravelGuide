import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';

class SignalRService {
  final Logger _logger = Logger();
  late final HubConnection? _connection;
  String url;
  Future<String> Function()? accessTokenFactory;
  SignalRService(this.url, this.accessTokenFactory) {
    _connection = HubConnectionBuilder().withUrl(
      url,
      options: HttpConnectionOptions(
        requestTimeout: 5000,
        accessTokenFactory: accessTokenFactory
      )
    ).build();
  }

  // Метод для подключения
  Future<void> connect() async {
    try {
      await _connection?.start();
      _logger.i('Подключение прошло успешно');
    } 
    on Exception catch (_) {
      _logger.e('Подключение не удалось');
      await Future.delayed(const Duration(seconds: 10));
      _logger.i('Повторное подключение');
      connect();
    }
  }
  // Метод для отключения
  void disconnect() {
    _connection?.stop();
  }
  HubConnection? get connection => _connection;
}