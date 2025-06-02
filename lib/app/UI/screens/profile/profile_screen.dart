import '/libraries/services.dart';
import '/libraries/configs.dart';
import '/libraries/controllers.dart';
import '/libraries/api.dart';
import '/app/routes/route_names.dart';
import '/libraries/widgets.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userDataController = Get.find<UserDataController>();
  final _loadingStateController = Get.find<LoadingStateController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Мой Профиль')
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildContainer(
              children: [
                _buildProfileOption(
                  title: 'Редактирование профиля',
                  leading: SvgPicture.asset('assets/icons/SVG/edit.svg', width: 25, height: 25),
                  onTap: () {
                    NavigationService().navigateToRouteScreen(RouteNames.editProfileScreenRoute, arguments: _userDataController.userData);
                  }
                ),
                const SizedBox(height: 10),
                _buildProfileOption(
                  title: 'Уведомления',
                  leading: SvgPicture.asset('assets/icons/SVG/notification.svg', width: 25, height: 25),
                  onTap: () {
                    NavigationService().navigateToRouteScreen(RouteNames.notificationScreenRoute);
                  }
                ),
                const SizedBox(height: 10),
                _buildProfileOption(
                  title: 'Настройки',
                  leading: SvgPicture.asset('assets/icons/SVG/settings.svg', width: 25, height: 25),
                  onTap: () {
                    NavigationService().navigateToRouteScreen(RouteNames.settingsScreenRoute);
                  }
                  
                )
              ]
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Obx(() {
                return CustomButton(
                  color: Colors.red,
                  onPressed: _loadingStateController.isLoadingState ? null : () async {
                    _loadingStateController.changeLoadingState();
                    final apiResponse = await ApiSecurity().logoutUser();
                    if (apiResponse.success) {
                      NavigationService().navigateDeleteRouteScreen(RouteNames.loginScreenRoute);
                    }
                    _loadingStateController.changeLoadingState();
                  }, 
                  widget: _loadingStateController.isLoadingState ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.white
                    )
                  ) : Text('Выйти из аккунта', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white
                  ))
                );
              })
            )
          ]
        )
      )
    );
  }
  Widget _buildProfileHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4.75,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 64, 101, 252),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30), 
          bottomRight: Radius.circular(30),
        )
      ),
      child: Obx(() {
        final userData = _userDataController.userData;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: userData.profileImagePath.isNotEmpty ? FileImage(
                File(
                  userData.profileImagePath
                )
              ) : null,
              backgroundColor: isDark ? const Color.fromARGB(255, 60, 60, 60) : const Color.fromARGB(255, 235, 235, 235),
              radius: 45,
              child: userData.profileImagePath.isEmpty ? Icon(
                Icons.person, 
                color: Theme.of(context).iconTheme.color,
                size: 45,
              ) : null
            ),
            const SizedBox(height: 14),
            Text(
              'Привет ${userData.name}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white
              )
            )
          ]
        );
      })
    );
  }
  Widget _buildContainer({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [
            WidgetConfig.containerBoxShadow
          ]
        ),
        child: Column(
          children: children,
        )
      ),
    );
  }
  Widget _buildProfileOption({required String title, Widget? subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap}) {
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
        onTap: onTap
      )
    );
  }
}