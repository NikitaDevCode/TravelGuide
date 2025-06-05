import '/libraries/services.dart';
import '/libraries/configs.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';
import '/libraries/classes.dart';

class InfoExposition1Screen extends StatelessWidget {
  final List<TimeLineEvent> _events = [
    TimeLineEvent(
      year: '1985',
      description: 'Основание Златоустовского ремесленного училища в новом каменном двухэтажном корпусе',
      isFirst: true,
    ),
    TimeLineEvent(
      year: '1909',
      description: 'Преобразование в среднее механико-техническое училище с ремесленной школой',
    ),
    TimeLineEvent(
      year: '1919',
      description: 'Переименование в техникум. Размещение военных подразделений в здании',
    ),
    TimeLineEvent(
      year: '1921',
      description: 'Создание Практического института с трехгодичным обучением',
    ),
    TimeLineEvent(
      year: '1922',
      description: 'Преобразование в механико-металлургический техникум',
    ),
    TimeLineEvent(
      year: '1930',
      description: 'Надстройка здания до четырех этажей',
    ),
  ];
  InfoExposition1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Экспозиция 1: 1885-1930'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            NavigationService().backScreen();
          }
        )
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return TimelineTile(
            alignment: TimelineAlign.start,
            isFirst: event.isFirst,
            isLast: index == _events.length - 1,
            indicatorStyle: IndicatorStyle(
              width: 85,
              height: 50,
              indicator: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    WidgetConfig.containerBoxShadow
                  ],
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.rectangle,
                ),
                child: Center(
                  child: Text(
                    event.year,
                    style: Theme.of(context).textTheme.bodyMedium
                  )
                )
              )
            ),
            beforeLineStyle: LineStyle(
              color: Colors.grey.withAlpha(75),
              thickness: 4,
            ),
            endChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    WidgetConfig.containerBoxShadow
                  ],
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(
                  event.description,
                  style: Theme.of(context).textTheme.titleSmall
                )
              )
            )
          );
        }
      )
    );
  }
}