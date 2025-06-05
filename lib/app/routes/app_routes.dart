import '/main.dart';
import '/libraries/screens.dart';
import '/libraries/custom_packages.dart';
import 'route_names.dart';
import '/libraries/middlewares.dart';
class AppRoutes {
  // Список маршрутов для экранов
  static final routes = [
    GetPage(
      name: RouteNames.loginScreenRoute, 
      page: () => const LoginScreen()
    ),
    GetPage(
      name: RouteNames.registerScreenRoute, 
      page: () => const RegisterScreen()
    ),
    GetPage(
      name: RouteNames.forgotPasswordScreenRoute, 
      page: () => const ForgotPasswordScreen()
    ),
    GetPage(
      name: RouteNames.checkCodeScreenRoute, 
      page: () => const CheckCodeScreen()
    ),
    GetPage(
      name: RouteNames.resetPasswordScreenRoute, 
      page: () => const ResetPasswordScreen()
    ),
    GetPage(
      name: RouteNames.mainScreenRoute, 
      page: () => const MainScreen(),
      middlewares: [AuthMiddleware()]
    ),
    GetPage(
      name: RouteNames.settingsScreenRoute, 
      page: () => const SettingsScreen()
    ),
    GetPage(
      name: RouteNames.favoriteScreenRoute, 
      page: () => const FavoriteExhibitsScreen()
    ),
    GetPage(
      name: RouteNames.eventsMuseumScreenRoute, 
      page: () => const EventsMuseumScreen()
    ),
    GetPage(
      name: RouteNames.notificationScreenRoute, 
      page: () => const NotificationScreen()
    ),
    GetPage(
      name: RouteNames.editProfileScreenRoute,
      page: () => const EditProfileScreen()
    ),
    GetPage(
      name: RouteNames.anketaScreenRoute,
      page: () => const AnketaScreen()
    )
  ];
}