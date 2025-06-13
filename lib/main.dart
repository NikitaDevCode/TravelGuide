import 'app/core/app_initialize.dart';
import 'app/routes/app_routes.dart';
import 'app/UI/themes/app_theme.dart';
import 'app/routes/route_names.dart';
import 'libraries/controllers.dart';
import 'libraries/screens.dart';
import 'libraries/custom_packages.dart';
import 'libraries/system_packages.dart';

Future<void> main() async {
  // Первичная инициализация (!ВАЖНО!)
  WidgetsFlutterBinding.ensureInitialized();
  // Инициализация всех зависимостей
  await AppInitialize.initializeAll();
  /*
  # ИНИЦИАИЛИЗАЦИЯ ПРИЛОЖЕНИЯ
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

//Класс главного экрана
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late CustomPageController _customPageController;
  // Создание нижней панели навигации
  Widget _buildNavigationBar(CustomPageController customPageController) {
    return NavigationBar(
      // currentPageIndex - Текущий индекс страницы
      selectedIndex: customPageController.currentPageIndex,
      // Переключение между страницами
      onDestinationSelected: (i) => customPageController.changePage(i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home), 
          label: 'Главная'
        ),
        NavigationDestination(
          icon: Icon(Icons.storage), 
          label: 'Экспозиции музея'
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle), 
          label: 'Профиль'
        )
      ]
    );
  }
  /*
  1. Инициализация контроллера для переключения между страницами
  2. Получение данных авторизированного пользователя
  */
  @override
  void initState() {
    super.initState();
    _customPageController = Get.put<CustomPageController>(CustomPageController());
    Get.find<SetupController>().getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        bottomNavigationBar: _buildNavigationBar(_customPageController),
        body: IndexedStack(
          // currentPageIndex - Текущий индекс страницы
          index: _customPageController.currentPageIndex,
          /*
          Список экранов после пройденной авторизации
          1. Главный экран
          2. Каталог экспозиций
          3. Экран профиля
          */
          children: const [
            HomeScreen(),
            CatalogExpositionsScreen(),
            ProfileScreen()
          ]
        )
      );
    });
  }
}