import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/app/routes/route_names.dart';
import '/libraries/api.dart';
import '/libraries/utils.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
  final _keyFormState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Удаление аккаунта'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(Icons.warning, color: Colors.white, size: 50)
                ),
                const SizedBox(height: 20),
                Text(
                  'Вы уверены, что хотите удалить аккаунт?', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    shadows: [],
                    color: Colors.red,
                  )
                ),
                const SizedBox(height: 15),
                Text(
                  'Это действие нельзя отменить. Все ваши данные будут безвозвратно удалены.',
                  textAlign: TextAlign.center, 
                  style: Theme.of(context).textTheme.titleSmall
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomTextField(
                    hintText: 'Пароль от учётной записи',
                    controller: _passwordController,
                    validator: (value) => ValidatorUtil.validateValue(value)
                  )
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return CustomButton(
                    color: Colors.red,
                    onPressed: _loadingStateController.isLoadingState ? null : () async {
                      if (_keyFormState.currentState!.validate()) {
                        _loadingStateController.changeLoadingState();
                        final apiResponse = await ApiAccount().deleteAccount(_passwordController.text);
                        if (apiResponse.success) {
                          Get.offAllNamed(RouteNames.loginScreenRoute);
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
                    ) : Text('Подтвердить', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white
                    ))
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