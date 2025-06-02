import '/libraries/services.dart';
import '/libraries/configs.dart';
import '/libraries/utils.dart';
import '/libraries/database.dart';
import '/libraries/controllers.dart';
import '/libraries/models.dart';
import '/libraries/custom_packages.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _avatarController = Get.put<AvatarController>(AvatarController());
  bool _isProfileChanged = false;
  final _userData = Get.arguments as UserData;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _userGroupController = TextEditingController();
  File? _tempAvatarImage;
  @override
  void initState() {
    super.initState();
    _nameController.text = _userData.name;
    _ageController.text = _userData.age.toString();
    _birthDateController.text = _userData.birthDate;
    _userGroupController.text = _userData.userGroup;
  }
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
        title: const Text("Редактирование профиля")
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                child: GestureDetector(
                  onTap: _isProfileChanged ? () async {
                    await _avatarController.pickAvatarImage();
                    if (_avatarController.avatarImage.path.isNotEmpty) {
                      setState(() {
                        _tempAvatarImage = _avatarController.avatarImage;
                      });
                    }
                  } : null,
                  child: CircleAvatar(
                    backgroundImage: _tempAvatarImage != null ? FileImage(
                      _tempAvatarImage!
                    ) : _userData.profileImagePath.isNotEmpty ? FileImage(
                      File(
                        _userData.profileImagePath
                      )
                    ) : null,
                    backgroundColor: isDark ? const Color.fromARGB(255, 60, 60, 60) : const Color.fromARGB(255, 235, 235, 235),
                    radius: 60,
                    child: _tempAvatarImage == null && _userData.profileImagePath.isEmpty ? Icon(
                      Icons.person,
                      size: 50, 
                      color: Theme.of(context).iconTheme.color
                    ) : null
                  )
                )
              ),
              const SizedBox(height: 30),
              _buildActionsButtons(),
              const SizedBox(height: 15),
              _buildProfileDataBlock(
                title: 'Имя',
                icon: const Icon(Icons.person),
                data: _userData.name,
                widget: CustomTextField(
                  validator: (value) => ValidatorUtil.validateValue(value),
                  hintText: 'Введие ваше имя',
                  controller: _nameController
                )
              ),
              const SizedBox(height: 15),
              _buildProfileDataBlock(
                title: 'Возраст', 
                icon: const Icon(Icons.accessibility),  
                data: _userData.age.toString(), 
                widget: CustomTextField(
                  validator: (value) => ValidatorUtil.validateValue(value),
                  controller: _ageController,
                  textInputType: TextInputType.number,
                  hintText: 'Введие ваш возраст',
                )
              ),
              const SizedBox(height: 15),
              _buildProfileDataBlock(
                title: 'Дата рождения', 
                icon: const Icon(Icons.cake),   
                data: _userData.birthDate, 
                widget: CustomTextField(
                  textInputType: TextInputType.datetime,
                  maxLenght: 10,
                  controller: _birthDateController,
                  hintText: 'Введие вашу дату рождения',
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
                  }
                )
              ),
              const SizedBox(height: 15),
              _buildProfileDataBlock(
                title: 'Группа', 
                icon: const Icon(Icons.group),   
                data: _userData.userGroup,
                widget: CustomTextField(
                  controller: _userGroupController,
                  validator: (value) => ValidatorUtil.validateValue(value),
                  hintText: 'Введие вашу группу',
                )
              ),
              const SizedBox(height: 15),
              Obx(() {
                return CustomButton(
                  color: Colors.red,
                  onPressed: _loadingStateController.isLoadingState ? null : () async {
                    _loadingStateController.changeLoadingState();
                    DialogService().showSnackBarMessage('Информация', 'Удаление данных завершено');
                    _loadingStateController.changeLoadingState();
                  }, 
                  widget: _loadingStateController.isLoadingState ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.white
                    )
                  ) : Text('Удаление пользовательских данных', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white
                  ))
                );
              })
            ]
          )
        )
      )
    );
  }
  Widget _buildActionsButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [
          WidgetConfig.containerBoxShadow
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                WidgetConfig.containerBoxShadow
              ],
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              title: Text(!_isProfileChanged ? 'Изменить профиль' : 'Сохранить', style: Theme.of(context).textTheme.titleSmall),
              leading: Icon(
                !_isProfileChanged ? Icons.edit : Icons.done,
              ),
              onTap: () async {
                if (_isProfileChanged) {
                  await _saveProfile();
                } 
                else {
                  setState(() => _isProfileChanged = true);
                }
              }
            )
          ),
          if (_isProfileChanged)
          const SizedBox(height: 10),
          if (_isProfileChanged)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                WidgetConfig.containerBoxShadow
              ],
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              title: Text('Отмена', style: Theme.of(context).textTheme.titleSmall),
              leading: const Icon(Icons.cancel, color: Colors.red),
              onTap: () async {
                await _resetForm();
              }
            )
          )
        ]
      )
    );
  }
  Widget _buildProfileDataBlock({required String title, Widget? icon, required Widget widget, required String data}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [
          WidgetConfig.containerBoxShadow
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon ?? const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10)
              )
            ]
          ),
          const SizedBox(height: 10),
          _isProfileChanged ? widget : Text(data, style: Theme.of(context).textTheme.titleSmall) 
        ]
      )
    );
  }
  Future<void> _resetForm() async {
    setState(() => _isProfileChanged = false);
    if (_tempAvatarImage != null && _tempAvatarImage!.path != _userData.profileImagePath) {
      try {
        await _tempAvatarImage!.delete();
      } 
      catch (e) {
        debugPrint("Ошибка удаления временного файла: $e");
      }
    }
    setState(() {
      _nameController.text = _userData.name;
      _ageController.text = _userData.age.toString();
      _birthDateController.text = _userData.birthDate;
      _userGroupController.text = _userData.userGroup;
    });
  }
  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _userData.name = _nameController.text;
        _userData.age = int.tryParse(_ageController.text) ?? 0;
        _userData.birthDate = _birthDateController.text;
        _userData.userGroup = _userGroupController.text;
      });

      if (_tempAvatarImage != null) {
        _userData.profileImagePath = _tempAvatarImage!.path;
      }
      await UserDataDatabase().updateUserData(_userData);
      Get.find<SettingsController>().saveSettings();
      
      setState(() {
        _isProfileChanged = false;
        _tempAvatarImage = null;
      });
      DialogService().showSnackBarMessage('Информация', 'Профиль обновлен');
    }
  }
}