import 'package:equatable/equatable.dart';

class SendNotificationParams extends Equatable {
  final String? to;
  final String? title;
  final String? body;
  final Map<String, dynamic>? additionalNotificationInfo;
  final Map<String, dynamic>? additionalData;

  const SendNotificationParams(
      {this.to,
      this.title,
      this.body,
      this.additionalNotificationInfo,
      this.additionalData});

  Map<String, dynamic> toMap() => {
        'message': {
          if (to != null) "token": to,
          "android": {"priority": "high"},
          if (title != null || body != null)
            "notification": {
              if (title != null) "title": title,
              if (body != null) "body": body,
              if (additionalNotificationInfo != null)
                ...additionalNotificationInfo!,
            },
          "data": {
            if (additionalData != null) ...additionalData!,
          },
        }
      };

  @override
  List<Object?> get props =>
      [to, title, body, additionalNotificationInfo, additionalData];
}
