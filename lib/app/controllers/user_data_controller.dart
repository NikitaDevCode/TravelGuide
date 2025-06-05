import '/libraries/services.dart';
import '/libraries/api.dart';
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
    final data = await UserDataDatabase().getUserData(userId);
    if (data == null) {
      await UserDataDatabase().createDefaultUserData(userId);
      final fallbackData = await UserDataDatabase().getUserData(userId);
      _userData.value = fallbackData ?? _userData.value;
    } 
    else {
      _userData.value = data;
    }
    _getSettings(_userData.value);
  }
  Future<void> syncUserdata() async {
    final localUserData = await UserDataDatabase().getUserData(_setupController.user!.id);
    if (localUserData != null) {
      await ApiSyncData().postUserData(localUserData);
    }
    final apiResponse = await ApiSyncData().getUserData(_setupController.user!.id);
    if (apiResponse.success) {
      final serverUserData = apiResponse.data as UserData;
      _userData.value = serverUserData;
      _getSettings(_userData.value);
      UserDataDatabase().updateUserData(_userData.value);
      DialogService().showSnackBarMessage('Информация', 'Данные синхронизированы');
    }
  }
  Future<void> deleteUserData(int userId) async {
    await UserDataDatabase().deleteUserData(userId);
    await UserDataDatabase().createDefaultUserData(_setupController.user!.id);
    await getUserData(_setupController.user!.id);
  }

  void _getSettings(UserData userData) {
    final themeStateController = Get.find<ThemeStateController>();
    final notificationStateController = Get.find<NotificationStateController>();
    final favoriteController = Get.find<FavoriteController>();
    final securityStateController = Get.find<SecurityStateController>();
    if (_userData.value.settings.isNotEmpty) {
      final settings = jsonDecode(userData.settings);
      themeStateController.changeThemeMode(ThemeMode.values[settings['themeMode']]);
      notificationStateController.changeStatusNotification(settings['isEnableNotif'] ?? true);
      notificationStateController.changeTypeNotification(NotificationType.values[settings['notificationType'] ?? NotificationType.all]);
      securityStateController.setSyncEnabled(settings['isEnableSyncUserData'] ?? false);
    }
    if (_userData.value.favoriteExhibits.isNotEmpty) {
      final exhibitsJson = jsonDecode(userData.favoriteExhibits) as List<dynamic>;
      final exhibits = exhibitsJson.map((e) => Exhibit.fromMap(e)).toList();
      favoriteController.exhibits.addAll(exhibits);
    }
  }
}