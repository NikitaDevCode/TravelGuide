import '/app/routes/route_names.dart';
import '/libraries/controllers.dart';
import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authStateController = Get.find<AuthStateController>();
    if (!authStateController.isAuthorized) {
      return const RouteSettings(name: RouteNames.loginScreenRoute);
    }
    return null;
  }
}