import '/libraries/enums.dart';
import '/app/routes/route_names.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/repositories.dart';
import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/libraries/system_packages.dart';
import '/libraries/models.dart';
import '/app/core/base_api.dart';
import 'jwt_inceptor.dart';

class ApiSecurity extends BaseApi {
  JwtInceptor jwtHandler = JwtInceptor();
  Future<List<Device>> getDevices() async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.get,
          'api/security/get-devices',
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Device.fromMap(e)).toList();
    }
    on ApiException catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Ошибка загрузки устройств');
    } catch (e) {
      DialogService().showSnackBarMessage('Ошибка', 'Произошла неизвестная ошибка');
    }
    return [];
  }
  Future<ApiResponse> logoutDevice({required String uniqueId}) async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.post,
          'api/security/logout',
          body: {
            'UniqueId': uniqueId
          },
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
        return ApiResponse(success: true);
      }
    } on ApiException catch (e) {
      DialogService().showSnackBarMessage('Ошибка', e.message);
    } catch (_) {
      DialogService().showSnackBarMessage('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
  Future<ApiResponse> logoutUser() async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.post,
          'api/security/logout',
          body: {
            'UniqueId': deviceInfo['uniqueId']
          },
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
        await UserRepository().clear();
        await TokenRepository().clear();
        Get.find<AuthStateController>().changeAuthState();
        await SharedPrefService().saveBoolData('isAuthorized', false);
        DialogService().showSnackBarMessage('Информация', jsonDecode(response.body));
        NavigationService().navigateDeleteRouteScreen(RouteNames.loginScreenRoute);
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
  Future<ApiResponse> logoutAll() async {
    try {
      final response = await jwtHandler.authenticatedJwtRequest(() async {
        return await httpMethod(
          ApiMethod.post,
          'api/security/logout-all',
          headers: await jwtHandler.getJwtAuthHeader()
        );
      });
      if (response.statusCode == 200) {
        await UserRepository().clear();
        await TokenRepository().clear();
        Get.find<AuthStateController>().changeAuthState();
        await SharedPrefService().saveBoolData('isAuthorized', false);
        DialogService().showSnackBarMessage('Информация', jsonDecode(response.body));
        NavigationService().navigateDeleteRouteScreen(RouteNames.loginScreenRoute);
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