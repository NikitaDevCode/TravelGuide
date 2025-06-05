import '/libraries/enums.dart';
import '/libraries/services.dart';
import '/app/routes/route_names.dart';
import '/libraries/database.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/models.dart';
import '/libraries/utils.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class AnketaScreen extends StatefulWidget {
  const AnketaScreen({super.key});

  @override
  State<AnketaScreen> createState() => _AnketaScreenState();
}

class _AnketaScreenState extends State<AnketaScreen> {
  final _avatarController = Get.put<AvatarController>(AvatarController());
  final _loadingStateController = Get.find<LoadingStateController>();
  final _userId = Get.arguments as int;
  final  _keyFormState = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _userGroupController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _birthDateController.dispose();
    _userGroupController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание анкеты'),
        centerTitle: true
      ),
      body: Form(
        key: _keyFormState,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                child: Obx(() {
                  return GestureDetector(
                    onTap: () {
                      _avatarController.pickAvatarImage();
                    },
                    child: CircleAvatar(
                      backgroundImage: _avatarController.avatarImage.path.isNotEmpty ? FileImage(_avatarController.avatarImage) : null,
                      backgroundColor: isDark ? const Color.fromARGB(255, 60, 60, 60) : const Color.fromARGB(255, 235, 235, 235),
                      radius: 60,
                      child: _avatarController.avatarImage.path.isEmpty ? Icon(
                        Icons.person,
                        size: 50, 
                        color: Theme.of(context).iconTheme.color
                      ) : null
                    )
                  );
                })
              ),
              const SizedBox(height: 20),
              _buildHeaderText(),
              const SizedBox(height: 20),
              _buildAnketaForm(),
              const SizedBox(height: 10),
              _buildAnketaButtons()            
            ]
          )
        )
      )
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Создание анкеты',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge
    );
  }

  Widget _buildAnketaForm() {
    return Column(
      children: [
        CustomTextField(
          validator: (value) => ValidatorUtil.validateValue(value),
          controller: _nameController,
          hintText: 'Имя'
        ),
        const SizedBox(height: 20),
        CustomTextField(
          textInputType: TextInputType.number,
          validator: (value) => ValidatorUtil.validateValue(value),
          controller: _ageController,
          hintText: 'Возраст'
        ),
        const SizedBox(height: 20),
        CustomTextField(
          maxLenght: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Поле не заполнено';
            }

            // Проверка формата DD.MM.YYYY (обязательно 2 цифры для дня и месяца)
            final regex = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');
            if (!regex.hasMatch(value)) {
              return 'Неверный формат. Используйте ДД.ММ.ГГГГ';
            }

            final parts = value.split('.');
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);

            if (day == null || month == null || year == null) {
              return 'Неверные числовые значения';
            }

            // Добавляем ведущие нули для корректного формата YYYY-MM-DD
            final formattedMonth = month.toString().padLeft(2, '0');
            final formattedDay = day.toString().padLeft(2, '0');
            final isoDateString = '$year-$formattedMonth-$formattedDay';

            final parsedDate = DateTime.tryParse(isoDateString);
            if (parsedDate == null) {
              return 'Неверная дата';
            }

            // Проверяем, что дата совпадает с введёнными частями
            if (parsedDate.day != day || parsedDate.month != month || parsedDate.year != year) {
              return 'Неверная дата';
            }

            // Проверка на будущее
            final now = DateTime.now();
            if (parsedDate.isAfter(now)) {
              return 'Дата рождения не может быть в будущем';
            }

            return null;
          },
          controller: _birthDateController,
          hintText: 'Дата рождения',
          textInputType: TextInputType.datetime,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _userGroupController,
          validator: (value) => ValidatorUtil.validateValue(value),
          hintText: 'Группа'
        )
      ]
    );
  }
  Widget _buildAnketaButtons() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Obx(() {
          return CustomButton(
            onPressed: _loadingStateController.isLoadingState ? null : () async {
              if (_keyFormState.currentState!.validate()) {
                _loadingStateController.changeLoadingState();
                final userData = UserData(
                  userId: _userId, 
                  name: _nameController.text, 
                  age: int.parse(_ageController.text), 
                  birthDate: _birthDateController.text, 
                  userGroup: _userGroupController.text, 
                  profileImagePath: _avatarController.avatarImage.path,
                  favoriteExhibits: '',
                  settings: jsonEncode({
                    'themeMode': ThemeMode.system.index,
                    'isEnableNotif': true,
                    'notificationType': NotificationType.all.index
                  })
                );
                await UserDataDatabase().saveUserData(userData);
                NavigationService().navigateDeleteRouteScreen(RouteNames.mainScreenRoute);
                _loadingStateController.changeLoadingState();
              }
            }, 
            widget: Text('Завершить', style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ))
          );
        }),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () async {
            await UserDataDatabase().createDefaultUserData(_userId);
            NavigationService().navigateDeleteRouteScreen(RouteNames.mainScreenRoute);
          }, 
          widget: Text('Пропуск анкеты', style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ))
        )
      ]
    );
  }
}