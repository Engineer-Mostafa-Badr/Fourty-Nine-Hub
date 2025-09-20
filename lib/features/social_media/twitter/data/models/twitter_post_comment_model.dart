import 'twitter_user_model.dart';
import '../../domain/entities/twitter_post_comment_entity.dart';

class TwitterPostCommentModel extends TwitterPostCommentEntity {
  TwitterPostCommentModel({
    required super.id,
    required super.user,
    required super.content,
    required super.post,
    required super.createdAt,
    super.loveCount,
    super.repliesCount,
    super.showReplies,
    super.addReply,
    required super.adminIgnore,
    required super.love,
    required super.isReact,
    super.replies,
    super.edit,
  });

  static String _asString(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    return v.toString();
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static bool _asBool(dynamic v, {bool fallback = false}) {
    if (v == null) return fallback;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return fallback;
  }

  static DateTime _asDate(dynamic v) {
    if (v == null) return DateTime.now();
    final s = v.toString();
    return DateTime.tryParse(s) ?? DateTime.now();
  }

  factory TwitterPostCommentModel.fromJson(Map<String, dynamic> json) {
    // Detect if this is a reply shape
    final bool isReplyShape = json.containsKey('owner') && json.containsKey('post');

    if (isReplyShape) {
      final owner = (json['owner'] as Map?)?.cast<String, dynamic>() ?? const {};
      final post  = (json['post']  as Map?)?.cast<String, dynamic>() ?? const {};

      // Build a userMap compatible with TwitterUserModel
      final userMap = <String, dynamic>{
        '_id': owner['userId']?.toString(),
        'firstName': owner['firstName'] ?? '',
        'lastName': owner['lastName'] ?? '',
        'username': owner['username'] ?? '',
        'image': owner['profilePictureUrl'] ?? '',
        'twitter_documentation': owner['isAccountVerified'] ?? false,
        'USER_PROFILE': {
          'profilePictureKey': {'mediaKey': owner['profilePictureUrl'] ?? ''},
        },
      };

      final model = TwitterPostCommentModel(
        id          : _asString(json['id'] ?? json['_id']),
        user        : TwitterUserModel.fromJson(userMap),
        content     : _asString(post['content']),
        post        : _asString(post['id'] ?? json['postId'] ?? ''),
        createdAt   : _asDate(post['createdAt'] ?? json['createdAt']),
        loveCount   : _asInt(post['likes']),
        repliesCount: 0,
        love        : const <String>[],
        adminIgnore : false,
        isReact     : _asBool(post['youLiked']),
      );

      // ✅ Attach extra data for later access
      model.ownerData = TwitterUserModel.fromJson(owner);
      model.postData  = post;

      return model;
    }

    // fallback: normal comment shape
    final dynamic userDyn = json['user'];
    final user = (userDyn is String)
        ? userDyn
        : TwitterUserModel.fromJson((userDyn as Map?)?.cast<String, dynamic>() ?? const {});

    return TwitterPostCommentModel(
      id          : _asString(json['_id'] ?? json['id']),
      user        : user,
      content     : _asString(json['content']),
      post        : json['post'] is String ? _asString(json['post']) : _asString(json['post']?['_id']),
      createdAt   : _asDate(json['createdAt']),
      loveCount   : _asInt(json['loveCount'] ?? json['likes']),
      repliesCount: _asInt(json['repliesCount']),
      love        : (json['love'] is List) ? List<String>.from(json['love']) : const <String>[],
      adminIgnore : _asBool(json['adminIgnore']),
      isReact     : _asBool(json['isReact']),
    );
  }
}
