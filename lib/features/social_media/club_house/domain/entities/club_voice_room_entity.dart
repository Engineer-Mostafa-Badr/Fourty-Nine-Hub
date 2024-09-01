import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';

class ClubVoiceRoomEntity extends Equatable {
  final String id;
  final String hostname;
  final String subject;
  //will be List<Users>
  final List<UserProfileEntity> users;
  const ClubVoiceRoomEntity({
    required this.id,
    required this.hostname,
    required this.subject,
    required this.users,
  });

  @override
  List<Object> get props => [
        id,
        hostname,
        subject,
        users,
      ];
}
