import 'package:equatable/equatable.dart';

class MeetingErrorMessageModel extends Equatable {
  final bool success;
  final int statusCode;
  final String statusMessage;

  const MeetingErrorMessageModel({
    required this.success,
    required this.statusCode,
    required this.statusMessage,
  });

  @override
  List<Object?> get props => [
        success,
        statusCode,
        statusMessage,
      ];

  factory MeetingErrorMessageModel.fromJson(Map<String, dynamic> json) =>
      MeetingErrorMessageModel(
        success: json['success'],
        statusCode: json['error']['httpCode'],
        statusMessage: json['error']['message'],
      );
}
