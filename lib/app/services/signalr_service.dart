import '/libraries/custom_packages.dart';

class SignalRService {
  final Logger _logger = Logger();
  late final HubConnection? _connection;
  String url;
  SignalRService(this.url) {
    _connection = HubConnectionBuilder().withUrl(
      url,
      options: HttpConnectionOptions(
        requestTimeout: 5000
      )
    ).build();
  }

  // Метод для подключения
  Future<void> connect() async {
    try {
      await _connection?.start();
      _logger.i('Подключение прошло успешно');
    } 
    on Exception catch (e) {
      _logger.d(e);
    }
  }

  // Метод для отключения
  void disconnect() {
    _connection?.stop();
  }
  HubConnection? get connection => _connection;
}