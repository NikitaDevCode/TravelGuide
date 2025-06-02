import '/libraries/controllers.dart';
import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';

class ThemeStateController extends GetxController {
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;
  void changeThemeMode(ThemeMode value) {
    final settingsController = Get.find<SettingsController>();
    _themeMode.value = value;
    Get.changeThemeMode(_themeMode.value);
    settingsController.saveSettings();
  }
  void getThemeMode() {

  }
}