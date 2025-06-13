import '/libraries/services.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
//Класс инициализирующий различные компоненты
class AppInitialize {
  static void initializeControllers() {
    Get.put<AuthStateController>(AuthStateController());
    Get.put<LoadingStateController>(LoadingStateController());
    Get.put<UpdateController>(UpdateController());
    Get.put<SetupController>(SetupController());
    Get.put<UserDataController>(UserDataController());
    Get.put<ThemeStateController>(ThemeStateController());
    Get.put<NotificationStateController>(NotificationStateController());
    Get.put<SecurityStateController>(SecurityStateController());
    Get.put<FavoriteController>(FavoriteController());
    Get.put<SettingsController>(SettingsController());
    Get.put<NotificationController>(NotificationController());
    
  }
  static Future<void> intializeSharedPref() async {
    await SharedPrefService.initSharedPref();
  }
  static Future<void> intializeNotifications() async {
    NotificationService().initialize();
  }
  static Future<void> intializeServices() async {
    AutoLogoutService().initService();
  }
}