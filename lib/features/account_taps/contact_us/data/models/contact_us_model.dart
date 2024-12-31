import '../../domain/entities/contact_us_entity.dart';

class ContactUsModel extends ContactUsEntity {
  ContactUsModel({required super.content, super.phone});

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
      content: json['content'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'body': content,
    };

    // Include 'phone' only if it is not null or empty
    if (phone != null && phone!.isNotEmpty) {
      data['phone'] = phone;
    }

    return data;
  }
}
