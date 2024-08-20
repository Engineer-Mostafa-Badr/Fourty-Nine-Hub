import 'dart:convert';

class Topic {
  final int? blockType;
  final String? name;
  final String? content;
  final String? picture;
  Topic({
    this.blockType,
    this.name,
    this.content,
    this.picture,
  });

  Topic copyWith({
    int? blockType,
    String? name,
    String? content,
    String? picture,
  }) {
    return Topic(
      blockType: blockType ?? this.blockType,
      name: name ?? this.name,
      content: content ?? this.content,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blockType': blockType,
      'name': name,
      'content': content,
      'picture': picture,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      blockType: map['blockType']?.toInt(),
      name: map['name'],
      content: map['content'],
      picture: map['picture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Topic.fromJson(String source) => Topic.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Topic(blockType: $blockType, name: $name, content: $content, picture: $picture)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Topic &&
        other.blockType == blockType &&
        other.name == name &&
        other.content == content &&
        other.picture == picture;
  }

  @override
  int get hashCode {
    return blockType.hashCode ^
        name.hashCode ^
        content.hashCode ^
        picture.hashCode;
  }
}
