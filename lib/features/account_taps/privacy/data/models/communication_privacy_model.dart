
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/communication_privacy_entity.dart';

class CommunicationPrivacyModel extends CommunicationPrivacyEntity {
  CommunicationPrivacyModel({
    super.userId,
    super.receiveCalls,
    super.receiveSocialMessages,
    super.receiveGreetMessages,
    super.receiveAnonymousMessages,
    super.lastSeen,
  });

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