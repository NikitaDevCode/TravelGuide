import '/libraries/custom_packages.dart';

class ValidatorUtil {
  static final RegExp _regexLogin = RegExp(r'^[a-zA-Z0-9._-]+$');
  static final RegExp _regexPass = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$');
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле не заполнено';
    }
    else if (!EmailValidator.validate(value)) {
      return 'Email не корректный';
    }
    else {
      return null;
    }
  }
  static String? validateLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле не заполнено';
    }
    else if (value.length < 3) {
      return 'Логин должен быть не менее 3 символов';
    }
    else if (!_regexLogin.hasMatch(value)) {
      return 'Используйте только буквы, цифры и символы _ . -';
    }
    else {
      return null;
    }
  }
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле не заполнено';
    }
    else if (value.length < 8) {
      return 'Пароль должен быть не менее 8 символов';
    }
    else if (!_regexPass.hasMatch(value)) {
      return 'Пароль должен содержать заглавные, строчные, цифры и спецсимволы';
    }
    else {
      return null;
    }
  }
  static String? validateConfirmPassword(String? value, String pass) {
    if (value == null || value.isEmpty) {
      return 'Поле не заполнено';
    }
    else if (value != pass) {
      return 'Пароли не совпадают';
    }
    else {
      return null;
    }
  }
  
  static String? validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле не заполнено';
    }
    else {
      return null;
    }
  }
}