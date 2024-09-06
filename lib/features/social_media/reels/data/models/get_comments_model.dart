class GetCommentsResponse {
  final bool status;
  final String message;
  final List<CommentData> data;

  GetCommentsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetCommentsResponse.fromJson(Map<String, dynamic> json) {
    return GetCommentsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map(
                  (item) => CommentData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class CommentData {
  final String id;
  final String reelId;
  final String comment;
  final String? parentId;
  final ReceiverComment? receiverComment;
  final DateTime createdAt;
  final DateTime updatedAt;
  int likeCount;
  bool isLiked;
  final User user;
  final List<CommentData> replies;

  CommentData({
    required this.id,
    required this.reelId,
    required this.comment,
    this.parentId,
    this.receiverComment,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.isLiked,
    required this.user,
    required this.replies,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json['_id'] as String? ?? '',
      reelId: json['reelId'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      parentId: json['parentId'] as String?,
      receiverComment: json['receiverComment'] != null
          ? ReceiverComment.fromJson(
              json['receiverComment'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      likeCount: json['likeCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      replies: (json['replies'] as List<dynamic>?)
              ?.map(
                  (item) => CommentData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reelId': reelId,
      'comment': comment,
      'parentId': parentId,
      'receiverComment': receiverComment?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likeCount': likeCount,
      'isLiked': isLiked,
      'user': user.toJson(),
      'replies': replies.map((item) => item.toJson()).toList(),
    };
  }
}

class ReceiverComment {
  final String firstName;
  final String lastName;
  final String? id;

  ReceiverComment({
    required this.firstName,
    required this.lastName,
    this.id,
  });

  factory ReceiverComment.fromJson(Map<String, dynamic> json) {
    return ReceiverComment(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'id': id,
    };
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String profilePictureSignedUrl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePictureSignedUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      profilePictureSignedUrl: json['profilePictureSignedUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePictureSignedUrl': profilePictureSignedUrl,
    };
  }
}
