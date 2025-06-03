import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/configs.dart';
import '/libraries/services.dart';
import '/app/routes/route_names.dart';
import '/libraries/utils.dart';
import '/libraries/api.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _keyFormState = GlobalKey<FormState>();
  // Контроллеры для текстовых полей
  final _emailController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  // Флаг видимости пароля
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  // Освобождение ресурсов
  @override
  void dispose() {
    _emailController.dispose();
    _loginController.dispose();
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
              _buildRegisterForm(),
              const SizedBox(height: 10),
              _buildRegisterButtons()            
            ]
          )
        )
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
      'Регистрация',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge
    );
  }
  Widget _buildRegisterForm() {
    return Column(
      children: [
        CustomTextField(
          textInputType: TextInputType.emailAddress,
          validator: (value) => ValidatorUtil.validateEmail(value),
          controller: _emailController,
          hintText: 'Почта'
        ),
        const SizedBox(height: 20),
        CustomTextField(
          validator: (value) => ValidatorUtil.validateLogin(value),
          controller: _loginController,
          hintText: 'Логин'
        ),
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
  Widget _buildRegisterButtons() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Obx(() {
          return CustomButton(
            onPressed: _loadingStateController.isLoadingState ? null : () async {
              if (_keyFormState.currentState!.validate()) {
                _loadingStateController.changeLoadingState();
                final apiResponse = await ApiAuth().registerUser(_emailController.text, _loginController.text, _passwordController.text);
                if (apiResponse.success) {
                  DialogService().showSnackBarMessage('Информация', 'Регистрация прошла успешно');
                  NavigationService().navigateDeleteRouteScreen(RouteNames.anketaScreenRoute, arguments: apiResponse.data);
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
            ) : Text('Регистрация', style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white
            ))
          );
        }),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            text: 'Есть аккаунт? ',
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Вход',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: const Color.fromARGB(255, 64, 101, 252),
                  shadows: [],
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  NavigationService().backScreen();
                }
              )
            ]
          )
        )
      ]
    );
  }
}
