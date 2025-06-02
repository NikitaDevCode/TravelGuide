import '/libraries/enums.dart';
import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/libraries/custom_packages.dart';

class NotificationController extends GetxController {
  final SignalRService _signalRService = SignalRService('http://109.191.50.234:3000/notification_hub');
  final _notifications = <Notification>[].obs;
  List<Notification> get notifications => _notifications;
  @override
  void onInit() {
    super.onInit();
    _signalRService.connect();
    _subscribeNotification();
  }
  void _subscribeNotification() {
    _signalRService.connection?.on('ReceiveNotification', (args) {
      final data = Notification.fromMap(args![0] as Map<String, dynamic>);
      final notification = Notification(
        id: data.id,
        title: data.title, 
        dateTimeNotification: data.dateTimeNotification, 
        notificationTypeId: data.notificationTypeId
      );
      _notifications.add(notification);
      NotificationService().showNotification(
        notificationType: NotificationType.values[notification.notificationTypeId - 1], 
        title: notification.title
      );
    });
  }
  @override
  void onClose() {
    _signalRService.disconnect();
    super.onClose();
  }
}