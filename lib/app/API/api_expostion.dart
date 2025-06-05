import '/libraries/enums.dart';
import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/libraries/system_packages.dart';
import '/app/core/base_api.dart';
import '/libraries/models.dart';
import 'jwt_inceptor.dart';

class ApiExpostion extends BaseApi {
  JwtInceptor jwtHandler = JwtInceptor();
  Future<List<Exposition>> getExpositions() async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.get,
          'api/exposition/get-expositions',
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Exposition.fromMap(e)).toList();
    }
    on ApiException catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Ошибка загрузки экспонатов');
    } catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Произошла неизвестная ошибка');
    }
    return [];
  }
}