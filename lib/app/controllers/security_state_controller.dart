import '/libraries/database.dart';
import '/libraries/models.dart';
import '/libraries/api.dart';
import '/libraries/controllers.dart';
import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';

class SecurityStateController extends GetxController {
  final _isEnableSyncUserData = false.obs;
  bool get isEnableSyncUserData => _isEnableSyncUserData.value;
  Timer? _syncTimer;
  void setSyncEnabled(bool value) {
    final settingsController = Get.find<SettingsController>();
    _isEnableSyncUserData.value = value;
    settingsController.saveSettings();
    if (_isEnableSyncUserData.value) {
      startSync();
    } 
    else {
      stopSync();
    }
  }

  void startSync() {
    _syncTimer = Timer.periodic(const Duration(minutes: 1), (_) => _syncData());
  }
  Future<void> _syncData() async {
    final userDataController = Get.find<UserDataController>();
    final localUserData = await UserDataDatabase().getUserData(userDataController.userData.userId);
    if (localUserData != null) {
      await ApiSyncData().postUserData(localUserData);
    }
    final apiResponse = await ApiSyncData().getUserData(userDataController.userData.userId);
    UserDataDatabase().updateUserData(apiResponse.data as UserData);
    
  }
  void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

}