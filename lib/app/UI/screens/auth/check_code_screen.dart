import '/libraries/configs.dart';
import '/app/routes/route_names.dart';
import '/libraries/controllers.dart';
import '/libraries/api.dart';
import '/libraries/services.dart';
import '/libraries/custom_packages.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class CheckCodeScreen extends StatefulWidget {
  const CheckCodeScreen({super.key});

  @override
  State<CheckCodeScreen> createState() => _CheckCodeScreenState();
}

class _CheckCodeScreenState extends State<CheckCodeScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  String _inputCode = '';
  final _data = Get.arguments as Map<String, dynamic>;
  final _keyFormState = GlobalKey<FormState>();
  final _codeController = List.generate(4, (i) => TextEditingController(),
  );

  final _focusNodes = List.generate(4, (index) => FocusNode());
  void _verifyCode() {
    _inputCode = _codeController.map((t) => t.text).join();
  }
  bool _isCodeValid() {
    return _codeController.every((c) => c.text.isNotEmpty);
  }
  @override
  void dispose() {
    for (var controller in _codeController) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    NotificationService().generalNotification(title: 'Ваш код: ${_data['Code']}');
    Get.put<TimerController>(TimerController()).startTimer();
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
                'Введите 4-значный код, отправленный на ваше устройство. \nКод будет дейстовать в течение 15 минут',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildCheckCodeForm(),
              const SizedBox(height: 10),
              _buildCheckCodeButtons()            
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
      'Ввод кода из SMS',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge
    );
  }
  Widget _buildCheckCodeForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        return SizedBox(
          width: 60,
          height: 60,
          child: CustomTextField(
            onChanged: (value) {
              if (value.length == 1) {
                if (i < 3) {
                  FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
                } 
                else {
                  _focusNodes[i].unfocus();
                  _verifyCode();
                }
              } 
              else if (value.isEmpty) {
                if (i > 0) {
                  FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
                }
              }
            },
            controller: _codeController[i],
            focusNode: _focusNodes[i],
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            maxLenght: 1,
          )
        );
      })
    );
  }
  Widget _buildCheckCodeButtons() {
    final timerController = Get.find<TimerController>();
    return Column(
      children: [
        const SizedBox(height: 24),
        Obx(() {
          return CustomButton(
            onPressed: _loadingStateController.isLoadingState ? null : () async {
              if (_isCodeValid()) {
                _loadingStateController.changeLoadingState();
                final apiResponse = await ApiIdentification().checkCode(_inputCode, _data['Email']);
                if (apiResponse.success) {
                  NavigationService().navigateDeleteRouteScreen(
                    RouteNames.resetPasswordScreenRoute, 
                    arguments: {
                      'Email': _data['Email'],
                      'Code': _inputCode
                    }
                    
                  );
                  DialogService().showSnackBarMessage('Информация', 'Код успешно проверен');
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
            ) : Text('Отправить', style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white
            ))
          );
        }),
        const SizedBox(height: 20),
        Obx(() {
          return Text.rich(
            timerController.isRepeatSendCode ? TextSpan(
              text: 'Выслать новый код',
              style: Theme.of(context).textTheme.bodyMedium,
              recognizer: TapGestureRecognizer()..onTap = () async {
                timerController.startTimer();
                final apiResponse = await ApiIdentification().forgotPassword(_data['Email']);
                if (apiResponse.success) {
                  final code = apiResponse.data as String;
                  NotificationService().generalNotification(title: 'Ваш код: $code');
                }
              }
            ) : TextSpan(
              text: 'Выслать новый код через ${timerController.repeatSendCodeSeconds} секунд',
              style: Theme.of(context).textTheme.bodyMedium
            )
          );
        })
      ]
    );
  }
}
