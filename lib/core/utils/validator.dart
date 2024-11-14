import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../localization/locale_keys.g.dart';

class Validator {
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Empty Field Not Valid';
    } else if (_isInvalidEmail(email)) {
      return "Invalid Email Address";
    }
    return null;
  }

  bool _isInvalidEmail(String? email) {
    if (email == null) return true;
    final regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return !regExp.hasMatch(email);
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Empty Field Not Valid";
    } else if (password.isEmpty) {
      return "Invalid Password Less Than 8 Characters";
    }
    return null;
  }

  String? validateConfPassword(String? password, String? confPassword) {
    if (password == null || password.isEmpty || password != confPassword) {
      return "Does Not Match With Password";
    }
    return null;
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "Empty Field Not Valid";
    } else if (!RegExp(r"(01)[0-9]{9,9}$").hasMatch(phoneNumber)) {
      return "Invalid Phone Number";
    }
    return null;
  }
  String? emptyValidation(String? text) {
    if (text == null || text.isEmpty) {
      return "Empty Field Not Valid";
    }
    return null;
  }

  String? validateLandLineNumber(String? landLineNumber) {
    if (landLineNumber == null || landLineNumber.isEmpty) {
      return null;
    } else if (!RegExp(r"[0-9]{7,13}$").hasMatch(landLineNumber)) {
      return "Invalid Phone Number";
    }
    return null;
  }

  String? validateUserName(String? userName) {
    if (userName == null || userName.trim().isEmpty) {
      return LocaleKeys.emptyFieldNotValid.localize;
    } else if (userName.length < 2) {
      return 'Must Be At Least_2';
    }
    return null;
  }

  String? validateBirthDate(String? birthdate) {
    if (birthdate == null || birthdate.isEmpty) {
      return 'Empty Field Not Valid';
    } else if (_isNotAllowedAge(birthdate)) {
      return "Not Allowed For Users Under Years Old";
    }
    return null;
  }

  bool _isNotAllowedAge(String? birthdate) {
    if (birthdate == null) return true;
    final userBirthDate = DateTime.parse(birthdate);
    final currentDate = DateTime.now();
    final userAge = (currentDate.difference(userBirthDate).inDays) ~/ 365;
    const allowedAge = 18;
    return userAge < allowedAge;
  }

  String? validateEmptyField(String? text) => text == null || text.isEmpty
      ? LocaleKeys.emptyFieldNotValid.localize
      : null;

  String? validateEmptyValue(String? value) =>
      value == null ? "Empty Field Not Valid" : null;

  String? shouldNotContainNumbers(String? text) {
    if (text != null && text.contains(RegExp(r'[0-9]'))) {
      return "Can't Contain Numbers";
    }
    return null;
  }
}
