import '/libraries/services.dart';
import '/libraries/custom_packages.dart';

class AuthStateController extends GetxController {
  final _isAuthorized = false.obs;
  bool get isAuthorized => _isAuthorized.value;
  void changeAuthState() {
    _isAuthorized.value = !_isAuthorized.value;
  }
  @override
  void onInit() {
    super.onInit();
    _isAuthorized.value = SharedPrefService().getBoolData('isAuthorized') ?? false;
  }
}