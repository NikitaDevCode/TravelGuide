import '/libraries/models.dart';
import '/libraries/database.dart';
import '/libraries/enums.dart';
import '/libraries/controllers.dart';
import '/libraries/repositories.dart';
import '/libraries/services.dart';
import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';
import '/libraries/classes.dart';
import '/app/core/base_api.dart';
import 'jwt_inceptor.dart';

class ApiAccount extends BaseApi {
  Logger logger = Logger();
  JwtInceptor jwtHandler = JwtInceptor();
  Future<ApiResponse> changeEmail(String newEmail, String password) async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.post,
          'api/account/change-email',
          body: {
            'NewEmail': newEmail,
            'Password': password
          },
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
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
          return ApiResponse(success: true);
        }
      }
    }
    on ApiException catch (e) {
      Get.snackbar('Ошибка', e.message);
    }
    catch (_) {
      Get.snackbar('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
  Future<ApiResponse> changeLogin(String newLogin, String password) async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.post,
          'api/account/change-login',
          body: {
            'NewLogin': newLogin,
            'Password': password
          },
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
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
          return ApiResponse(success: true);
        }
      }
    }
    on ApiException catch (e) {
      Get.snackbar('Ошибка', e.message);
    }
    catch (_) {
      Get.snackbar('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
  Future<ApiResponse> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.post,
          'api/account/change-password',
          body: {
            'OldPassword': oldPassword,
            'NewPassword': newPassword
          },
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
        return ApiResponse(success: true);
      }
    }
    on ApiException catch (e) {
      Get.snackbar('Ошибка', e.message);
    }
    catch (_) {
      Get.snackbar('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
  Future<ApiResponse> deleteAccount(String password) async {
    final userDataController = Get.find<UserDataController>();
    final userData = userDataController.userData;
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.delete,
          'api/account/delete-account',
          body: {
            'Password': password
          },
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
        await UserDataDatabase().deleteUserData(userData.userId);
        await UserRepository().clear();
        await TokenRepository().clear();
        Get.find<AuthStateController>().changeAuthState();
        await SharedPrefService().saveBoolData('isAuthorized', false);
        DialogService().showSnackBarMessage('Информация', jsonDecode(response.body));
        return ApiResponse(success: true);
      }
    }
    on ApiException catch (e) {
      Get.snackbar('Ошибка', e.message);
    }
    catch (_) {
      Get.snackbar('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
}