import 'package:equatable/equatable.dart';

class ReceiverCommentEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  // final String profilePictureSignedUrl;

  const ReceiverCommentEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    // required this.profilePictureSignedUrl,
  });

  @override
  List<Object?> get props => [id, firstName, lastName];
}
