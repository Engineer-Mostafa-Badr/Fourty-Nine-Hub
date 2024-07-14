import '../../../../authentication/domain/entities/user_entity.dart';

class TripRequestEntity {
  final String id;
  final String trip;
  final String phone;
  final UserEntity? user;
  final bool isAccepted;
  final bool isRejected;
  final DateTime createdAt;
TripRequestEntity({
  required this.id, 
  required this.trip, 
  required this.createdAt, 
  required this.isAccepted, 
  required this.isRejected, 
  required this.phone, 
  required this.user,
});

}