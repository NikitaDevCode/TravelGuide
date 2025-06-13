import '/libraries/custom_packages.dart';
import '/libraries/widgets.dart';
import '/libraries/system_packages.dart';

class DialogAppInfo extends StatelessWidget {
  const DialogAppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Путеводитель по музею колледжа'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Версия: 0.9.0-beta.1'),
            SizedBox(height: 10),
            Text('Это приложение поможет вам исследовать музей колледжа, '
            'предоставляя информацию о экспозициях, экспонатах и событиях.'),
            SizedBox(height: 10),
            Text('Разработчик: \nАнтюхов Никита Сергеевич'),
            SizedBox(height: 10),
            Text('Контакты: \nnikita.antyukhovn.dev@gmail.com')
          ]
        )
      ),
      actions: [
        CustomButton(
          onPressed: () {
            Get.back();
          },
          widget: Text('Назад', style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white
          ))
        )
      ]
    );
  }
}