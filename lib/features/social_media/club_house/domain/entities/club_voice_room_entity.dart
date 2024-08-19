import 'package:equatable/equatable.dart';

class ClubVoiceRoomEntity extends Equatable {
  final String id;
  final String hostname;
  final String subject;
  //will be List<Users>
  final List users;
  const ClubVoiceRoomEntity({
    required this.id,
    required this.hostname,
    required this.subject,
    required this.users,
  });

  @override
  List<Object> get props => [id, hostname, subject, users];
}
