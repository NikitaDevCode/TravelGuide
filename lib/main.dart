import 'libraries/controllers.dart';
import 'libraries/screens.dart';
import 'app/core/app_initialize.dart';
import 'app/routes/app_routes.dart';
import 'app/UI/themes/app_theme.dart';
import 'app/routes/route_names.dart';
import 'libraries/custom_packages.dart';
import 'libraries/system_packages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitialize.intializeNotifications();
  await AppInitialize.intializeSharedPref();
  await AppInitialize.intializeServices();
  AppInitialize.initializeControllers();
  /*
  # -------------------------
  # ИНИЦИАИЛИЗАЦИЯ ПРИЛОЖЕНИЯ
  # -------------------------
  */
  runApp(const TravelGuide());
}

// Главный класс приложения
class TravelGuide extends StatelessWidget {
  const TravelGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // Светлая тема
      theme: AppTheme.lightTheme,
      // Тёмная тема
      darkTheme: AppTheme.darkTheme,
      // Главный маршрут
      initialRoute: RouteNames.mainScreenRoute,
      // Список экранов
      getPages: AppRoutes.routes
    );
  }
}



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _buildNavigationBar(CustomPageController customPageController) {
    return NavigationBar(
      selectedIndex: customPageController.currentPageIndex,
      onDestinationSelected: (i) => customPageController.changePage(i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Главная'),
        NavigationDestination(icon: Icon(Icons.storage), label: 'Экспозиции музея'),
        NavigationDestination(icon: Icon(Icons.account_circle), label: 'Профиль')
      ]
    );
  }
  @override
  void initState() {
    super.initState();
    Get.find<SetupController>().getUser();
  }
  @override
  Widget build(BuildContext context) {
    final customPageController = Get.put<CustomPageController>(CustomPageController());
    return Obx(() {
      return Scaffold(
        bottomNavigationBar: _buildNavigationBar(customPageController),
        body: [
          const HomeScreen(),
          const CatalogExpositionsScreen(),
          const ProfileScreen()
        ][customPageController.currentPageIndex]
      );
    });
  }
}