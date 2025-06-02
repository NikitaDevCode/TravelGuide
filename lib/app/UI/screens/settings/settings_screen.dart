import '/libraries/widgets.dart';
import '/libraries/services.dart';
import '/libraries/screens.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';
import '/libraries/configs.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _userDataController = Get.find<UserDataController>();
  final _setupController = Get.find<SetupController>();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                WidgetConfig.containerBoxShadow
              ],
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              leading: Obx(() {
                final userData = _userDataController.userData;
                  return CircleAvatar(
                    backgroundImage:  userData.profileImagePath.isNotEmpty ? FileImage(
                    File(
                      userData.profileImagePath
                    )
                  ) : null,
                    backgroundColor: isDark ? const Color.fromARGB(255, 60, 60, 60) : const Color.fromARGB(255, 235, 235, 235),
                    child: userData.profileImagePath.isEmpty ? Icon(
                      Icons.person, 
                      color: Theme.of(context).iconTheme.color
                    ) : null
                  );
                }
              ),
              title: const Text('Аккаунт'),
              subtitle: const Text('Настройки аккаунта'),
              trailing: const Icon(Icons.arrow_right, size: 30),
              onTap: () {
                NavigationService().navigateToScreen(() => const AccountSettingsScreen(), arguments: _setupController.user);
              }
            )
          ),
          const SizedBox(height: 30),
          _buildSettingsOption(
            title:  'Темы',
            subtitle: const Text('Настройка темы приложения'),
            leading: SvgPicture.asset('assets/icons/SVG/dark_mode.svg', width: 30, height: 30),
            onTap: () {
              NavigationService().navigateToScreen(() => const ThemeSettingsScreen());
            }
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            title: 'Уведовления',
            subtitle: const Text('Настройка уведомлений'),
            leading: SvgPicture.asset('assets/icons/SVG/notification.svg', width: 30, height: 30),
            onTap: () {
              NavigationService().navigateToScreen(() => const NotificationSettingsScreen());
            }
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            title: 'Безопасность',
            subtitle: const Text('Настройка безопасности'),
            leading: SvgPicture.asset('assets/icons/SVG/security.svg', width: 30, height: 30),
            onTap: () {
              NavigationService().navigateToScreen(() => const SecuritySettingsScreen());
            }
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            title: 'Отзыв',
            subtitle: const Text('Оставить отзыв о приложении'),
            leading: SvgPicture.asset('assets/icons/SVG/social_networks.svg', width: 30, height: 30),
            onTap: () async {
              await launchUrl(Uri.parse('https://forms.gle/9MnwvNqyxkfPxT6t9'));
            }
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            title: 'Проверка обновлений',
            subtitle: const Text('Проверить обновления приложения'),
            leading: const Icon(Icons.update, size: 30),
            onTap: () {
              NavigationService().navigateToScreen(() => const UpdateScreen());
            }
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            title: 'Информация',
            subtitle: const Text('Информация о приложении'),
            leading: SvgPicture.asset('assets/icons/SVG/info.svg', width: 30, height: 30),
            onTap: () {
              DialogService().showDialog(const DialogAppInfo());
            }
          )
        ]
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
