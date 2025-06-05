import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/libraries/system_packages.dart';
import '/libraries/enums.dart';
import '/libraries/custom_packages.dart';
import '/libraries/custom_packages.dart' as http;
class UpdateController extends GetxController {
  final _selectedVersion = VersionType.release.obs;
  VersionType get selectedVersion => _selectedVersion.value;
  void setSelectedVersion(VersionType value) {
    _selectedVersion.value = value;
  }
  Future<ApiResponse> checkForUpdates() async {
    final currentVersion = (await PackageInfo.fromPlatform()).version;
    final latestVersionTag = await _getLatestVersionFromGitHub();

    // Получаем выбранный тип версии
    final selectedType = _selectedVersion.value;

    // Фильтруем релизы по типу
    final latestParsed = _parseVersion(latestVersionTag);
    final currentParsed = _parseVersion(currentVersion);

    if (currentParsed != null && latestParsed != null) {
      bool isUpdateAvailable = false;
      switch (selectedType) {
        case VersionType.alpha:
          isUpdateAvailable = latestParsed > currentParsed;
          break;
        case VersionType.beta:
          isUpdateAvailable = latestParsed > currentParsed && !latestParsed.isPreRelease;
          break;
        case VersionType.release:
          isUpdateAvailable = latestParsed > currentParsed && !latestParsed.isPreRelease;
          break;
      }
      if (isUpdateAvailable) {
        DialogService().showSnackBarMessage('Информация', 'Доступно обновление');
      }
      DialogService().showSnackBarMessage('Информация', 'Обновлений нет');
    }
    return ApiResponse(success: true);
  }
  Version? _parseVersion(String version) {
    try {
      return Version.parse(version);
    } 
    catch (_) {
      DialogService().showSnackBarMessage('Информация', 'Ошибка парсинга версии');
      return null;
    }
  }
  Future<String> _getLatestVersionFromGitHub() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/NikitaDevCode/TravelGuide/releases/latest'), 
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['tag_name'] as String;
      }
    }
    catch (_) {
      DialogService().showSnackBarMessage('Информация', 'Ошибка получения версии');
    }
    return '';
  }
}