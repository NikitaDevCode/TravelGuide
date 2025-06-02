import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/enums.dart';
import '/libraries/system_packages.dart';

class NotificationSettingsScreen extends StatefulWidget{
  const NotificationSettingsScreen({super.key});
  @override
  State<StatefulWidget> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State {
  final _notificationStateController = Get.find<NotificationStateController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Настройка уведомлений')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContainer(
              children: [
                Text('Включение или выключение уведомлений', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Вкл/Выкл.',
                  trailing: Obx(() {
                    return Switch(
                      value: _notificationStateController.isEnable, 
                      onChanged: (value) {
                        _notificationStateController.changeStatusNotification(value);
                      }
                    );
                  })
                )
              ]
            ),
            const SizedBox(height: 20),
            _buildContainer(
              children: [
                Text('Выбор типа уведомлений', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Тип уведомления',
                  trailing: PopupMenuButton<NotificationType>(
                    initialValue: _notificationStateController.notificationType,
                    onSelected: (value) {
                      _notificationStateController.changeTypeNotification(value);
                    },
                    itemBuilder: (_) {
                      return [
                        for (final type in NotificationType.values)
                        PopupMenuItem(
                          value: type,
                          child: Text(type.label),
                        )
                      ];
                    }
                  ),
                  subtitle: Obx(() => Text(_notificationStateController.notificationType.label))
                )
              ]
            )
          ]
        )
      )
    );
  }
  Widget _buildContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
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
        children: children,
      ),
    );
  }
  Widget _buildSettingsOption({required String title, Widget? subtitle, Widget? trailing}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4)
          )
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        title: Text(title),
        subtitle: subtitle,
        trailing: trailing
      )
    );
  }
}