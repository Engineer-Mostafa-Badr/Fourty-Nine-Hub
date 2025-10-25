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

String? validatorEmail(String? email) {
  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  if (email == null || email.isEmpty) {
    return LocaleKeys.emailRequired.localize;
  } else if (!emailRegex.hasMatch(email)) {
    return LocaleKeys.invalidEmailAddress.localize;
  }
  return null;
}

String? validatorPhone(String? phone) {
  final phoneRegex = RegExp(r'^\+?\d{11}$');
  if (phone == null || phone.isEmpty) {
    return LocaleKeys.required.localize;
  } else if (!phoneRegex.hasMatch(phone) && phone.length != 11) {
    return LocaleKeys.invalidPhoneNumber.localize;
  }
  return null;
}

String? validateEgyptianPhone(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.phoneIsRequired.localize;
  }

  final RegExp phoneRegex = RegExp(r'^(01[0125])[0-9]{8}$');
  if (!phoneRegex.hasMatch(value)) {
    return LocaleKeys.invalidPhoneNumber.localize;
  }

  return null;
}

String? validatorEmailOrPhone(String? value) {
  String email = (value ?? '').trim().toLowerCase();
  final egyptPhoneRegex = RegExp(r'^(010|011|012|015)\d{8}$');
  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

  if (email.isEmpty) {
    return LocaleKeys.required.localize;
  }

  if (RegExp(r'^\d+$').hasMatch(email)) {
    if (!egyptPhoneRegex.hasMatch(email)) {
      return LocaleKeys.invalidPhoneNumber.localize;
    }
    return null;
  }

  if (!emailRegex.hasMatch(email)) {
    return LocaleKeys.invalidEmailAddress.localize;
  }

  return null;
}

String? validatorEgyptPhone(String? phoneNumber) {
  // Regex for Egyptian mobile numbers
  // This regex allows for:
  // - Optional country code (+20 or 0020)
  // - Starts with 01 (for mobile numbers)
  // - Followed by 0, 1, 2, or 5 (for network providers: Vodafone, Etisalat, Orange, WE)
  // - Followed by 8 more digits
  final egyptianPhoneRegex = RegExp(r'^(?:\+20|0020|0)?1[0125]\d{8}$');

  if (phoneNumber == null || phoneNumber.isEmpty) {
    return LocaleKeys.required.localize;
  } else if (!egyptianPhoneRegex.hasMatch(phoneNumber)) {
    return LocaleKeys.invalidPhoneNumber.localize;
  }
  return null;
}

String? validatorNotHavePhone(String? email) {
  final phonePattern = RegExp(
      r'(\+\d{1,3}[\s-]?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}|' // Common formats: +1 (123) 456-7890, 123-456-7890
      r'\d{10}|' // 10 consecutive digits
      r'\d{3}[\s.-]\d{3}[\s.-]\d{4}|' // 123 456 7890, 123.456.7890
      r'\+\d{10,}' // International format: +1234567890
      );
  if (email == null || email.isEmpty) {
    return LocaleKeys.required.localize;
  } else if (phonePattern.hasMatch(email)) {
    return LocaleKeys.phoneNumbersNotAllowed.localize;
  }
  return null;
}

String? validatorNumber(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.required.localize;
  }
  final number = int.tryParse(value);
  if (number == null || number <= 0) {
    return 'Enter a positive number';
  }
  return null;
}
