import '../../domain/entities/contact_us_entity.dart';

class ContactUsModel extends ContactUsEntity {
  ContactUsModel({required super.content, required super.phone});

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(content: json['content'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() => {
        'body': content,
        'phone': phone,
      };
}
