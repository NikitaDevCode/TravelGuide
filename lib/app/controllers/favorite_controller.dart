import '/libraries/controllers.dart';
import '/libraries/database.dart';
import '/libraries/system_packages.dart';
import '/libraries/services.dart';
import '/libraries/models.dart';
import '/libraries/custom_packages.dart';

class FavoriteController extends GetxController {
  
  
  final _exhibits = <Exhibit>[].obs;
  List<Exhibit> get exhibits => _exhibits;
  void addExhibit(Exhibit value) {
    final isExists = _exhibits.any((e) => e.id == value.id);
    if (isExists) {
      DialogService().showSnackBarMessage('Информация', 'Экспонат уже в избранном');
      return;
    }
    _exhibits.add(value);
    _saveFavoriteExhibitsToDatabase();
  }
  void removeExhibit(Exhibit value) {
    _exhibits.remove(value);
    _saveFavoriteExhibitsToDatabase();
  }
  void _saveFavoriteExhibitsToDatabase() {
    final userDataController = Get.find<UserDataController>();
    final favoriteExhibits = _exhibits.map((e) => e.toMap()).toList();
    final favoriteExhibitsJson = jsonEncode(favoriteExhibits);
    UserDataDatabase().updateFavoriteExhibits(userDataController.userData.userId, favoriteExhibitsJson);
  }
}