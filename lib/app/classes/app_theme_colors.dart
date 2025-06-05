import '/libraries/system_packages.dart';
class AppThemeColors {
  Color textColor;
  Color scaffoldColor;
  Color backgroundColor;
  Color accentColor;
  Color iconColor;
  Color shadowColor;
  Color progressColor;
  bool isDark;
  Brightness get brightness => isDark ? Brightness.dark : Brightness.light;

  AppThemeColors({
    required this.textColor,
    required this.scaffoldColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.iconColor,
    required this.shadowColor,
    required this.progressColor,
    required this.isDark,
  });
}