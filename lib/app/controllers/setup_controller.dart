import '/libraries/repositories.dart';
import '/libraries/models.dart';
import '/libraries/custom_packages.dart';

class SetupController extends GetxController {
  final Rx<User?> _user = User(id: 0, email: '', login: '').obs;
  Rx<User?> get userRx => _user;
  User? get user => _user.value;
  Future<void> getUser() async {
    _user.value = await UserRepository().get();
  }
}