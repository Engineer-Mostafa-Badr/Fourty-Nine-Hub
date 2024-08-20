import 'dart:convert';

class ContactUsMessage {
  final String name;
  final String email;
  final String? mobile;
  final String? subject;
  final String message;
  final String? id;
  ContactUsMessage({
    required this.name,
    required this.email,
    this.mobile,
    this.subject,
    required this.message,
    this.id,
  });

  ContactUsMessage copyWith({
    String? name,
    String? email,
    String? mobile,
    String? subject,
    String? message,
    String? id,
  }) {
    return ContactUsMessage(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'subject': subject,
      'message': message,
      'id': id,
    }..removeWhere((_, v) => v == null);
  }

  factory ContactUsMessage.fromMap(Map<String, dynamic> map) {
    return ContactUsMessage(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'],
      subject: map['subject'],
      message: map['message'] ?? '',
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactUsMessage.fromJson(String source) =>
      ContactUsMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactUsMessage(name: $name, email: $email, mobile: $mobile, subject: $subject, message: $message, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactUsMessage &&
        other.name == name &&
        other.email == email &&
        other.mobile == mobile &&
        other.subject == subject &&
        other.message == message &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        subject.hashCode ^
        message.hashCode ^
        id.hashCode;
  }
}
