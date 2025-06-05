import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/configs.dart';
import '/libraries/services.dart';
import '/libraries/utils.dart';
import '/app/routes/route_names.dart';
import '/libraries/api.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final  _keyFormState = GlobalKey<FormState>();
  // Контроллеры для текстовых полей
  final _loginOrEmailController = TextEditingController();
  final  _passwordController = TextEditingController();
  // Флаг видимости пароля
  bool _isPasswordVisible = false;
  // Освобождение ресурсов
  @override
  void dispose() {
    _loginOrEmailController.dispose();
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
              _buildLoginForm(),
              const SizedBox(height: 10),
              _buildLoginButtons()            
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
      'Вас приветствует\n Электронный гид музея колледжа!',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge
    );
  }
  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextField(
          textInputType: TextInputType.emailAddress,
          validator: (value) => ValidatorUtil.validateValue(value),
          controller: _loginOrEmailController,
          prefixIcon: const Icon(Icons.email_outlined),
          hintText: 'Почта или логин'
        ),
        const SizedBox(height: 20),
        CustomTextField(
          validator: (value) => ValidatorUtil.validateValue(value),
          obscureText: !_isPasswordVisible,
          prefixIcon: const Icon(Icons.lock_outline),
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
        )
      ]
    );
  }
  Widget _buildLoginButtons() {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: GestureDetector(
            onTap: () {
              NavigationService().navigateToRouteScreen(RouteNames.forgotPasswordScreenRoute);
            },
            child: Text('Забыли пароль?', style: Theme.of(context).textTheme.bodyMedium)
          )
        ),
        const SizedBox(height: 24),
        Obx(() {
          return CustomButton(
            onPressed: _loadingStateController.isLoadingState ? null : () async {
              if (_keyFormState.currentState!.validate()) {
                _loadingStateController.changeLoadingState();
                final apiResponse = await ApiAuth().loginUser(_loginOrEmailController.text, _passwordController.text);
                if (apiResponse.success) {
                  DialogService().showSnackBarMessage('Информация', 'Авторизация прошла успешно');
                  NavigationService().navigateDeleteRouteScreen(RouteNames.mainScreenRoute);
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
            ) : Text('Вход', style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white
            ))
          );
        }),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            text: 'Нет аккаунта? ',
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Регистрация',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  shadows: [],
                  color: const Color.fromARGB(255, 64, 101, 252)
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  NavigationService().navigateToRouteScreen(RouteNames.registerScreenRoute);
                }
              )
            ]
          )
        )
      ]
    );
  }
}
