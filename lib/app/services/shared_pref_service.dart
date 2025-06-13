import '/libraries/custom_packages.dart';

class SharedPrefService {
  SharedPrefService._internal();
  static final SharedPrefService _instance = SharedPrefService._internal();
  static SharedPreferences? _pref;
  factory SharedPrefService() => _instance;
  static Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();
  }
  Future<bool> saveStringData(String key, String data) async {
    return await _pref?.setString(key, data) ?? Future.value(false);
  }
  String? getStringData(String key) {
    return _pref?.getString(key);
  }
  Future<bool> saveIntData(String key, int data) async {
    return await _pref?.setInt(key, data) ?? Future.value(false);
  }
  int? getIntData(String key) {
    return _pref?.getInt(key);
  }
  Future<bool> saveBoolData(String key, bool data) async {
    return await _pref?.setBool(key, data) ?? Future.value(false);
  }
  bool? getBoolData(String key) {
    return _pref?.getBool(key);
  }
  Future<bool> removeData(String key) {
    return _pref?.remove(key) ?? Future.value(false);
  }
}