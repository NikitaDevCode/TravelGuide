import '/libraries/controllers.dart';
import '/libraries/enums.dart';
import '/libraries/custom_packages.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._internal();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _createChannels();
  }
  Future<void> _createChannels() async {
    final androidImplementation = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationType.all.name,
        NotificationType.all.label,
        description: 'Включает все типы уведомлений',
        importance: Importance.max,
      ),
    );
    await androidImplementation?.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationType.museum.name,
        NotificationType.museum.label,
        description: 'Уведомления о мероприятиях',
        importance: Importance.max,
      )
    );

    await androidImplementation?.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationType.service.name,
        NotificationType.service.label,
        description: 'Технические сообщения',
        importance: Importance.max,
      ),
    );
  }

  Future<void> showNotification({required NotificationType notificationType, required String title}) async {
    final notificationState = Get.find<NotificationStateController>();

    // Проверка: уведомления отключены или тип не соответствует настройкам
    if (!notificationState.isEnable) return;
    if (notificationState.notificationType != NotificationType.all && notificationType != notificationState.notificationType) {
      return;
    }

    String channelId = notificationType.name;
    String channelName = notificationType.label;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Уведомления приложения',
      importance: Importance.max,
      priority: Priority.high
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Путеводитель',
      title,
      NotificationDetails(android: androidPlatformChannelSpecifics)
    );
  }
  Future<void> generalNotification({required String title}) async {
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Путеводитель',
      title,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'travel_guide_channel', 
          'Музейные уведомления',
          importance: Importance.max,
          playSound: true
        )
      )
    );
  }
}