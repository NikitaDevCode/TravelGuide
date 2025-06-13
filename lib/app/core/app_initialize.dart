import '/libraries/services.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
// Класс инициализирующий различные компоненты приложения
class AppInitialize {
  //Инициализация всех контроллеров для работы приложения
  static void _initializeControllers() {
    // Инициализация контроллера который управляет состоянием авторизации
    Get.put<AuthStateController>(AuthStateController());
    /*
    Инициализация контроллера который управляет состоянием долгих операций
    * Меняет виджет кнопки на прогресс-бар во время длительных операций
    */
    Get.put<LoadingStateController>(LoadingStateController());
    // Инициализация контроллера для управления обновлениями приложения
    Get.put<UpdateController>(UpdateController());
    // Инициализация контроллера для загрузки первоначальных данных для приложения
    Get.put<SetupController>(SetupController());
    /*
    Инициализация контроллера для загрузки пользовательских данных
    * Изображение профиля, Имя, Возраст, Дата рождения, Группа
    */
    Get.put<UserDataController>(UserDataController());
    // Инициализация контроллера для управления темами приложения
    Get.put<ThemeStateController>(ThemeStateController());
    // Инициализация контроллера для настройки уведомлений
    Get.put<NotificationStateController>(NotificationStateController());
    // Инициализация контроллера для настройки безопасности приложения
    Get.put<SecurityStateController>(SecurityStateController());
    // Инициализация контроллера для управления избранными экспонатами
    Get.put<FavoriteController>(FavoriteController());
    // Инициализация контроллера для управления настройками приложения
    Get.put<SettingsController>(SettingsController());
    // Инициализация контроллера для управления уведомлениями
    Get.put<NotificationController>(NotificationController());
    
  }
  // Инициаилизация SharedPreferences
  static Future<void> _intializeSharedPref() async {
    await SharedPrefService.initialize();
  }
  // Инициаилизация уведомлений
  static Future<void> _intializeNotifications() async {
    await NotificationService().initialize();
  }
  // Инициаилизация сервиса для автоматического выхода из аккаунта
  static Future<void> _intializeAutoLogout() async {
    await AutoLogoutService().initialize();
  }
  // Инициализация всех компонентов вместе
  static Future<void> initializeAll() async {
    _initializeControllers();
    await _intializeNotifications();
    await _intializeSharedPref();
    await _intializeAutoLogout();
  }
}