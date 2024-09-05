import 'package:equatable/equatable.dart';

class RoomResponse extends Equatable {
  final String message;
  final bool success;
  const RoomResponse({
    required this.message,
    required this.success,
  });

  @override
  List<Object> get props => [message, success];
}
