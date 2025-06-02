import '/libraries/system_packages.dart';
import '/libraries/services.dart';
import '/libraries/models.dart';
import '/app/core/base_repository.dart';

class UserRepository extends BaseRepository<User> {
  UserRepository._internal();
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;

  static const String _userKey = 'current_user';

  @override
  Future<void> save(User user) async {
    final userJson = jsonEncode(user.toMap());
    await SharedPrefService().saveStringData(_userKey, userJson);
  }

  @override
  Future<User?> get() async {
    final userJson = SharedPrefService().getStringData(_userKey);
    if (userJson == null) return null;
    return User.fromMap(jsonDecode(userJson));
  }

  @override
  Future<void> clear() async {
    await SharedPrefService().removeData(_userKey);
  }
}