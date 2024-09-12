// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FirebaseNotificationEntitiy {
  String? path;
  Map<String, dynamic>? payload;
  String? clickAction;
  String? status;
  FirebaseNotificationEntitiy({
    this.path,
    this.payload,
    this.clickAction,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'payLoad': payload,
      'click_action': clickAction,
      'status': status,
    };
  }

  factory FirebaseNotificationEntitiy.fromMap(Map<String, dynamic> map) {
    return FirebaseNotificationEntitiy(
      path: map['path'] != null ? map['path'] as String : null,
      payload: map['payload'] != null ? jsonDecode(map['payload']) : null,
      clickAction:
          map['click_action'] != null ? map['click_action'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  FirebaseNotificationEntitiy copyWith({
    String? path,
    Map<String, dynamic>? payload,
    String? clickAction,
    String? status,
  }) {
    return FirebaseNotificationEntitiy(
      path: path ?? this.path,
      payload: payload ?? this.payload,
      clickAction: clickAction ?? this.clickAction,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'FirebaseNotificationEntitiy(path: $path, payLoad: $payload, clickAction: $clickAction, status: $status)';
  }
}

/*
{
path: /TripJoinRequestNotification, 
payload:
   {
   "requestId":"66d877d733f6c5f85b894e37",
   "type":"services"
   }, 
   click_action: FLUTTER_NOTIFICATION_CLICK, 
   status: success}
 */
