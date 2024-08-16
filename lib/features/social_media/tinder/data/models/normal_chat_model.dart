class NormalChatResponse {
  final bool status;
  final ChatData data;

  NormalChatResponse({
    required this.status,
    required this.data,
  });

  factory NormalChatResponse.fromJson(Map<String, dynamic> json) {
    return NormalChatResponse(
      status: json['status'],
      data: ChatData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ChatData {
  final Chat chat;
  final Contact contactForCurrent;
  final Contact contactForReceiver;

  ChatData({
    required this.chat,
    required this.contactForCurrent,
    required this.contactForReceiver,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chat: Chat.fromJson(json['chat']),
      contactForCurrent: Contact.fromJson(json['contactForCurrent']),
      contactForReceiver: Contact.fromJson(json['contactForReceiver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat': chat.toJson(),
      'contactForCurrent': contactForCurrent.toJson(),
      'contactForReceiver': contactForReceiver.toJson(),
    };
  }
}

class Chat {
  final String id;
  final String categoryId;
  final String privacy;
  final String type;
  final List<String> anonymousContacts;
  final List<String> archived;
  final List<String> contacts;
  final DateTime createdAt;
  final List<String> locked;
  final List<String> muted;
  final List<String> participants;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.categoryId,
    required this.privacy,
    required this.type,
    required this.anonymousContacts,
    required this.archived,
    required this.contacts,
    required this.createdAt,
    required this.locked,
    required this.muted,
    required this.participants,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      categoryId: json['categoryId'],
      privacy: json['privacy'],
      type: json['type'],
      anonymousContacts: List<String>.from(json['anonymousContacts']),
      archived: List<String>.from(json['archived']),
      contacts: List<String>.from(json['contacts']),
      createdAt: DateTime.parse(json['createdAt']),
      locked: List<String>.from(json['locked']),
      muted: List<String>.from(json['muted']),
      participants: List<String>.from(json['participants']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryId': categoryId,
      'privacy': privacy,
      'type': type,
      'anonymousContacts': anonymousContacts,
      'archived': archived,
      'contacts': contacts,
      'createdAt': createdAt.toIso8601String(),
      'locked': locked,
      'muted': muted,
      'participants': participants,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Contact {
  final String id;
  final String contactUserId;
  final String ownerUserId;
  final String privacy;
  final String categoryId;
  final DateTime createdAt;
  final String name;
  final String tab;
  final DateTime updatedAt;

  Contact({
    required this.id,
    required this.contactUserId,
    required this.ownerUserId,
    required this.privacy,
    required this.categoryId,
    required this.createdAt,
    required this.name,
    required this.tab,
    required this.updatedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id'],
      contactUserId: json['contactUserId'],
      ownerUserId: json['ownerUserId'],
      privacy: json['privacy'],
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
      name: json['name'],
      tab: json['tab'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'contactUserId': contactUserId,
      'ownerUserId': ownerUserId,
      'privacy': privacy,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'tab': tab,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
