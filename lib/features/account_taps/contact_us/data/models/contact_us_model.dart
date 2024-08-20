import '../../../../authentication/data/models/user_model.dart';
import '../../domain/entities/contact_us_entity.dart';

class ContactUsModel extends ContactUsEntity {
  ContactUsModel(
      {super.id, super.user, required super.content, required super.phone});

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
        id: json['id'],
        content: json['content'],
        phone: json['phone'],
        user: UserModel.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'phone': phone,
      };
}
