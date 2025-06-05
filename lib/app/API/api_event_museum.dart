import '/libraries/enums.dart';
import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/libraries/system_packages.dart';
import '/libraries/models.dart';
import '/app/core/base_api.dart';

class ApiEventMuseum extends BaseApi {
  Future<List<EventMuseum>> getEventsMuseum() async {
    try {
      final response = await httpMethod(
        ApiMethod.get,
        'api/event/get-events-museum'
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => EventMuseum.fromMap(json)).toList();
      }
    }
    on ApiException catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Ошибка загрузки событий');
    } catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Произошла неизвестная ошибка');
    }
    return [];
  }
}