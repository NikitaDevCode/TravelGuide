import '/libraries/enums.dart';
import '/libraries/controllers.dart';
import '/libraries/custom_packages.dart';
import '/libraries/services.dart';
import '/app/routes/route_names.dart';
import '/libraries/data.dart';
import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart' as http;
import '/libraries/repositories.dart';
import '/app/core/base_api.dart';

class JwtInceptor extends BaseApi {

  Future<Map<String, String>> getJwtAuthHeader() async {
    final tokens = await TokenRepository().get();
    return {'Authorization': 'Bearer ${tokens.accessToken}'};
  }

  Future<http.Response> authenticatedJwtRequest(Future<http.Response> Function() request) async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    var response = await request();
    if (response.statusCode == 401) {
      final tokens = await TokenRepository().get();
      final refreshResponse = await httpMethod(
        ApiMethod.post,
        'api/auth/refresh',
        body: {
          'AccessToken': tokens.accessToken,
          'RefreshToken': tokens.refreshToken,
          'UniqueDeviceId': deviceInfo['uniqueId']
        }
      );
      if (refreshResponse.statusCode == 200) {
        final newTokens = jsonDecode(refreshResponse.body);
        TokenData tokenData = TokenData(
          accessToken: newTokens['accessToken'],
          refreshToken: newTokens['refreshToken'] 
        );
        await TokenRepository().save(tokenData);
        return await request();
      }
      else {
        await UserRepository().clear();
        await TokenRepository().clear();
        Get.find<AuthStateController>().changeAuthState();
        await SharedPrefService().saveBoolData('isAuthorized', false);
        DialogService().showSnackBarMessage('Информация', 'Срок сессии истёк');
        NavigationService().navigateDeleteRouteScreen(RouteNames.loginScreenRoute);
      }
    }
    return response;
  }
}