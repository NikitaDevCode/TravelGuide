import '/libraries/configs.dart';
import '/libraries/services.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';
import '/libraries/classes.dart';

class InfoExposition3Screen extends StatelessWidget {
  final List<TimeLineEvent> _events = [
    TimeLineEvent(
      year: '1988',
      description: 'Крупный пожар и последующее восстановление здания техникума',
      isFirst: true,
    ),
    TimeLineEvent(
      year: '1988-1989',
      description: 'Масштабная реконструкция под руководством И.И. Матузова',
    ),
  ];
  InfoExposition3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Экспозиция 3: 1988'),
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