
import '/libraries/custom_packages.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class DialogWarningTotp extends StatelessWidget {
  const DialogWarningTotp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Предупреждение'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text('Вы уже создавали TOTP', style: Theme.of(context).textTheme.titleMedium),
            Text('Желаете пересоздать?', style: Theme.of(context).textTheme.titleMedium)
          ]
        )
      ),
      actions: [
        CustomButton(
          onPressed: () async {
          },
          widget: const Text('Подтвердить', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ))
        ),
        const SizedBox(height: 10),
        CustomButton(
          onPressed: () {
            Get.back();
          },
          widget: const Text('Назад', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ))
        )
      ]
    );
  }
}