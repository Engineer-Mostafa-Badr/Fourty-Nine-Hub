class ReasonsModel {
  String? id;
  String? reason;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReasonsModel({this.id, this.reason, this.createdAt, this.updatedAt});

  factory ReasonsModel.fromJson(Map<String, dynamic> json) => ReasonsModel(
        id: json['_id'] as String?,
        reason: json['reason'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'reason': reason,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
