import '/libraries/api.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/services.dart';
import '/libraries/utils.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class ChangeLoginScreen extends StatefulWidget {
  const ChangeLoginScreen({super.key});

  @override
  State<ChangeLoginScreen> createState() => _ChangeLoginScreenState();
}

class _ChangeLoginScreenState extends State<ChangeLoginScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _passwordController.dispose();
    _loginController.dispose();
    super.dispose();
  }
  
  final _keyFormState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена логина'),
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
                  child: const Icon(Icons.person, size: 60)
                ),
                const SizedBox(height: 15),
                Text(
                  'Обновите ваш логин',
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
                  hintText: 'Новый логин',
                  controller: _loginController,
                  validator: (value) => ValidatorUtil.validateLogin(value),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                
                const SizedBox(height: 15),
                
                CustomTextField(
                  hintText: 'Пароль от учётной записи',
                  controller: _passwordController,
                  validator: (value) => ValidatorUtil.validateValue(value),
                  prefixIcon: const Icon(Icons.lock_outline),
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
                        final apiResponse = await ApiAccount().changeLogin(_loginController.text, _passwordController.text);
                        if (apiResponse.success) {
                          DialogService().showSnackBarMessage('Информация', 'Логин успешно изменён');
                          
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