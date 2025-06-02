import '/libraries/classes.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();

}
class _NotificationScreenState extends State<NotificationScreen> {
  final _notificationController = Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Уведомления'),
        actions: [
          GestureDetector(
            onTap: () => _notificationController.notifications.clear(),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.delete, color: Colors.red),
            )
          )
        ]
      ),
      body: Obx(() {
        if (_notificationController.notifications.isEmpty) {
          return Center(
            child: Text('Нет уведомлений', style: Theme.of(context).textTheme.titleLarge)
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _notificationController.notifications.length,
          itemBuilder: (_, i) => _buildNotificationContainer(_notificationController.notifications[i])
        );
      })
    );
  }
  Widget _buildNotificationContainer(Notification notification) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 50, height: 50),
            const SizedBox(height: 10),
            Text(
              DateFormat('dd.MM.yyyy').format(notification.dateTimeNotification),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              notification.title,
              style: Theme.of(context).textTheme.bodyMedium
            )
          ]
        )
      ),
    );
  }
}