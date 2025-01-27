import 'dart:developer';
import 'dart:io';

import 'package:fourtyninehub/features/ride/Authentication/data/models/base_part_model.dart';

class BasicInfoPartModel implements BasePartModel {
  File? image;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  DateTime? birthDate;
  BasicInfoPartModel(
      {this.firstName, this.image, this.lastName, this.phoneNumber, this.birthDate});
  factory BasicInfoPartModel.fromJson(Map<String, dynamic>? json) {
    return BasicInfoPartModel(
      image: json?['image']== null? null: File(json!['image']),
      firstName: json?['firstName'],
      lastName: json?['lastName'],
      phoneNumber: json?['phoneNumber'],
      birthDate:json?['birthDate'] == null? null: DateTime.tryParse(json?['birthDate'])
    );
  }
  @override
  toJson() {
    return {
      "image": image?.path,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate.toString()
    };
  }
}
