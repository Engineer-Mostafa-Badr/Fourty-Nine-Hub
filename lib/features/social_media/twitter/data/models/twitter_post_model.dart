// lib/features/social_media/twitter/data/models/twitter_post_model.dart
import 'twitter_main_post_model.dart';
import 'twitter_user_model.dart';
import '../../domain/entities/twitter_post_entity.dart';

class TwitterPostModel extends TwitterPostEntity {
  TwitterPostModel({
    required super.id,
    required super.content,
    super.postShare,
    required super.createdAt,
    super.commentsCount,
    super.images,
    super.love,
    super.shares,
    super.isShared,
    super.isReact,
    super.photo,
    required super.mainPost,
    super.loveCount,
    super.commentPrivacy,
    super.sharesCount,
    required super.user,
    required super.comments,
  });

  factory TwitterPostModel.fromJson(Map<String, dynamic> json) {
    final likesList   = (json['likes']  as List? ?? const []);
    final mediaList   = (json['media']  as List? ?? const []);
    final commentsRaw = (json['comments'] as List? ?? const []);

    return TwitterPostModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),

      // mainPost/postShare (guard type)
      postShare: json['mainPost'] is Map<String, dynamic>
          ? TwitterMainPostModel.fromJson(json['mainPost'] as Map<String, dynamic>)
          : null,
      mainPost: json['mainPost'] is Map<String, dynamic>
          ? TwitterMainPostModel.fromJson(json['mainPost'] as Map<String, dynamic>)
          : null,

      // media accepts either [{photo: ...}] or ["..."]
      images: mediaList.map((m) {
        if (m is Map && m['photo'] != null) return m['photo'].toString();
        return m.toString();
      }).toList(),

      shares: (json['shares'] as List? ?? const []).map((e) => e.toString()).toList(),

      // ✅ likes can be list of user maps OR list of user ids (strings)
      love: likesList.map((e) {
        if (e is Map<String, dynamic>) return TwitterUserModel.fromJson(e);
        if (e is String) return TwitterUserModel.fromJson({'_id': e});
        return TwitterUserModel.fromJson(const {}); // fallback
      }).toList(),

      isShared: json['isShared'] == true,
      isReact : json['isReact']  == true,
      photo   : (json['photo'] ?? '').toString(),

      // user can be map or string id
      user: () {
        final u = json['user'];
        if (u is Map<String, dynamic>) return TwitterUserModel.fromJson(u);
        if (u is String) return TwitterUserModel.fromJson({'_id': u});
        return TwitterUserModel.fromJson(const {});
      }(),

      commentPrivacy: json['commentPrivacy'],
      sharesCount   : (json['sharesCount']   ?? 0) as int,
      loveCount     : (json['loveCount']     ?? 0) as int,
      commentsCount : (json['commentsCount'] ?? 0) as int,
      createdAt     : DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
      comments      : commentsRaw.map((e) => e.toString()).toList(),
    );
  }

// lib/features/social_media/twitter/data/models/twitter_post_model.dart

  factory TwitterPostModel.fromThread(Map<String, dynamic> thread) {
    final owner = (thread['owner'] ?? const {}) as Map<String, dynamic>;
    final post  = (thread['post']  ?? const {}) as Map<String, dynamic>;

    // owner.image may not exist; backend gives profilePictureKey with a full URL
    final ownerImage = (owner['profilePictureKey'] ?? owner['image'])?.toString();

    final adapted = <String, dynamic>{
      // ids/content/timestamps from 'post'
      'id'       : post['id'] ?? post['_id'],
      'content'  : post['content'] ?? '',
      'createdAt': post['createdAt'] ?? thread['createdAt'],

      // counts
      'loveCount'    : post['likesCount']   ?? 0,
      'commentsCount': post['repliesCount'] ?? 0,
      'sharesCount'  : 0,

      // flags/collections
      'isShared': false,
      'isReact' : false,
      'likes'   : const <dynamic>[],
      'media'   : const <dynamic>[],
      'shares'  : const <dynamic>[],
      'comments': const <dynamic>[],
      'mainPost': null,

      // user mapped to your TwitterUserModel
      'user': {
        '_id'                   : owner['id'],
        'firstName'             : owner['firstName'],
        'lastName'              : owner['lastName'],
        'userName'              : owner['username'],
        'twitter_documentation' : owner['isAccountVerified'] ?? false,
        'image'                 : ownerImage, // <- full URL works with your avatar extension
        'USER_PROFILE': {
          'profilePictureKey': {'mediaKey': ownerImage},
        },
      },
    };

    return TwitterPostModel.fromJson(adapted);
  }
}
