import '/libraries/enums.dart';
import '/libraries/system_packages.dart';
import '/libraries/controllers.dart';
import '/libraries/database.dart';
import '/libraries/models.dart';
import '/libraries/custom_packages.dart';

class UserDataController extends GetxController {
  final _setupController = Get.find<SetupController>();
  
  @override
  void onInit() {
    super.onInit();
    ever<User?>(
      _setupController.userRx,
      (user) {
        if (user != null && user.id != 0) {
          getUserData(user.id);
        }
      }
    );
  }
  

  final _userData = UserData(userId: 0, birthDate: '', userGroup: '', age: 0, name: '', profileImagePath: '', favoriteExhibits: '', settings: '').obs;
  UserData get userData => _userData.value;
  Future<void> getUserData(int userId) async {
    final themeStateController = Get.find<ThemeStateController>();
    final notificationStateController = Get.find<NotificationStateController>();
    final favoriteController = Get.find<FavoriteController>();
    final securityStateController = Get.find<SecurityStateController>();
    // Загружаем данные из БД
    final data = await UserDataDatabase().getUserData(userId);
    // Если данных нет — создаем дефолтные и загружаем снова
    if (data == null) {
      await UserDataDatabase().createDefaultUserData(userId);
      final fallbackData = await UserDataDatabase().getUserData(userId);
      _userData.value = fallbackData ?? _userData.value; // Используем fallback
    } 
    else {
      _userData.value = data;
    }
    if (userData.settings.isNotEmpty) {
      final settings = jsonDecode(userData.settings);
      themeStateController.changeThemeMode(ThemeMode.values[settings['themeMode']]);
      notificationStateController.changeStatusNotification(settings['isEnableNotif'] ?? true);
      notificationStateController.changeTypeNotification(NotificationType.values[settings['notificationType'] ?? NotificationType.all]);
      securityStateController.setSyncEnabled(settings['isEnableSyncUserData'] ?? false);
    }

    if (userData.favoriteExhibits.isNotEmpty) {
      final exhibitsJson = jsonDecode(userData.favoriteExhibits) as List<dynamic>;
      final exhibits = exhibitsJson.map((e) => Exhibit.fromMap(e)).toList();
      favoriteController.exhibits.addAll(exhibits);
    }
  }
  Future<void> deleteUserData(int userId) async {
    await UserDataDatabase().deleteUserData(userId);
    await UserDataDatabase().createDefaultUserData(_setupController.user!.id);
    await getUserData(_setupController.user!.id);
  }
}