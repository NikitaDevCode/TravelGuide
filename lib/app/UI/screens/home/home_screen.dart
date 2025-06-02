import '/libraries/services.dart';
import '/libraries/configs.dart';
import '/app/routes/route_names.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderWidget(),
            _buildQuickAccessSection(),
            _buildAboutMuseumSection(),
            _buildWorkingHoursSection()
          ]
        )
      )
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 64, 101, 252),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30), 
          bottomRight: Radius.circular(30)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Добро пожаловать', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white
                  ))
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService().navigateToRouteScreen(RouteNames.notificationScreenRoute);
                  },
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 32
                  ),
                )
              ]
            ),
            const SizedBox(height: 15),
            const GreetingWidget()
          ]
        )
      )
    );
  }
  Widget _buildQuickAccessSection() {
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
          children: [
            _buildQuickAccessItem(
              title: 'Избранные экспонаты',
              leading: SvgPicture.asset('assets/icons/SVG/favorite.svg', width: 25, height: 25),
              onTap: () {
                NavigationService().navigateToRouteScreen(RouteNames.favoriteScreenRoute);
              }
            ),
            const SizedBox(height: 10),
            _buildQuickAccessItem(
              title:  'Мероприятия музея',
              leading : SvgPicture.asset('assets/icons/SVG/events.svg', width: 25, height: 25),
              onTap: () {
                NavigationService().navigateToRouteScreen(RouteNames.eventsMuseumScreenRoute);
              }
              
            )
          ]
        )
      )
    );
  }
  Widget _buildQuickAccessItem({required String title, Widget? subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap}) {
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
  Widget _buildAboutMuseumSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [
            WidgetConfig.containerBoxShadow
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 14, left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/SVG/museum.SVG', width: 30, height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('О музее', style: Theme.of(context).textTheme.titleSmall),
                  )
                ]
              ),
              const SizedBox(height: 8),
              Text(
                'Наш музей предлагает уникальные экспозиции, которые познакомят вас с историей и культурой нашего колледжа. Мы стремимся сделать ваше посещение незабываемым.', 
                style: Theme.of(context).textTheme.bodyMedium
              )
            ]
          )
        )
      )
    );
  }
  Widget _buildWorkingHoursSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [
            WidgetConfig.containerBoxShadow
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 14, left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/SVG/clock.svg', width: 30, height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Режим работы', style: Theme.of(context).textTheme.titleSmall),
                  ),
                ]
              ),
              const SizedBox(height: 8),
              Text(
                'Музей работает с Понедельника по пятницу с 09:00 до 16:00', 
                style: Theme.of(context).textTheme.bodyMedium
              )
            ]
          )
        )
      )
    );
  }
}

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = getGreeting(hour);
    return Text(
      greeting,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Colors.white
      )
    );
  }
  String getGreeting(int hour) {
    if (hour >= 6 && hour < 12) {
      return 'Доброе утро';    // 6:00 - 11:59
    } 
    else if (hour >= 12 && hour < 16) {
      return 'Добрый день';    // 12:00 - 15:59
    } 
    else if (hour >= 16 && hour < 22) {
      return 'Добрый вечер';   // 16:00 - 21:59
    } 
    else {
      return 'Доброй ночи';    // 22:00 - 5:59
    }
  }
}