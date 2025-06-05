import '/libraries/system_packages.dart';
import '/libraries/database.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';

class SettingsController extends GetxController {
  void saveSettings() {
    final userDataController = Get.find<UserDataController>();
    final themeStateController = Get.find<ThemeStateController>();
    final notificationController = Get.find<NotificationStateController>();
    final securityStateController = Get.find<SecurityStateController>();
    final settings = {
      'themeMode': themeStateController.themeMode.index,
      'isEnableNotif': notificationController.isEnable,
      'notificationType': notificationController.notificationType.index,
      'isEnableSyncUserData': securityStateController.isEnableSyncUserData
    };
    final settingsJson = jsonEncode(settings);
    UserDataDatabase().updateSettings(userDataController.userData.userId, settingsJson);
  }
}