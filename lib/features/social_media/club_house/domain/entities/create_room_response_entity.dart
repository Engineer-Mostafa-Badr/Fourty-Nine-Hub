// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CreateRoomResponseEntity extends Equatable {
  final String roomId;
  final bool status;
  const CreateRoomResponseEntity({
    required this.roomId,
    required this.status,
  });
  

  @override
  List<Object> get props => [roomId,status];
}
