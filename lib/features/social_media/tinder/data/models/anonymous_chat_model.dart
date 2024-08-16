class AnonymousChatResponse {
  final bool status;
  final ContactChatData data;

  AnonymousChatResponse({
    required this.status,
    required this.data,
  });

  factory AnonymousChatResponse.fromJson(Map<String, dynamic> json) {
    return AnonymousChatResponse(
      status: json['status'],
      data: ContactChatData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ContactChatData {
  final Contact contactForCurrent;
  final Contact contactForReceiver;
  final Chat chat;

  ContactChatData({
    required this.contactForCurrent,
    required this.contactForReceiver,
    required this.chat,
  });

  factory ContactChatData.fromJson(Map<String, dynamic> json) {
    return ContactChatData(
      contactForCurrent: Contact.fromJson(json['contactForCurrent']),
      contactForReceiver: Contact.fromJson(json['contactForReceiver']),
      chat: Chat.fromJson(json['chat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactForCurrent': contactForCurrent.toJson(),
      'contactForReceiver': contactForReceiver.toJson(),
      'chat': chat.toJson(),
    };
  }
}

class Contact {
  final String id;
  final String contactUserId;
  final String ownerUserId;
  final String categoryId;
  final DateTime createdAt;
  final String name;
  final DateTime updatedAt;

  Contact({
    required this.id,
    required this.contactUserId,
    required this.ownerUserId,
    required this.categoryId,
    required this.createdAt,
    required this.name,
    required this.updatedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id'],
      contactUserId: json['contactUserId'],
      ownerUserId: json['ownerUserId'],
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
      name: json['name'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'contactUserId': contactUserId,
      'ownerUserId': ownerUserId,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Chat {
  final String id;
  final String categoryId;
  final String privacy;
  final String type;
  final List<String> archived;
  final List<String> contacts;
  final DateTime createdAt;
  final List<String> locked;
  final List<String> muted;
  final List<String> participants;
  final DateTime updatedAt;
  final String lastMessage;
  final List<String> anonymousContacts;

  Chat({
    required this.id,
    required this.categoryId,
    required this.privacy,
    required this.type,
    required this.archived,
    required this.contacts,
    required this.createdAt,
    required this.locked,
    required this.muted,
    required this.participants,
    required this.updatedAt,
    required this.lastMessage,
    required this.anonymousContacts,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      categoryId: json['categoryId'],
      privacy: json['privacy'],
      type: json['type'],
      archived: List<String>.from(json['archived']),
      contacts: List<String>.from(json['contacts']),
      createdAt: DateTime.parse(json['createdAt']),
      locked: List<String>.from(json['locked']),
      muted: List<String>.from(json['muted']),
      participants: List<String>.from(json['participants']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastMessage: json['lastMessage'] ?? '',
      anonymousContacts: List<String>.from(json['anonymousContacts']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryId': categoryId,
      'privacy': privacy,
      'type': type,
      'archived': archived,
      'contacts': contacts,
      'createdAt': createdAt.toIso8601String(),
      'locked': locked,
      'muted': muted,
      'participants': participants,
      'updatedAt': updatedAt.toIso8601String(),
      'lastMessage': lastMessage,
      'anonymousContacts': anonymousContacts,
    };
  }
}
