import 'package:travel_guide/libraries/models.dart';

import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class EventsMuseumScreen extends StatefulWidget {

  const EventsMuseumScreen({super.key});

  @override
  State<EventsMuseumScreen> createState() => _EventsMuseumScreenState();
}

class _EventsMuseumScreenState extends State<EventsMuseumScreen> {
  final _eventMuseumController = Get.put<EventMuseumController>(EventMuseumController());
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('События'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => _eventMuseumController.eventsMuseum.clear(),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.delete, color: Colors.red),
            )
          )
        ]
      ),
      body: Obx(() {
        if (_eventMuseumController.eventsMuseum.isEmpty) {
          return Center(
            child: Text('Нет событий', style: Theme.of(context).textTheme.titleLarge)
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _eventMuseumController.eventsMuseum.length,
          itemBuilder: (_, index) => _buildEventCard(_eventMuseumController.eventsMuseum[index])
        );
      })
    );
  }

  Widget _buildEventCard(EventMuseum eventMuseum) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Row(
          children: [
            Image.asset('assets/logo.png', width: 50, height: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    eventMuseum.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd.MM.yyyy').format( eventMuseum.dateTime),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        Dialog(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Описание события', style: Theme.of(context).textTheme.titleLarge),
                                  const SizedBox(height: 20),
                                  Text(eventMuseum.description, style: Theme.of(context).textTheme.bodyMedium)
                                ]
                              )
                            )
                          )
                        )
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Подробнее',
                        style: Theme.of(context).textTheme.bodyMedium
                      )
                    ),
                  )
                ]
              )
            )
          ]
        )
      ),
    );
  }
}