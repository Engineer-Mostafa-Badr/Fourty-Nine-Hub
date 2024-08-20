import 'dart:convert';

class AboutYouModel {
  final int? eventId;
  final int? cartId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? countryCode;
  final String? password;
  final String? mobileAppId;
  final bool? receiveEmail;
  final bool? agreeOnTerms;
  AboutYouModel({
    this.eventId,
    this.cartId,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.countryCode,
    this.password,
    this.mobileAppId,
    this.receiveEmail,
    this.agreeOnTerms,
  });

  AboutYouModel copyWith({
    int? eventId,
    int? cartId,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? countryCode,
    String? password,
    String? mobileAppId,
    bool? receiveEmail,
    bool? agreeOnTerms,
  }) {
    return AboutYouModel(
      eventId: eventId ?? this.eventId,
      cartId: cartId ?? this.cartId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      countryCode: countryCode ?? this.countryCode,
      password: password ?? this.password,
      mobileAppId: mobileAppId ?? this.mobileAppId,
      receiveEmail: receiveEmail ?? this.receiveEmail,
      agreeOnTerms: agreeOnTerms ?? this.agreeOnTerms,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'EventId': eventId,
      'CartId': cartId,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Mobile': mobile,
      'CountryCode': countryCode,
      'Password': password,
      'MobileAppId': mobileAppId,
      'ReceiveEmail': receiveEmail,
      'AgreeOnTerms': agreeOnTerms,
    };
  }

  factory AboutYouModel.fromMap(Map<String, dynamic> map) {
    return AboutYouModel(
      eventId: map['eventId']?.toInt(),
      cartId: map['cartId']?.toInt(),
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      mobile: map['mobile'],
      countryCode: map['CountryCode'],
      password: map['password'],
      mobileAppId: map['mobileAppId'],
      receiveEmail: map['receiveEmail'],
      agreeOnTerms: map['agreeOnTerms'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutYouModel.fromJson(String source) =>
      AboutYouModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AboutYouModel(eventId: $eventId, cartId: $cartId, firstName: $firstName, lastName: $lastName, email: $email, mobile: $mobile, password: $password, mobileAppId: $mobileAppId, receiveEmail: $receiveEmail, agreeOnTerms: $agreeOnTerms)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AboutYouModel &&
        other.eventId == eventId &&
        other.cartId == cartId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.mobile == mobile &&
        other.countryCode == countryCode &&
        other.password == password &&
        other.mobileAppId == mobileAppId &&
        other.receiveEmail == receiveEmail &&
        other.agreeOnTerms == agreeOnTerms;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
        cartId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        countryCode.hashCode ^
        password.hashCode ^
        mobileAppId.hashCode ^
        receiveEmail.hashCode ^
        agreeOnTerms.hashCode;
  }
}
