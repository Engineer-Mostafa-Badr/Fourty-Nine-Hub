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
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => CommentData.fromJson(item))
          .toList(),
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
  final String? parentId; // Nullable
  final ReceiverComment? receiverComment; // Nullable
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  final bool isLiked;
  final User user;
  final List<CommentData> replies;

  CommentData({
    required this.id,
    required this.reelId,
    required this.comment,
    this.parentId, // Nullable
    this.receiverComment, // Nullable
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.isLiked,
    required this.user,
    required this.replies,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json['_id'],
      reelId: json['reelId'],
      comment: json['comment'],
      parentId: json['parentId'], // Nullable
      receiverComment: json['receiverComment'] != null
          ? ReceiverComment.fromJson(json['receiverComment'])
          : null, // Nullable
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      user: User.fromJson(json['user']),
      replies: (json['replies'] as List<dynamic>)
          .map((item) => CommentData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reelId': reelId,
      'comment': comment,
      'parentId': parentId, // Nullable
      'receiverComment': receiverComment?.toJson(), // Nullable
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
  final String? id; // Nullable

  ReceiverComment({
    required this.firstName,
    required this.lastName,
    this.id, // Nullable
  });

  factory ReceiverComment.fromJson(Map<String, dynamic> json) {
    return ReceiverComment(
      firstName: json['firstName'],
      lastName: json['lastName'],
      id: json['id'], // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'id': id, // Nullable
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
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePictureSignedUrl: json['profilePictureSignedUrl'],
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
