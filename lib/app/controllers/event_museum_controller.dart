import '../../libraries/services.dart';
import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart' as http;
import '/libraries/models.dart';
import '/libraries/custom_packages.dart';

class EventMuseumController extends GetxController {
  Logger logger = Logger();
  final _eventsMuseum = <EventMuseum>[].obs;
  final SignalRService _signalRService = SignalRService('http://109.191.50.234:3000/event_museum_hub');
  List<EventMuseum> get eventsMuseum => _eventsMuseum;
  @override
  void onInit() {
    super.onInit();
    _subscribeEventMuseum();
  }
  Future<void> _subscribeEventMuseum() async {
    try {
      _signalRService.connection?.on("ReceiveEventMuseum", (arguments) {
        final newEvent = EventMuseum.fromMap(arguments![0] as Map<String, dynamic>);
        _eventsMuseum.insert(0, newEvent);
      });
    }
    catch (e) {
      logger.d(e);
    }
  }
  @override
  void onClose() {
    _signalRService.disconnect();
    super.onClose();
  }
}