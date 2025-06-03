import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';

class DialogService {
  DialogService._internal();
  static final DialogService _instance = DialogService._internal();
  factory DialogService() {
    return _instance;
  }
  Future<void> showDialog(Widget widget) async { 
    await Get.dialog(
      widget,
      barrierDismissible: false,
    );
  }
  void showSnackBarMessage(String title, String message, ) {
    final theme = Get.theme;
    final isDark = theme.brightness == Brightness.dark;
    Get.snackbar(
      duration: const Duration(seconds: 2),
      isDismissible: false,
      title, 
      message,
      backgroundColor: isDark ? const Color.fromARGB(255, 60, 60, 60) : const Color.fromARGB(255, 235, 235, 235),
      colorText: theme.textTheme.bodyMedium!.color
    );
  }
}