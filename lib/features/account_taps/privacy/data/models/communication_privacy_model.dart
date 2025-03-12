
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/communication_privacy_entity.dart';

class CommunicationPrivacyModel extends CommunicationPrivacyEntity {
  CommunicationPrivacyModel({
    String? userId,
    String? receiveCalls,
    String? receiveSocialMessages,
    String? receiveGreetMessages,
    String? receiveAnonymousMessages,
    String? lastSeen,
  }) : super(
    userId: userId,
    receiveCalls: receiveCalls,
    receiveSocialMessages: receiveSocialMessages,
    receiveGreetMessages: receiveGreetMessages,
    receiveAnonymousMessages: receiveAnonymousMessages,
    lastSeen: lastSeen,
  );

  factory CommunicationPrivacyModel.fromJson(Map<String, dynamic> json) {
    return CommunicationPrivacyModel(
      userId: json['userId'],
      receiveCalls: json['receiveCalls'],
      receiveSocialMessages: json['receiveSocialMessages'],
      receiveGreetMessages: json['receiveGreetMessages'],
      receiveAnonymousMessages: json['receiveAnonymousMessages'],
      lastSeen: json['lastSeen'],
    );
  }


}