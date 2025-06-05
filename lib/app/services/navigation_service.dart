import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class NavigationService {
  void navigateToScreen(Widget Function() widgetBuilder, {dynamic arguments}) {
    Get.to(widgetBuilder, arguments: arguments);
  }
  void navigateToRouteScreen(String route, {dynamic arguments}) {
    Get.toNamed(route, arguments: arguments);
  }
  void navigateOffScreen(Widget Function() widgetBuilder, {dynamic arguments}) {
    Get.off(widgetBuilder, arguments: arguments);
  }
  void navigateOffRouteScreen(String route, {dynamic arguments}) {
    Get.offNamed(route, arguments: arguments);
  }
  void navigateDeleteScreen(Widget Function() widgetBuilder, {dynamic arguments}) {
    Get.offAll(widgetBuilder, arguments: arguments);
  }
  void navigateDeleteRouteScreen(String route, {dynamic arguments}) {
    Get.offAllNamed(route, arguments: arguments);
  }
  void backScreen() {
    Get.back();
  }
}