import '../../../../authentication/domain/entities/user_entity.dart';

class ContactUsEntity {
  final String? id;
  final UserEntity? user;
  final String content;
  final String phone;
  ContactUsEntity(
      { this.id,
       this.user,
      required this.content,
      required this.phone});
}
