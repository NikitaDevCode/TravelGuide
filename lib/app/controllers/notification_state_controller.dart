import '/libraries/controllers.dart';
import '/libraries/enums.dart';
import '/libraries/custom_packages.dart';

class NotificationStateController extends GetxController {
  final _isEnable = true.obs;
  final _notificationType = NotificationType.all.obs;
  bool get isEnable => _isEnable.value;
  NotificationType get notificationType => _notificationType.value;
  void changeStatusNotification(bool value) {
    final settingsController = Get.find<SettingsController>();
    _isEnable.value = value;
    settingsController.saveSettings();
  }
  void changeTypeNotification(NotificationType value) {
    final settingsController = Get.find<SettingsController>();
    _notificationType.value = value;
    settingsController.saveSettings();
  }
}