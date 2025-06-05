import '/libraries/api.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/utils.dart';
import '/libraries/widgets.dart';
import '/libraries/services.dart';
import '/libraries/system_packages.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  bool _isPasswordVisible = false;
  final _loadingStateController = Get.find<LoadingStateController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  final _keyFormState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена почты'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService().backScreen()
        ),
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
                  child: const Icon(Icons.email, size: 60)
                ),
                const SizedBox(height: 15),
                Text(
                  'Обновите адрес электронной почты',
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
                  hintText: 'Новая почта',
                  controller: _emailController,
                  validator: (value) => ValidatorUtil.validateEmail(value),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                
                const SizedBox(height: 15),
                
                CustomTextField(
                  hintText: 'Пароль от учётной записи',
                  controller: _passwordController,
                  validator: (value) => ValidatorUtil.validateValue(value),
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: !_isPasswordVisible,
                  suffixIcon:  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: !_isPasswordVisible ? const Icon(
                      Icons.visibility_off
                    ) : const Icon(
                      Icons.visibility
                    )
                  )
                ),
                const SizedBox(height: 15),
                const Divider(height: 1),
                const SizedBox(height: 20),
                
                Obx(() {
                  return CustomButton(
                    onPressed: _loadingStateController.isLoadingState ? null : () async {
                      if (_keyFormState.currentState!.validate()) {
                        _loadingStateController.changeLoadingState();
                        final apiResponse = await ApiAccount().changeEmail(_emailController.text, _passwordController.text);
                        if (apiResponse.success) {
                          DialogService().showSnackBarMessage('Информация', 'Почта успешно изменена');
                        }
                        _loadingStateController.changeLoadingState();
                      }
                    },
                    widget:  _loadingStateController.isLoadingState ? const SizedBox(
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