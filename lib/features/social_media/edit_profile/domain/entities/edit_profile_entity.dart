class EditProfileEntity {
  final String firstName;
  final String lastName;
  final String bio;
  final String bioPrivacy;
  final String phone;
  final String phonePrivacy;
  final String job;
  final String jobPrivacy;
  final String country;
  final String countryPrivacy;
  final String city;
  final String cityPrivacy;
  bool? isMale;

  EditProfileEntity(this.bioPrivacy, this.phonePrivacy, this.jobPrivacy,
      this.countryPrivacy, this.cityPrivacy,
      {required this.firstName,
      required this.lastName,
      required this.bio,
      required this.phone,
      required this.job,
      required this.country,
      required this.city,
      this.isMale = true});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'bio': bio,
        'bioPrivacy': bioPrivacy,
        'phone': phone,
        'phonePrivacy': phonePrivacy,
        'job': job,
        'jobPrivacy': jobPrivacy,
        'country': country,
        'countryPrivacy': countryPrivacy,
        'city': city,
        'cityPrivacy': cityPrivacy,
        'gender': isMale == true ? 'male' : 'female',
      };
}
