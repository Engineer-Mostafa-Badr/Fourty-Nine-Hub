class CommunicationPrivacyEntity {
  final String? userId;
  final String? receiveCalls;
  final String? receiveSocialMessages;
  final String? receiveGreetMessages;
  final String? receiveAnonymousMessages;
  final String? lastSeen;

  CommunicationPrivacyEntity({
    this.userId,
    this.receiveCalls,
    this.receiveSocialMessages,
    this.receiveGreetMessages,
    this.receiveAnonymousMessages,
    this.lastSeen,
  });
}