import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/libraries/system_packages.dart';
import '/libraries/enums.dart';
import '/libraries/custom_packages.dart';
import '/libraries/custom_packages.dart' as http;
// Используем пакет для работы с версиями

class UpdateController extends GetxController {
  final _selectedVersion = VersionType.release.obs;
  VersionType get selectedVersion => _selectedVersion.value;

  void setSelectedVersion(VersionType value) {
    _selectedVersion.value = value;
  }

  Future<ApiResponse> checkForUpdates() async {
    final currentVersion = (await PackageInfo.fromPlatform()).version;
    final allReleases = await _getReleasesFromGitHub();

    if (allReleases.isEmpty) {
      DialogService().showSnackBarMessage('Ошибка', 'Не удалось получить список релизов');
      return ApiResponse(success: false);
    }

    final selectedType = _selectedVersion.value;
    final filteredReleases = _filterReleases(allReleases, selectedType);
    final latestRelease = filteredReleases.isNotEmpty ? filteredReleases.first : null;

    if (latestRelease == null) {
      DialogService().showSnackBarMessage('Информация', 'Обновлений нет');
      return ApiResponse(success: true);
    }

    final latestParsed = _parseVersion(latestRelease['tag_name']);
    final currentParsed = _parseVersion(currentVersion);

    if (currentParsed != null && latestParsed != null) {
      bool isUpdateAvailable = latestParsed > currentParsed;

      if (isUpdateAvailable) {
        DialogService().showSnackBarMessage('Информация', 'Доступно обновление!');
      } else {
        DialogService().showSnackBarMessage('Информация', 'Обновлений нет');
      }
    }

    return ApiResponse(success: true);
  }

  Version? _parseVersion(String version) {
    try {
      return Version.parse(version.replaceFirst('v', '')); // Удаляем 'v' из тега
    } catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Ошибка парсинга версии');
      return null;
    }
  }

  Future<List<dynamic>> _getReleasesFromGitHub() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/NikitaDevCode/TravelGuide/releases?per_page=100&prerelease=true'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data;
      }
    } catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Ошибка получения данных с GitHub');
    }
    return [];
  }

  List<dynamic> _filterReleases(List<dynamic> releases, VersionType type) {
    // Сортируем релизы по дате публикации (самые новые в начале)
    releases.sort((a, b) => b['published_at'].compareTo(a['published_at']));

    switch (type) {
      case VersionType.alpha:
        return releases.where((release) {
          final version = _parseVersion(release['tag_name']);
          return version?.isPreRelease ?? false; // Любые предварительные версии
        }).toList();
      case VersionType.beta:
        return releases.where((release) {
          final version = _parseVersion(release['tag_name']);
          return (version?.isPreRelease ?? false) && release['tag_name'].toLowerCase().contains('beta');
        }).toList();
      case VersionType.release:
        return releases.where((release) => !release['prerelease']).toList();
    }
  }
}