import '/libraries/controllers.dart';
import '/libraries/services.dart';
import '/libraries/screens.dart';
import '/libraries/custom_packages.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _securityStateController = Get.find<SecurityStateController>();
  final _userDataController = Get.find<UserDataController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Настройка безопасности')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContainer(
              children: [
                Text('Функции безопасности', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'История сеансов',
                  onTap: () {
                    Get.to(() => const LoginHistoryScreen());
                  }
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Синхронизация данных',
                  trailing: Obx(() {
                    return Switch(
                      value: _securityStateController.isEnableSyncUserData,
                      onChanged: (value) {
                        _securityStateController.setSyncEnabled(value);
                      }
                    );
                  })
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Синхронизировать данные',
                  onTap: () async {
                    await _userDataController.syncUserdata();
                  }
                )
              ]
            ),
            const SizedBox(height: 10),
            CustomButton(
              color: Colors.red,
              onPressed: () {
                NavigationService().navigateToScreen(() => const DeleteAccountScreen());
              }, 
              widget: Text('Удаление учётной записи', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white
              ))
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
  Widget _buildSettingsOption({required String title, Widget? subtitle, Widget? trailing, VoidCallback? onTap}) {
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
        trailing: trailing,
        onTap: onTap,
      )
    );
  }
}