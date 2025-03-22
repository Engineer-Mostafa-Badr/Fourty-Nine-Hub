class PersonalPrivacyEntity {
  final String? userId;
  final Map<String, dynamic>? allowedUsers;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? country;
  final String? city;
  final String? job;
  final String? birthDay;
  final String? language;

  PersonalPrivacyEntity({
    this.userId,
    this.allowedUsers,
    this.email,
    this.phoneNumber,
    this.gender,
    this.country,
    this.city,
    this.job,
    this.birthDay,
    this.language,
  });
}