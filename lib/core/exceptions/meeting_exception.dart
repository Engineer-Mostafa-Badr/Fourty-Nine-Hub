import 'package:fourtyninehub/core/data/models/meeting_error_message_model.dart';

class MeetingException implements Exception {
  final MeetingErrorMessageModel errorMessageModel;

  MeetingException(this.errorMessageModel);
}
