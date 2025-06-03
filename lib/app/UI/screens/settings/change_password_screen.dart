import '../../../../libraries/api.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/services.dart';
import '/libraries/utils.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();

}
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _passwordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  final _keyFormState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена пароля'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService().backScreen()
        )
      ),
      body: Form(
        key: _keyFormState,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Icon(Icons.lock, size: 60)
                ),
                const SizedBox(height: 15),
                Text(
                  'Обновите ваш пароль',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Для подтверждения изменений потребуется ввести пароль от учётной записи',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'Старый пароль',
                  controller: _oldPasswordController,
                  validator: (value) => ValidatorUtil.validateValue(value),
                  prefixIcon: const Icon(Icons.lock),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Новый пароль',
                  controller: _passwordController,
                  validator: (value) => ValidatorUtil.validateValue(value),
                  prefixIcon: const Icon(Icons.lock),
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Повторите новый пароль',
                  controller: _passwordController,
                  validator: (value) => ValidatorUtil.validateConfirmPassword(value, _passwordController.text),
                  prefixIcon: const Icon(Icons.lock),
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                const Divider(height: 1),
                const SizedBox(height: 20),
                
                Obx(() {
                  return CustomButton(
                    onPressed: _loadingStateController.isLoadingState ? null : () async {
                      if (_keyFormState.currentState!.validate()) {
                        _loadingStateController.changeLoadingState();
                        final apiResponse = await ApiAccount().changePassword(_passwordController.text, _passwordController.text);
                        if (apiResponse.success) {
                          DialogService().showSnackBarMessage('Информация', 'Пароль успешно изменён');
                          
                        }
                        _loadingStateController.changeLoadingState();
                      }
                    },
                    widget: _loadingStateController.isLoadingState ? const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.white
                      )
                    ) : Text(
                      'Сохранить изменения',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white
                      )
                    )
                  );
                })
              ]
            )
          )
        )
      )
    );
  }
}