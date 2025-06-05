import '/libraries/system_packages.dart';
import '/libraries/models.dart';
import '/libraries/enums.dart';
import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/app/core/base_api.dart';
import 'jwt_inceptor.dart';

class ApiSyncData extends BaseApi {
  JwtInceptor jwtHandler = JwtInceptor();
  Future<ApiResponse> getUserData(int userId) async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.get,
          'api/userData/get-user-data/$userId',
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
        final userData = UserData.fromMap(jsonDecode(response.body));
        return ApiResponse(success: true, data: userData);
      }
    }
    on ApiException catch (e) {
      DialogService().showSnackBarMessage('Ошибка', e.message);
    }
    catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
  Future<ApiResponse> postUserData(UserData userData) async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.post,
          'api/userData/post-user-data',
          body: {
            'UserId': userData.userId,
            'Name': userData.name,
            'Age': userData.age,
            'BirthDate': userData.birthDate,
            'UserGroup': userData.userGroup,
            'ProfileImagePath': userData.profileImagePath,
            'FavoriteExhibits': userData.favoriteExhibits,
            'Settings': userData.settings
          },
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
        return ApiResponse(success: true);
      }
    }
    on ApiException catch (e) {
      DialogService().showSnackBarMessage('Ошибка', e.message);
    }
    catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
}