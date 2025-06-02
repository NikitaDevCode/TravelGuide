import '/libraries/enums.dart';
import '/libraries/controllers.dart';
import '/libraries/services.dart';
import '/libraries/widgets.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _updateController = Get.find<UpdateController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обновление приложения'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService().backScreen()
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(24),
                child: const Icon(Icons.update, size: 60)
              ),
              const SizedBox(height: 15),
              Text(
                'Обновление приложения',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Для проверки обновлений нажмите на кнопку ниже',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
              ),
              const SizedBox(height: 30),
              _buildSettingsOption(
                title: 'Релизы',
                trailing: Obx(() {
                  return Switch(
                    value: _updateController.selectedVersion == VersionType.release, 
                    onChanged: (value) {
                      _updateController.setSelectedVersion(VersionType.release);
                    } 
                  );
                })
              ),
              const SizedBox(height: 10),
              _buildSettingsOption(
                title: 'Бета версии',
                trailing: Obx(() {
                  return Switch(
                    value: _updateController.selectedVersion == VersionType.beta, 
                    onChanged: (value) {
                      _updateController.setSelectedVersion(VersionType.beta);
                    } 
                  );
                })
              ),
              const SizedBox(height: 10),
              _buildSettingsOption(
                title: 'Альфа версии',
                trailing: Obx(() {
                  return Switch(
                    value: _updateController.selectedVersion == VersionType.alpha, 
                    onChanged: (value) {
                      _updateController.setSelectedVersion(VersionType.alpha);
                    } 
                  );
                })
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 20),
              Obx(() {
                return CustomButton(
                  onPressed: _loadingStateController.isLoadingState ? null : () async {
                    _loadingStateController.changeLoadingState();
                    await _updateController.checkForUpdates();
                    _loadingStateController.changeLoadingState();
                  },
                  widget:  _loadingStateController.isLoadingState ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.white
                    )
                  ) : Text(
                    'Проверить обновления',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white
                    )
                  )
                );
              })
            ]
          )
        )
      )
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