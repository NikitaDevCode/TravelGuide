import '/libraries/enums.dart';
import '/libraries/classes.dart';
import '/libraries/services.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';
import '/libraries/models.dart';
import '/libraries/data.dart';
import '/libraries/repositories.dart';
import '/app/core/base_api.dart';
import 'jwt_inceptor.dart';
class ApiAuth extends BaseApi {
  JwtInceptor jwtHandler = JwtInceptor();
  Future<ApiResponse> loginUser(String loginOrEmail, String password) async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    try {
      final response = await httpMethod(
        ApiMethod.post,
        'api/auth/login',
        body: {
          'LoginOrEmail': loginOrEmail,
          'Password': password,
          'UniqueDeviceId': deviceInfo['uniqueId'],
          'Device': {
            'DeviceType': deviceInfo['deviceType'],
            'Model': deviceInfo['model'],
            'OsVersion': deviceInfo['osVersion']
          }
        } 
      );
      final tokens = jsonDecode(response.body);
      TokenData tokenData = TokenData(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'] 
      );
      await TokenRepository().save(tokenData);
      final userResponse = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.get,
          'api/account/get-user-data',
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (userResponse.statusCode == 200) {
        final user = User.fromMap(jsonDecode(userResponse.body));
        await UserRepository().save(user);
        Get.find<AuthStateController>().changeAuthState();
        await SharedPrefService().saveBoolData('isAuthorized', true);
        DialogService().showSnackBarMessage('Информация', 'Авторизация прошла успешно');
        return ApiResponse(success: true);
      }
    }
    on ApiException catch (e) {
      DialogService().showSnackBarMessage('Ошибка', e.message);
    } catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
  Future<ApiResponse> registerUser(String email, String login, String password) async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    try {
      final response = await httpMethod(
        ApiMethod.post,
        'api/auth/register',
        body: {
          'Email': email,
          'Login': login,
          'Password': password,
          'UniqueDeviceId': deviceInfo['uniqueId'],
          'Device': {
            'DeviceType': deviceInfo['deviceType'],
            'Model': deviceInfo['model'],
            'OsVersion': deviceInfo['osVersion']
          }
        }
      );
      if (response.statusCode == 200) {
        final tokens = jsonDecode(response.body);
        TokenData tokenData = TokenData(
          accessToken: tokens['accessToken'],
          refreshToken: tokens['refreshToken'] 
        );
        await TokenRepository().save(tokenData);
        final userResponse = await jwtHandler.authenticatedJwtRequest(() async {
          return await httpMethod(
            ApiMethod.get,
            'api/account/get-user-data',
            headers: await jwtHandler.getJwtAuthHeader()
          );
        });
        if (userResponse.statusCode == 200) {
          final user = User.fromMap(jsonDecode(userResponse.body));
          await UserRepository().save(user);
          Get.find<AuthStateController>().changeAuthState();
          await SharedPrefService().saveBoolData('isAuthorized', true);
          DialogService().showSnackBarMessage('Информация', 'Регистрация прошла успешно');
          return ApiResponse(success: true, data: user.id);
        }
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