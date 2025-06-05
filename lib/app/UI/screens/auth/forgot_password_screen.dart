import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/configs.dart';
import '/libraries/services.dart';
import '/app/routes/route_names.dart';
import '/libraries/api.dart';
import '/libraries/utils.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _keyFormState = GlobalKey<FormState>();
  // Контроллеры для текстовых полей
  final _emailController = TextEditingController();
  // Освобождение ресурсов
  @override
  void dispose() {
    _emailController.dispose();
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
                'Введите свой email, чтобы получить код для сброса пароля.',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildForgotPasswordForm(),
              const SizedBox(height: 10),
              _buildForgotPasswordButtons()            
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
      'Сброс пароля',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge
    );
  }
  Widget _buildForgotPasswordForm() {
    return Column(
      children: [
        CustomTextField(
          prefixIcon: const Icon(Icons.email_outlined),
          textInputType: TextInputType.emailAddress,
          validator: (value) => ValidatorUtil.validateEmail(value),
          controller: _emailController,
          hintText: 'Почта'
        )
      ]
    );
  }
  Widget _buildForgotPasswordButtons() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Obx(() {
          return CustomButton(
            onPressed: _loadingStateController.isLoadingState ? null : () async {
              if (_keyFormState.currentState!.validate()) {
                _loadingStateController.changeLoadingState();
                final apiResponse = await ApiIdentification().forgotPassword(_emailController.text);
                if (apiResponse.success) {
                  DialogService().showSnackBarMessage('Информация', 'Введите код из SMS');
                  NavigationService().navigateToRouteScreen(
                    RouteNames.checkCodeScreenRoute, 
                    arguments: {
                      'Email': _emailController.text,
                      'Code': apiResponse.data
                    }
                  );
                }
                else {
                  DialogService().showSnackBarMessage('Информация', 'Пользователь не найден');
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
            ) : Text('Отправить код', style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white
            ))
          );
        })
      ]
    );
  }
}
