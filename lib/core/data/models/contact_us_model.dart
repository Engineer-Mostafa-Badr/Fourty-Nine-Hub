import 'dart:convert';

class ContactUsModel {
  final String? mobile;
  final String? email;
  final String? name;
  final String? content;
  final String? address;
  final String? picture;
  final String? location;
  final int? blockType;
  ContactUsModel({
    this.address,
    this.picture,
    this.location,
    this.blockType,
    this.mobile,
    this.email,
    this.name,
    this.content,
  });

  ContactUsModel copyWith({
    String? mobile,
    String? email,
    String? name,
    String? content,
    String? address,
    String? picture,
    String? location,
    int? blockType,
  }) {
    return ContactUsModel(
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      name: name ?? this.name,
      content: content ?? this.content,
      address: address ?? this.address,
      picture: picture ?? this.picture,
      location: location ?? this.location,
      blockType: blockType ?? this.blockType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mobile': mobile,
      'email': email,
      'name': name,
      'content': content,
      'address': address,
      'picture': picture,
      'location': location,
      'blockType': blockType,
    };
  }

  factory ContactUsModel.fromMap(Map<String, dynamic> map) {
    return ContactUsModel(
      mobile: map['mobile'],
      email: map['email'],
      name: map['name'],
      content: map['content'],
      address: map['address'],
      picture: map['picture'],
      location: map['location'],
      blockType: map['blockType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactUsModel.fromJson(String source) =>
      ContactUsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FAQsModel(mobile: $mobile, email: $email, name: $name, content: $content,address:$address,picture:$picture,location:$location,blockType:$blockType,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactUsModel &&
        other.mobile == mobile &&
        other.email == email &&
        other.name == name &&
        other.content == content &&
        other.address == address &&
        other.picture == picture &&
        other.location == location &&
        other.blockType == blockType;
  }

  @override
  int get hashCode {
    return mobile.hashCode ^
        email.hashCode ^
        name.hashCode ^
        content.hashCode ^
        address.hashCode ^
        picture.hashCode ^
        location.hashCode ^
        blockType.hashCode;
  }
}
