class NotificationModel {
  final bool? status;
  final String? message;
  final NotificationData? data;

  NotificationModel({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null ? NotificationData.fromJson(json['data']) : null,
    );
  }
}

class NotificationData {
  final List<NotificationDoc>? docs;
  final int? totalDocs;
  final int? limit;
  final int? totalPages;
  final int? page;
  final int? pagingCounter;
  final bool? hasPrevPage;
  final bool? hasNextPage;
  final int? prevPage;
  final int? nextPage;

  NotificationData({
    this.docs,
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      docs: json['docs'] != null
          ? (json['docs'] as List)
              .map((doc) => NotificationDoc.fromJson(doc))
              .toList()
          : null,
      totalDocs: json['totalDocs'] as int?,
      limit: json['limit'] as int?,
      totalPages: json['totalPages'] as int?,
      page: json['page'] as int?,
      pagingCounter: json['pagingCounter'] as int?,
      hasPrevPage: json['hasPrevPage'] as bool?,
      hasNextPage: json['hasNextPage'] as bool?,
      prevPage: json['prevPage'] as int?,
      nextPage: json['nextPage'] as int?,
    );
  }
}

class NotificationDoc {
  final String? id;
  final String? userId;
  final ReceiverId? receiverId;
  final String? filterType;
  final String? subcategoryId;
  final String? mainCategoryId;
  final bool? read;
  final String? itemId;
  final String? titleTranslationCode;
  final String? bodyTranslationCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  NotificationDoc({
    this.id,
    this.userId,
    this.receiverId,
    this.filterType,
    this.subcategoryId,
    this.mainCategoryId,
    this.read,
    this.itemId,
    this.titleTranslationCode,
    this.bodyTranslationCode,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationDoc.fromJson(Map<String, dynamic> json) {
    return NotificationDoc(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      receiverId: json['receiverId'] != null
          ? ReceiverId.fromJson(json['receiverId'])
          : null,
      filterType: json['filterType'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      mainCategoryId: json['mainCategoryId'] as String?,
      read: json['read'] as bool?,
      itemId: json['itemId'] as String?,
      titleTranslationCode: json['titleTranslationCode'] as String?,
      bodyTranslationCode: json['bodyTranslationCode'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }
}

class ReceiverId {
  final String? id;
  final String? firstName;
  final String? lastName;

  ReceiverId({
    this.id,
    this.firstName,
    this.lastName,
  });

  factory ReceiverId.fromJson(Map<String, dynamic> json) {
    return ReceiverId(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }
}
