import '/libraries/custom_packages.dart';
import '/libraries/classes.dart';
import '/libraries/system_packages.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(_lightThemeColors);
  static ThemeData get darkTheme => _buildTheme(_darkThemeColors);
  static final AppThemeColors _lightThemeColors = AppThemeColors(
    shadowColor: Colors.black.withAlpha(50),
    textColor: Colors.black, 
    scaffoldColor: const Color.fromARGB(255, 246, 247, 249),
    backgroundColor: Colors.white,
    accentColor: Colors.grey.withAlpha(75),
    iconColor: Colors.black,
    progressColor: Colors.black,  
    isDark: false
  );
  static final AppThemeColors _darkThemeColors = AppThemeColors(
    shadowColor: Colors.white.withAlpha(50),
    textColor: Colors.white, 
    scaffoldColor: const Color.fromARGB(255, 45, 45, 45),
    backgroundColor: const Color.fromARGB(255, 75, 75, 75),
    accentColor: Colors.grey.withAlpha(75),
    iconColor: Colors.white,
    progressColor: Colors.white,  
    isDark: true
  );
  
  static final ThemeData _baseTheme = ThemeData(
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      )
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      )
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      )
    )
  );
  static ThemeData _buildTheme(AppThemeColors colors) {
    return _baseTheme.copyWith(
      brightness: colors.brightness,
      scaffoldBackgroundColor: colors.scaffoldColor,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundColor,
        titleTextStyle: _textStyle(colors.textColor, 20),
        iconTheme: IconThemeData(color: colors.iconColor),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.backgroundColor,
        indicatorColor: colors.accentColor,
        labelTextStyle: WidgetStatePropertyAll(_textStyle(colors.textColor, 12)),
        iconTheme: WidgetStatePropertyAll(IconThemeData(color: colors.iconColor))
      ),
      textTheme: TextTheme(
        titleLarge: _textStyle(colors.textColor, 24, bold: true),
        titleMedium: _textStyle(colors.textColor, 18, bold: true),
        titleSmall: _textStyle(colors.textColor, 16),
        bodyMedium: _textStyle(colors.textColor, 14),
        bodySmall: _textStyle(colors.textColor, 12)
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.textColor,
        selectionColor: Colors.grey.withAlpha(75)
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: _textStyle(colors.textColor, 20, bold: true),
        contentTextStyle: _textStyle(colors.textColor, 12),
        backgroundColor: colors.backgroundColor,
      ),
      dividerTheme: DividerThemeData(
        color: colors.accentColor
      ),
      iconTheme: IconThemeData(
        color: colors.iconColor
      ),
      listTileTheme: ListTileThemeData(
        selectedTileColor: colors.accentColor,
        titleTextStyle: _textStyle(colors.textColor, 16, bold: true),
        subtitleTextStyle: _textStyle(colors.textColor, 14),
        iconColor: colors.iconColor,
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(_textStyle(colors.textColor, 14)),
        iconColor: colors.iconColor,
        color: colors.backgroundColor
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: colors.accentColor),
        backgroundColor: colors.backgroundColor
      ),
      cardColor: colors.backgroundColor,
      switchTheme: _switchThemeData(colors),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.progressColor
      )
    );
  }
  static TextStyle _textStyle(Color color, double size, {bool bold = false}) {
    return GoogleFonts.lato(
      fontSize: size,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
      shadows: [_textShadow(color)],
    );
  }

  static BoxShadow _textShadow(Color color) {
    return BoxShadow(
      blurRadius: 5,
      offset: const Offset(2, 2),
      color: color.withAlpha(50),
    );
  }
  static SwitchThemeData _switchThemeData(AppThemeColors colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((state) {
        if (state.contains(WidgetState.selected)) {
          return Colors.green;
        }
        else {
          return Colors.red;
        }
      }),
      trackOutlineColor: WidgetStateProperty.all(colors.accentColor),
      trackColor: WidgetStateProperty.all(colors.backgroundColor)
    );
  }
}