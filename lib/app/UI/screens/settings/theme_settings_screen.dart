import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  final _themeStateController = Get.find<ThemeStateController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Настройка тем')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildContainer(
              children: [
                Text('Выбор темы', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Системная',
                  trailing: Obx(() {
                    return Switch(
                      value: _themeStateController.themeMode == ThemeMode.system,
                      onChanged: (value) {
                        _themeStateController.changeThemeMode(ThemeMode.system);
                      }
                    );
                  })
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Светлая',
                  trailing: Obx(() {
                    return Switch(
                      value: _themeStateController.themeMode == ThemeMode.light,
                      onChanged: (value) {
                        _themeStateController.changeThemeMode(ThemeMode.light);
                      }
                    );
                  })
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: 'Тёмная',
                  trailing: Obx(() {
                    return Switch(
                      value: _themeStateController.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        _themeStateController.changeThemeMode(ThemeMode.dark);
                      }
                    );
                  })
                )
              ]
            )
          ]
        ),
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
  Widget _buildSettingsOption({required String title, Widget? subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap}) {
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
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      )
    );
  }
}