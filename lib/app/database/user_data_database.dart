import 'package:path/path.dart';
import '/libraries/system_packages.dart';
import '/libraries/enums.dart';
import '/libraries/custom_packages.dart';
import '/libraries/models.dart';

class UserDataDatabase {
  UserDataDatabase._internal();
  static final UserDataDatabase _instance = UserDataDatabase._internal();
  factory UserDataDatabase() => _instance;
  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }
  Future<Database> _initDB() async {
    String pathDB = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(
      pathDB,
      version: 1,
      onCreate: (db, version) async {
        await _createUserDataDB(db, version);
      }
    );
  }
  Future<void> _createUserDataDB(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE UserData(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        name TEXT,
        age INTEGER,
        birthDate TEXT,
        userGroup TEXT,
        profileImagePath TEXT,
        favoriteExhibits TEXT,
        settings TEXT
      )
      '''
    );
  }
  Future<void> createDefaultUserData(int userId) async {
    final defaultUserData = UserData(
      userId: userId, 
      name: 'Гость', 
      age: 0, 
      birthDate: 'Не указана', 
      userGroup: 'Не указана', 
      profileImagePath: '',
      favoriteExhibits: '',
      settings: jsonEncode({
        'themeMode': ThemeMode.system.index,
        'isEnableNotif': true,
        'notificationType': NotificationType.all.index
      })
    );
    await saveUserData(defaultUserData);
  }
  Future<void> saveUserData(UserData userData) async {
    final db = await database;
    await db.insert('UserData', userData.toMap());
  }
  Future<UserData?> getUserData(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(
      'UserData',
      where: 'userId = ?',
      whereArgs: [userId]
    );
    if (data.isNotEmpty) {
      return UserData.fromMap(data.first);
    }
    return null;
  }
  Future<void> updateUserData(UserData userData) async {
    final db = await database;
    await db.update(
      'UserData',
      userData.toMap(),
      where: 'userId = ?',
      whereArgs: [userData.userId],
    );
  }
  Future<void> deleteUserData(int userId) async {
    final db = await database;
    await db.delete(
      'UserData',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
  Future<void> updateSettings(int userId, String settingsJson) async {
    final userData = await getUserData(userId);
    if (userData != null) {
      userData.settings = settingsJson;
      await updateUserData(userData);
    }
  }

  // Обновление избранных экспонатов
  Future<void> updateFavoriteExhibits(int userId, String favoriteExhibitsJson) async {
    final userData = await getUserData(userId);
    if (userData != null) {
      userData.favoriteExhibits = favoriteExhibitsJson;
      await updateUserData(userData);
    }
  }
}