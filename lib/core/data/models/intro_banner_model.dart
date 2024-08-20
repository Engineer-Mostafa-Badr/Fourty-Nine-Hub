import 'dart:convert';

class IntroBannerModel {
  final int? id;
  final String? icon;
  final String? name;
  final String? content;
  IntroBannerModel({
    this.id,
    this.icon,
    this.name,
    this.content,
  });

  IntroBannerModel copyWith({
    int? id,
    String? icon,
    String? name,
    String? content,
  }) {
    return IntroBannerModel(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'content': content,
    };
  }

  factory IntroBannerModel.fromMap(Map<String, dynamic> map) {
    return IntroBannerModel(
      id: map['id']?.toInt(),
      icon: map['icon'],
      name: map['name'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory IntroBannerModel.fromJson(String source) =>
      IntroBannerModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IntroBannerModel(id: $id, icon: $icon, name: $name, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IntroBannerModel &&
        other.id == id &&
        other.icon == icon &&
        other.name == name &&
        other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^ icon.hashCode ^ name.hashCode ^ content.hashCode;
  }
}
