import '/libraries/screens.dart';
import '/libraries/services.dart';
import '/libraries/configs.dart';
import '/libraries/models.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _user = Get.arguments as User;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки аккаунта'
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5.45,
              child: _buildContainer(
                children: [
                  const Text('Почта:'),
                  Text(_user.email, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  
                  const Text('Логин:'),
                  Text(_user.login, style: Theme.of(context).textTheme.bodyMedium),
                ]
              )
            ),
            const SizedBox(height: 20),
            _buildContainer(
              children: [
                _buildSettingsOption(
                  onTap: () {
                    NavigationService().navigateToScreen(() => const ChangeEmailScreen());
                  },
                  title: 'Смена почты',
                  leading: const Icon(Icons.email)
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Смена логина',
                  leading: const Icon(Icons.person),
                  onTap: () {
                    NavigationService().navigateToScreen(() => const ChangeLoginScreen());
                  }
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Смена пароля',
                  onTap: () {
                    NavigationService().navigateToScreen(() => const ChangePasswordScreen());
                  },
                  leading: const Icon(Icons.lock)
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
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [
          WidgetConfig.containerBoxShadow
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
      )
    );
  }
  Widget _buildSettingsOption({required String title, Widget? subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          WidgetConfig.containerBoxShadow
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        title: Text(title),
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      )
    );
  }
}