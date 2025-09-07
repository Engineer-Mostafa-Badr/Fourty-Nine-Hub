// lib/features/star_feature/data/model/comment_model.dart
import '../../domain/entity/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.username,
    required super.profileImage,
    required super.content,
    required super.timeAgo,
    required super.likes,
    required super.isLiked,
    required super.createdAt,
    super.parentCommentId,
    super.isReply,
    super.dislikes,
    required this.userId,
    required this.videoId,
    required this.owner,
    this.replies = const [],
    super.isDisliked,
  });

  final String userId;
  final String videoId;
  final CommentOwnerModel owner;
  final List<CommentModel> replies;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      videoId: json['video'] ?? '',
      content: json['content'] ?? '',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      isLiked: false, // This should be determined by checking user's like status
      isDisliked: false, // This should be determined by checking user's dislike status
      owner: CommentOwnerModel.fromJson(json['owner'] ?? {}),
      replies: (json['replies'] as List?)
              ?.map((reply) => CommentModel.fromJson(reply))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      // Calculate timeAgo from createdAt
      timeAgo: _calculateTimeAgo(
          DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now()),
      // Map owner data to legacy fields for compatibility
      username: json['owner']?['channelName'] ?? '@Unknown',
      profileImage: json['owner']?['channelPicture']?['mediaKey'] ?? '',
      parentCommentId: json['parentCommentId'],
      isReply: json['parentCommentId'] != null,
    );
  }

  static String _calculateTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'Year' : 'Years'} Ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'Month' : 'Months'} Ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'Day' : 'Days'} Ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'Hour' : 'Hours'} Ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'Minute' : 'Minutes'} Ago';
    } else {
      return 'Just now';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'video': videoId,
      'content': content,
      'likes': likes,
      'dislikes': dislikes,
      'owner': owner.toJson(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': createdAt.toIso8601String(),
      'parentCommentId': parentCommentId,
    };
  }

  @override
  CommentModel copyWith({
    String? id,
    String? username,
    String? profileImage,
    String? content,
    String? timeAgo,
    int? likes,
    int? dislikes,
    bool? isLiked,
    bool? isDisliked,
    DateTime? createdAt,
    String? parentCommentId,
    bool? isReply,
    String? userId,
    String? videoId,
    CommentOwnerModel? owner,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      createdAt: createdAt ?? this.createdAt,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      isReply: isReply ?? this.isReply,
      userId: userId ?? this.userId,
      videoId: videoId ?? this.videoId,
      owner: owner ?? this.owner,
      replies: replies ?? this.replies,
    );
  }
}

class CommentOwnerModel {
  final String id;
  final String channelName;
  final CommentChannelPicture? channelPicture;

  CommentOwnerModel({
    required this.id,
    required this.channelName,
    this.channelPicture,
  });

  factory CommentOwnerModel.fromJson(Map<String, dynamic> json) {
    return CommentOwnerModel(
      id: json['_id'] ?? '',
      channelName: json['channelName'] ?? 'Unknown User',
      channelPicture: json['channelPicture'] != null
          ? CommentChannelPicture.fromJson(json['channelPicture'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'channelName': channelName,
      'channelPicture': channelPicture?.toJson(),
    };
  }
}

class CommentChannelPicture {
  final String id;
  final String mediaKey;

  CommentChannelPicture({
    required this.id,
    required this.mediaKey,
  });

  factory CommentChannelPicture.fromJson(Map<String, dynamic> json) {
    return CommentChannelPicture(
      id: json['_id'] ?? '',
      mediaKey: json['mediaKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}

// Response models for API responses
class CommentsListResponse {
  final List<CommentModel> comments;
  final CommentsPaginationModel pagination;

  CommentsListResponse({
    required this.comments,
    required this.pagination,
  });

  factory CommentsListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final dataMap = json['data'] as Map<String, dynamic>? ?? {};
      final commentsData = dataMap['comments'] as List? ?? [];
      final paginationData = dataMap['pagination'] as Map<String, dynamic>? ?? {};

      return CommentsListResponse(
        comments: commentsData
            .map((comment) => CommentModel.fromJson(comment))
            .toList(),
        pagination: CommentsPaginationModel.fromJson(paginationData),
      );
    } catch (e) {
      print('Error parsing CommentsListResponse: $e');
      return CommentsListResponse(
        comments: [],
        pagination: CommentsPaginationModel(
          page: 1,
          limit: 20,
          total: 0,
          pages: 0,
        ),
      );
    }
  }
}

class CommentsPaginationModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  CommentsPaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory CommentsPaginationModel.fromJson(Map<String, dynamic> json) {
    return CommentsPaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
    };
  }
}