import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';

import 'receiver_id.dart';

class NotificationModel extends NotificationEntity {
  @override
  String? id;
  dynamic userId;
  ReceiverInfo? receiverInfo;
  @override
  String? filterType;
  String? subcategoryId;
  String? mainCategoryId;
  @override
  bool? read;
  String? titleTranslationCode;
  String? bodyTranslationCode;
  @override
  String? path;
  @override
  Map<String, dynamic>? payload;
  int? time;
  @override
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  @override
  bool? hasNextPage;
  @override
  int? nextPageNumber;
  @override
  String? userImageUrl;

  NotificationModel({
    this.id,
    this.userId,
    this.receiverInfo,
    this.filterType,
    this.subcategoryId,
    this.mainCategoryId,
    this.read,
    this.titleTranslationCode,
    this.bodyTranslationCode,
    this.path,
    this.payload,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.hasNextPage,
    this.nextPageNumber,
    this.userImageUrl,
  }) : super(
          id: id,
          receiverId: receiverInfo?.id,
          firstName: receiverInfo?.firstName,
          lastName: receiverInfo?.lastName,
          filterType: filterType,
          title: titleTranslationCode,
          body: bodyTranslationCode,
          payload: payload,
          path: path,
          createdAt: DateTime.fromMicrosecondsSinceEpoch(time ?? 0),
          hasNextPage: hasNextPage,
          nextPageNumber: nextPageNumber,
          read: read,
          userImageUrl: userImageUrl,
        );

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, receiverInfo: $receiverInfo, filterType: $filterType, subcategoryId: $subcategoryId, mainCategoryId: $mainCategoryId, read: $read, titleTranslationCode: $titleTranslationCode, bodyTranslationCode: $bodyTranslationCode, path: $path, metadata: $payload, time: $time, createdAt: $createdAt, updatedAt: $updatedAt, v: $v , hasNextPage: $hasNextPage , nextpageNumber: $nextPageNumber , userImageUrl: $userImageUrl )';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String?,
      userId: json['userId'] as dynamic,
      receiverInfo:
          json['receiverInfo'] == null ? null : ReceiverInfo.fromJson(json['receiverInfo'] as Map<String, dynamic>),
      filterType: json['filterType'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      mainCategoryId: json['mainCategoryId'] as String?,
      read: json['read'] as bool?,
      titleTranslationCode: json['titleTranslationCode'] as String?,
      bodyTranslationCode: json['bodyTranslationCode'] as String?,
      path: json['path'] as String?,
      payload: json['metadata'] == null ? null : json['metadata'] as Map<String, dynamic>,
      time: json['time'] as int?,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int?,
      userImageUrl: json['userInfo']?['image'] == null ? null : json['userInfo']?['image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'receiverInfo': receiverInfo?.toJson(),
        'filterType': filterType,
        'subcategoryId': subcategoryId,
        'mainCategoryId': mainCategoryId,
        'read': read,
        'titleTranslationCode': titleTranslationCode,
        'bodyTranslationCode': bodyTranslationCode,
        'path': path,
        'metadata': payload,
        'time': time,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };
}
