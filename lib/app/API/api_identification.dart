import 'package:travel_guide/app/enums/api_method.dart';

import '/libraries/services.dart';
import '/libraries/classes.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';
import '/app/core/base_api.dart';

class ApiIdentification extends BaseApi {
  Future<ApiResponse> forgotPassword(String email) async {
    try {
      final response = await httpMethod(
        ApiMethod.post,
        'api/identification/forgot-password',
        body: {
          'Email': email
        }
      );
      if (response.body.isNotEmpty) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
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
  Future<ApiResponse> checkCode(String code, String email) async {
    try {
      final response = await httpMethod(
        ApiMethod.post,
        'api/identification/check-code',
        body: {
          'Code': code,
          'Email': email
        }
      );
      if (response.statusCode == 200) {
        return ApiResponse(success: true);
      }
    }
    on ApiException catch (e) {
      DialogService().showSnackBarMessage('Ошибка', e.message);
    }
    catch (_) {
      Get.snackbar('Ошибка', 'Произошла неизвестная ошибка');
    }
    return ApiResponse(success: false);
  }
  Future<ApiResponse> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await httpMethod(
        ApiMethod.post,
        'api/identification/reset-password',
        body: {
          'Email': email,
          'Code': code,
          'NewPassword': newPassword
        }
      );
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