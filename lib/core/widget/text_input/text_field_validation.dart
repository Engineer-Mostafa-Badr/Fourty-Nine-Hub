enum TextFieldValidatorType {
  email,
  password,
  confirmPassword,
  phoneNumber,
  emailOrPhoneNumber,
  emailNotRequire,
  normalText,
  code,
  number,
  displayText,
  optional,
  name,
  cardNumber,
  cvc,
}

validation(
  context, {
  required TextFieldValidatorType type,
  required String value,
  bool isNew = false,
  String? confirm,
}) {
  /*else if (!regExpPhone.hasMatch(value.arabicNumberToEnglish)) {
      debugPrint('value.arabicNumberToEnglish');
      debugPrint("${value.arabicNumberToEnglish}");
      return StorageHelper. getLanguagePrefs() == 'ar'
          ? 'رقم الهاتف غير صحيح'
          : 'Invalid phone number';
    }
    return null;*/
  if (type == TextFieldValidatorType.name) {
    if (value.isEmpty) {
      return 'Name is required';
    }
    // if (!regExpName.hasMatch(value.trim().replaceAll('‎', ''))) {
    // return  "Don't enter special chars";
    // }
    return null;
  } else if (type == TextFieldValidatorType.phoneNumber) {
    if (value.isEmpty) {
      return 'Phone number is required';
      //|| RegExp(r'[^\d]+').hasMatch(value) -> Contains characters that are not numbers.
    } else if (value.trim().length != 11) {
      return 'Phone number must be 11 digits';
    }
  } else if (type == TextFieldValidatorType.email) {
    if (value.isEmpty) {
      return 'Email address is required';
    } else if (!regExpEmail.hasMatch(value)) {
      return 'Invalid email address';
    } else if (!regExpEmail
        .hasMatch(value.trim().replaceAll(RegExp(r'[\u0600-\u06FF]'), ''))) {
      return "Don't enter Arabic words";
    } else {
      return null;
    }
  } else if (type == TextFieldValidatorType.emailOrPhoneNumber) {
    if (value.isEmpty) {
      return 'Enter email address or phone number';
    } else {
      if (value.startsWith(RegExp(r'[0-9]'))) {
        if (value.length < 6 || value.length > 11) {
          return 'Enter a valid phone number';
        }
      } else {
        if (!regExpEmail.hasMatch(value)) {
          return 'Invalid email address';
        }
      }
    }
  } else if (type == TextFieldValidatorType.password) {
    if (value.isEmpty) {
      return isNew
          ? 'Please enter the new password'
          : 'Please enter password';
    } else if (value.length < 6) {
      return 'Password must be 6 chars or more';
    } else if (confirm != null) {
      if (value == confirm) {
        return 'new password and old password are identical'
            ;
      }
    } else if (value.length > 25) {
      return 'Password exceed max length';
    } else {
      return null;
    }
  }

  // else if (type == TextFieldValidatorType.newPassword) {
  //   if (value.isEmpty) {
  //     return  'Please enter the new password';
  //   } else if (value.length < 6) {
  //     return'Password must be 6 chars or more';
  //   } else if (value.length > 25) {
  //     return 'Password exceed max length';
  //   } else {
  //     return null;
  //   }}

  else if (type == TextFieldValidatorType.confirmPassword) {
    if (value.isEmpty) {
      return 'Please re-enter the new password';
    } else if (value != confirm) {
      return 'Password does not match';
    } else {
      return null;
    }
  } else if (type == TextFieldValidatorType.code) {
    if (value.isEmpty) {
      return 'This field is required';
    }
  } else if (type == TextFieldValidatorType.optional) {
    return null;
  } else if (type == TextFieldValidatorType.number) {
    if (value.isEmpty) {
      return 'This field is required';
    }
  } else if (type == TextFieldValidatorType.cardNumber) {
    if (value.isEmpty) {
      return 'Please enter your payment card number'
          ;
    } else if (value.length != 16) {
      return 'It must be 16 digits';
    }
  } else if (type == TextFieldValidatorType.cvc) {
    if (value.isEmpty) {
      return 'This field is required';
    } else if (value.length != 3) {
      return 'CVC must be 3 digits';
    }
  } else if (type == TextFieldValidatorType.normalText) {
    if (value.isEmpty) {
      return 'This field is required';
    }
  } else if (type == TextFieldValidatorType.emailNotRequire) {
    if (value.isEmpty) {
      return null;
    } else if (!regExpEmail.hasMatch(value)) {
      return 'invalid email';
    } else {
      return null;
    }
  } else if (type == TextFieldValidatorType.displayText) {
    return null;
  }
}

RegExp regExpPhone = RegExp(
  r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})+$',
  caseSensitive: false,
  multiLine: false,
);

RegExp regExpEmail = RegExp(
  r'(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))+$',
  caseSensitive: false,
  multiLine: false,
);

RegExp regExpName = RegExp(
  r"^[a-zA-Z\u00C0-\u017F ,.'-]*$",
  caseSensitive: false,
  unicode: true,
  dotAll: true,
  multiLine: false,
);

RegExp regExpNumber = RegExp(
  r"^(?:[0]9)?[0-9]{10}$",
  caseSensitive: false,
  unicode: true,
  dotAll: true,
  multiLine: false,
);
