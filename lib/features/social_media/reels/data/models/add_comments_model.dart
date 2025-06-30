import 'package:fourtyninehub/features/social_media/reels/data/models/receiver_comment_model.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reciever_comment_entity.dart';

class AddCommentResponse {
  final bool status;
  final String message;
  final AddCommentData data;

  AddCommentResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  AddCommentResponse copyWith({
    bool? status,
    String? message,
    AddCommentData? data,
  }) {
    return AddCommentResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) {
    return AddCommentResponse(
      status: json['status'],
      message: json['message'],
      data: AddCommentData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AddCommentData {
  final String reelId;
  final String id;
  final String comment;
  final UserComment user;
  final String? parentId; // Nullable field
  final ReceiverCommentEntity? receiverComment; // Nullable field
  final DateTime createdAt;
  final DateTime updatedAt;

  AddCommentData({
    required this.reelId,
    required this.id,
    required this.comment,
    required this.user,
    this.parentId, // Optional field, can be null
    this.receiverComment, // Optional field, can be null
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddCommentData.fromJson(Map<String, dynamic> json) {
    return AddCommentData(
      reelId: json['reelId'],
      id: json['_id'],
      comment: json['comment'],
      user: UserComment.fromJson(json['user']),
      parentId: json['parentId'],
      // Accepts null
      receiverComment: json['receiverComment'] == null
          ? null
          : ReceiverCommentModel.fromJson(json['receiverComment']),
      // Accepts null
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reelId': reelId,
      '_id': id,
      'comment': comment,
      'user': user.toJson(),
      'parentId': parentId, // Can be null
      'receiverComment': receiverComment, // Can be null
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UserComment {
  final String id;
  final String firstName;
  final String lastName;
  final String profilePictureSignedUrl;

  UserComment({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePictureSignedUrl,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) {
    return UserComment(
      id: json['_id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePictureSignedUrl: json['profilePictureSignedUrl'] ?? '', 
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
