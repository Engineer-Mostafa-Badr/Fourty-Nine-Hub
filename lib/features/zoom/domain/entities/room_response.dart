// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class RoomResponseError extends Equatable {
  final String message;
  final bool success;
  const RoomResponseError({
    required this.message,
    required this.success,
  });

  @override
  List<Object> get props => [message, success];
}
