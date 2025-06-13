import '/app/routes/route_names.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/repositories.dart';
import '/libraries/services.dart';

class AutoLogoutService {
  final SignalRService _signalRService = SignalRService(
    'http://109.191.50.234:5000/auth_hub', 
    null
  );
  Future<void> initialize() async {
    await _signalRService.connect();
    _signalRService.connection?.on('ReceiveLogout', (args) {
      final deviceId = args![0] as String;
      _onLogoutMessage(deviceId);
    });
    _signalRService.connection?.on('ReceiveLogoutAll', (args) {
      final userId = args![0] as String;
      _onLogoutAllMessage(userId);
    });
  }
  void _onLogoutAllMessage(String userId) async {
    final user = await UserRepository().get();
    if (user != null && user.id.toString() == userId) {
      _handleLogout();
    }
  }
  Future<void> _onLogoutMessage(String deviceId) async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    final currentDeviceUniqueId = deviceInfo['uniqueId'] as String;
    if (deviceId == currentDeviceUniqueId) {
      await _handleLogout();
    }
  }
  Future<void> _handleLogout() async {
    UserRepository().clear();
    TokenRepository().clear();
    Get.find<AuthStateController>().changeAuthState();
    await SharedPrefService().saveBoolData('isAuthorized', false);
    DialogService().showSnackBarMessage('Информация', 'Вы успешно вышли из аккаунта');
    NavigationService().navigateDeleteRouteScreen(RouteNames.loginScreenRoute);

  }
  void stopConnection() {
    _signalRService.disconnect();
  }
}