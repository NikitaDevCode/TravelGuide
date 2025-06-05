import '/libraries/controllers.dart';
import '/libraries/configs.dart';
import '/libraries/services.dart';
import '/app/routes/route_names.dart';
import '/libraries/utils.dart';
import '/libraries/custom_packages.dart';
import '/libraries/api.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _data = Get.arguments as Map<String, dynamic>;
  final _keyFormState = GlobalKey<FormState>();
  // Контроллеры для текстовых полей
  final _passwordController = TextEditingController();
  // Флаг видимости пароля
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  // Освобождение ресурсов
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Путеводитель'),
      ),
      body: Form(
        key: _keyFormState,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildIcon(),
              const SizedBox(height: 20),
              _buildHeaderText(),
              const SizedBox(height: 20),
              Text(
                'Используйте уникальный пароль, который вы не применяли ранее',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildResetPasswordForm(),
              const SizedBox(height: 10),
              _buildResetPasswordButtons()            
            ]
          )
        ),
      )
    );
  }
  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [
          WidgetConfig.containerBoxShadow
        ]
      ),
      child: Image.asset(
        'assets/logo.png',
        width: 80,
        height: 80,
      )
    );
  }
  Widget _buildHeaderText() {
    return Text(
      'Установка нового пароля',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge
    );
  }
  Widget _buildResetPasswordForm() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomTextField(
          validator: (value) => ValidatorUtil.validatePassword(value),
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
          ),
          controller: _passwordController,
          hintText: 'Пароль',
        ),
        const SizedBox(height: 20),
        CustomTextField(
          obscureText: !_isPasswordVisible2,
          suffixIcon:  GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible2 = !_isPasswordVisible2;
              });
            },
            child: !_isPasswordVisible2 ? const Icon(
              Icons.visibility_off
            ) : const Icon(
              Icons.visibility
            )
          ),
          validator: (value) => ValidatorUtil.validateConfirmPassword(value, _passwordController.text),
          hintText: 'Повтор пароля'
        )
      ]
    );
  }
  Widget _buildResetPasswordButtons() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Obx(() {
          return CustomButton(
            onPressed: _loadingStateController.isLoadingState ? null : () async {
              if (_keyFormState.currentState!.validate()) {
                _loadingStateController.changeLoadingState();
                final apiResponse = await ApiIdentification().resetPassword(_data['Email'], _data['Code'], _passwordController.text);
                if (apiResponse.success) {
                  DialogService().showSnackBarMessage('Информация', 'Пароль успешно изменён');
                  NavigationService().navigateDeleteRouteScreen(RouteNames.loginScreenRoute);
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
              ) : Text('Сменить пароль', style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white
            ))
          );
        })
      ]
    );
  }
}
