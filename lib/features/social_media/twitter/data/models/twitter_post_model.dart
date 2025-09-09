import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_main_post_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

import '../../domain/entities/original_post_entity.dart';
import '../../domain/entities/twitter_post_entity.dart';

Map<String, dynamic> _toStringKeyedMap(dynamic v) {
  if (v is Map) {
    return v.map((k, val) => MapEntry(k.toString(), val));
  }
  return <String, dynamic>{};
}

int _asInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  if (v is List) return v.length; // sometimes counts arrive as lists
  return fallback;
}

bool _asBool(dynamic v, {bool fallback = false}) {
  if (v == null) return fallback;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase().trim();
    if (s == 'true' || s == '1' || s == 'yes') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;
  }
  return fallback;
}

String _asString(dynamic v, {String fallback = ''}) {
  if (v == null) return fallback;
  return v.toString();
}

DateTime _asDate(dynamic v, {DateTime? fallback}) {
  if (v == null) return fallback ?? DateTime.now();
  final s = v.toString();
  return DateTime.tryParse(s) ?? (fallback ?? DateTime.now());
}

List<T> _asListOf<T>(dynamic v) {
  if (v is List) return v.whereType<T>().toList();
  return const [];
}

String? _ownerAvatar(Map<String, dynamic> owner) {
  final pk = owner['profilePictureUrl'];
  if (pk is String && pk.trim().isNotEmpty) return pk.trim();
  if (pk is Map && pk['mediaKey'] is String && (pk['mediaKey'] as String).trim().isNotEmpty) {
    return (pk['mediaKey'] as String).trim();
  }
  final img = (owner['image'] ?? '').toString().trim();
  if (img.isNotEmpty) return img;
  return null;
}

String _normalizeImage(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '';
  final s = raw.trim();
  if (s.startsWith('http')) return s;
  return 'https://d3j5umpuujp1ej.cloudfront.net/$s';
}

/// ---------- ONE ADAPTER to carry ALL owner fields ----------
Map<String, dynamic> _adaptOwnerToUserJson(Map<String, dynamic> owner) {
  final o = _toStringKeyedMap(owner);
  final img = (o['profilePictureUrl'] ?? o['image'] ?? '').toString();

  return {
    // identity
    '_id'               : o['id'] ?? o['_id'] ?? o['userId'],
    'firstName'         : o['firstName'],
    'lastName'          : o['lastName'],
    'username'          : o['username'] ?? o['userName'],

    // extras you wanted preserved
    'gender'            : o['gender'],
    'profileViews'      : o['profileViews'],
    'joinedAt'          : o['joinedAt'] ?? o['createdAt'],

    // avatar
    'image'             : img,
    'profilePictureUrl' : img,

    // verification (both common keys)
    'verifiedBadge'     : o['isAccountVerified'] ?? false,
    'isAccountVerified' : o['isAccountVerified'] ?? false,

    // legacy nested shape your UI already reads in some places
    'USER_PROFILE': {
      'profilePictureUrl': {'mediaKey': img}
    },
  };
}

// ---------- MODEL ----------
class TwitterPostModel extends TwitterPostEntity {
  TwitterPostModel({
    required super.id,
    required super.isLiked,
    required super.content,
    required super.createdAt,
    required super.user,
    required super.mainPost,
    required super.comments,
    super.images,
    super.love,
    super.shares,
    super.isShared,
    super.isReact,
    super.photo,
    super.loveCount,
    super.repostCount,
    super.commentPrivacy,
    super.sharesCount,
    super.commentsCount,
    super.postShare,
    super.thread,
  });

  // Extra holders for full thread details
  late final List<TwitterPostModel> threadExtraPosts = <TwitterPostModel>[];
  late final List<TwitterPostCommentModel> threadExtraReplies = <TwitterPostCommentModel>[];

  TwitterPostModel attachThreadExtras({
    List<TwitterPostModel> posts = const [],
    List<TwitterPostCommentModel> replies = const [],
  }) {
    threadExtraPosts
      ..clear()
      ..addAll(posts);
    threadExtraReplies
      ..clear()
      ..addAll(replies);
    return this;
  }

  static TwitterPostCommentModel commentFromThreadReply(Map<String, dynamic> r) {
    final owner = _toStringKeyedMap(r['owner']);
    final post  = _toStringKeyedMap(r['post']);

    final adapted = <String, dynamic>{
      '_id'       : r['id'] ?? r['_id'],
      'user'      : {
        // keep minimal shape for comments; model can ignore extras
        ..._adaptOwnerToUserJson(owner),
      },
      'content'   : post['content'] ?? '',
      'post'      : post['id'] ?? post['_id'] ?? '',
      'loveCount' : 0,
      'repliesCount': 0,
      'repostsCount': 0,
      'createdAt' : post['createdAt'] ?? r['createdAt'],
      'love'      : const <String>[],
      'adminIgnore': false,
      'isReact'   : _asBool(post['youLiked']),
    };
    return TwitterPostCommentModel.fromJson(adapted);
  }

  static TwitterThreadDetail parseThreadDetail(Map<String, dynamic> root) {
    final thread = _toStringKeyedMap(root['data']?['thread']);
    final owner  = _toStringKeyedMap(thread['owner']);

    final meta = TwitterThreadEntity(
      id       : _asString(thread['id'] ?? thread['_id']),
      createdAt: _asDate(thread['createdAt']),
      updatedAt: _asDate(thread['updatedAt'] ?? thread['createdAt']),
      owner    : _ownerToUserModel(owner),
    );

    final postsList = (thread['posts'] as List? ?? const [])
        .whereType<Map>()
        .map((p) => TwitterPostModel.fromOwnerAndPost(owner, _toStringKeyedMap(p), thread))
        .toList()
      ..sort((a, b) {
        final pa = _asInt((_toStringKeyedMap(a.mainPost ?? const {})['position']) ?? (_toStringKeyedMap(a as dynamic)['position']));
        final pb = _asInt((_toStringKeyedMap(b.mainPost ?? const {})['position']) ?? (_toStringKeyedMap(b as dynamic)['position']));
        return pa.compareTo(pb);
      });

    final replies = (thread['replies'] as List? ?? const [])
        .whereType<Map>()
        .map((r) => commentFromThreadReply(_toStringKeyedMap(r)))
        .toList();

    return TwitterThreadDetail(meta: meta, posts: postsList, replies: replies);
  }

  static TwitterUserModel _ownerToUserModel(Map<String, dynamic> owner) {
    return TwitterUserModel.fromJson(_adaptOwnerToUserJson(owner));
  }

  factory TwitterPostModel.fromJson(Map<String, dynamic> json) {
    final likesList   = _asListOf<dynamic>(json['likes']);
    final mediaList   = _asListOf<dynamic>(json['media']);
    final commentsRaw = _asListOf<dynamic>(json['comments']);

    final dynamic rawUser = json['user'];
    final TwitterUserModel userModel = () {
      if (rawUser is Map<String, dynamic>) return TwitterUserModel.fromJson(_adaptOwnerToUserJson(rawUser));
      if (rawUser is String) return TwitterUserModel.fromJson({'_id': rawUser});
      return TwitterUserModel.fromJson(const {});
    }();

    final mainPost = (json['mainPost'] is Map<String, dynamic>)
        ? TwitterMainPostModel.fromJson(json['mainPost'] as Map<String, dynamic>)
        : null;

    // optional thread payload on each post
    TwitterThreadEntity? threadMeta;
    final threadJson = json['thread'];
    if (threadJson is Map<String, dynamic>) {
      final ownerMap = _toStringKeyedMap(threadJson['owner']);
      threadMeta = TwitterThreadEntity(
        id: _asString(threadJson['threadId'] ?? threadJson['_id']),
        createdAt: _asDate(threadJson['createdAt']),
        updatedAt: _asDate(threadJson['updatedAt'] ?? threadJson['createdAt']),
        owner: _ownerToUserModel(ownerMap),
      );
    }

    return TwitterPostModel(
      id        : _asString(json['_id'] ?? json['id']),
      content   : _asString(json['content'] ?? json['text'] ?? ''),
      createdAt : _asDate(json['createdAt']),
      isLiked   : _asBool(json['youLiked']),
      user      : userModel,
      mainPost  : mainPost,
      postShare : mainPost, // kept for back-compat
      images    : mediaList.map((m) {
        if (m is Map && m['photo'] != null) return _normalizeImage(_asString(m['photo']));
        return _normalizeImage(_asString(m));
      }).where((s) => s.isNotEmpty).toList(),
      shares    : _asListOf<dynamic>(json['shares']).map(_asString).toList(),
      love      : likesList.map((e) {
        if (e is Map<String, dynamic>) return TwitterUserModel.fromJson(_adaptOwnerToUserJson(e));
        if (e is String) return TwitterUserModel.fromJson({'_id': e});
        return TwitterUserModel.fromJson(const {});
      }).toList(),
      isShared      : _asBool(json['isShared']),
      isReact       : _asBool(json['isReact']),
      photo         : _asString(json['photo']),
      sharesCount   : _asInt(json['sharesCount']   ?? json['shares']),
      loveCount     : _asInt(json['loveCount']     ?? json['likesCount'] ?? json['likes'] ?? json['love']),
      repostCount     : _asInt(json['repostsCount']     ?? json['repostsCount'] ?? json['repostsCount'] ?? json['repostsCount']),
      commentsCount : _asInt(json['commentsCount'] ?? json['repliesCount'] ?? json['comments']),
      comments      : commentsRaw.map(_asString).toList(),
      thread        : threadMeta,
    );
  }

  /// (owner + post) → TwitterPostModel
  factory TwitterPostModel.fromOwnerAndPost(
      Map<String, dynamic> owner,
      Map<String, dynamic> post,
      Map<String, dynamic> thread,
      ) {
    final ownerImg = _ownerAvatar(owner);

    final threadBlock = {
      'threadId' : thread['threadId'] ?? thread['_id'],
      'createdAt': thread['createdAt'],
      'updatedAt': thread['updatedAt'] ?? thread['createdAt'],
      'owner'    : owner,
    };

    final mediaList = (post['media'] is List) ? List.from(post['media']) : const [];

    final adapted = <String, dynamic>{
      '_id'        : post['id'] ?? post['_id'],
      'content'    : post['content'] ?? post['text'] ?? '',
      'youLiked'   : post['youLiked'] ?? false,
      'createdAt'  : post['createdAt'] ?? thread['createdAt'],

      'loveCount'      : post['likesCount'] ?? post['likes'] ?? 0,
      'repostsCount'      : post['repostsCount'] ?? post['repostsCount'] ?? 0,
      'commentsCount'  : post['repliesCount'] ?? 0,
      'sharesCount'    : 0,

      'isShared'   : false,
      'isReact'    : false,

      'media'      : mediaList,

      'likes'      : const <dynamic>[],
      'shares'     : const <dynamic>[],
      'comments'   : const <dynamic>[],
      'mainPost'   : null,

      // IMPORTANT: pass FULL owner fields via adapter
      'user'       : _adaptOwnerToUserJson(owner),

      'thread': threadBlock,
    };

    return TwitterPostModel.fromJson(adapted);
  }

  /// Convert *any* user-like map to TwitterUserModel using adapter
  static TwitterUserModel _userFromAny(Map<String, dynamic> m) {
    return TwitterUserModel.fromJson(_adaptOwnerToUserJson(m));
  }

  /// Build a minimal TwitterPostModel from an originalPost block
  static TwitterPostModel _postFromOriginal(Map<String, dynamic> original) {
    final owner = _toStringKeyedMap(original['owner']);
    final media = _asListOf<dynamic>(original['media']);

    return TwitterPostModel(
      id        : _asString(original['postId'] ?? original['_id']),
      content   : _asString(original['content'] ?? ''),
      createdAt : _asDate(original['createdAt']),
      isLiked   : _asBool(original['youLiked']),
      user      : _userFromAny(owner),        // ORIGINAL owner
      mainPost  : null,
      comments  : const [],
      images    : media.map((m) => _normalizeImage(_asString(m))).toList(),
      love      : const [],
      shares    : const [],
      isShared  : false,
      isReact   : false,
      sharesCount   : 0,
      loveCount     : _asInt(original['likesCount']),
      repostCount     : _asInt(original['repostsCount']),
      commentsCount : _asInt(original['repliesCount']),
      thread        : null,
    );
  }

  /// Parse a repost thread with originalPost + post + owner
  static TwitterPostModel fromRepostThread(Map<String, dynamic> thread) {
    final reposter = _toStringKeyedMap(thread['owner']);         // who reposted
    final original = _toStringKeyedMap(thread['originalPost']);  // original content
    final stubPost = _toStringKeyedMap(thread['post']);          // the repost row

    final originalEntity = _postFromOriginal(original);

    final model = TwitterPostModel(
      id        : _asString(stubPost['id'] ?? stubPost['_id'] ?? thread['threadId'] ?? thread['_id']),
      content   : _asString(stubPost['content'] ?? ''), // usually null
      createdAt : _asDate(stubPost['createdAt'] ?? thread['createdAt']),
      isLiked   : _asBool(stubPost['youLiked']),
      user      : _userFromAny(reposter),               // REP O S T E R
      mainPost  : originalEntity,                       // show original inside the card
      comments  : const [],
      images    : const [],
      love      : const [],
      shares    : const [],
      isShared  : true,
      isReact   : false,
      sharesCount   : 0,
      repostCount     : _asInt(stubPost['repostsCount']),
      loveCount     : _asInt(stubPost['likesCount']),
      commentsCount : _asInt(stubPost['repliesCount']),
      thread        : TwitterThreadEntity(
        id       : _asString(thread['threadId'] ?? thread['_id']),
        createdAt: _asDate(thread['createdAt']),
        updatedAt: _asDate(thread['updatedAt'] ?? thread['createdAt']),
        owner    : _userFromAny(reposter),
      ),
    );

    model.repostCount = _asInt(thread['repostsCount']);
    model.isReposted  = false;
    return model;
  }

  /// Detects *all* known thread shapes and returns flat posts
  static List<TwitterPostModel> listFromThread(dynamic threadDyn) {
    final t = _toStringKeyedMap(threadDyn);

    // A) New repost (owner + originalPost + post)
    if (t.containsKey('originalPost') && t.containsKey('post') && t.containsKey('owner')) {
      return [TwitterPostModel.fromRepostThread(t)];
    }

    // B) Repost variant where "post" is *not* nested (my-threads shape):
    //    {
    //      "thread": {...},
    //      "id": "<postId>", "content": null, "media": [], "createdAt": "...",
    //      "likesCount": 0, "repliesCount": 0, "youLiked": false,
    //      "originalPost": {...}, "owner": {...}
    //    }
    if (t.containsKey('originalPost') && !t.containsKey('post') && (t.containsKey('id') || t.containsKey('_id'))) {
      final stubPost = {
        'id'         : t['id'] ?? t['_id'],
        'content'    : t['content'],
        'media'      : t['media'] ?? const [],
        'likesCount' : t['likesCount'],
        'repostsCount' : t['repostsCount'],
        'repliesCount': t['repliesCount'],
        'youLiked'   : t['youLiked'],
        'createdAt'  : t['createdAt'],
      };
      final rebuilt = {
        ...t,
        'post': stubPost,
        // try to lift "thread" fields up for fromRepostThread()
        'threadId'  : (t['thread'] is Map) ? (_toStringKeyedMap(t['thread'])['id'] ?? _toStringKeyedMap(t['thread'])['_id']) : t['threadId'],
        'createdAt' : t['createdAt'] ?? (t['thread'] is Map ? _toStringKeyedMap(t['thread'])['createdAt'] : null),
        'updatedAt' : t['updatedAt'] ?? (t['thread'] is Map ? _toStringKeyedMap(t['thread'])['updatedAt'] : null),
      };
      return [TwitterPostModel.fromRepostThread(rebuilt)];
    }

    // C) Legacy shapes: thread owner + posts[]
    final owner  = _toStringKeyedMap(t['owner']);
    final posts  = t['posts'];

    if (posts is List) {
      return posts
          .whereType<Map>()
          .map((p) => TwitterPostModel.fromOwnerAndPost(owner, _toStringKeyedMap(p), t))
          .toList();
    }

    // D) Single post
    final post = _toStringKeyedMap(t['post']);
    if (post.isNotEmpty) {
      return [TwitterPostModel.fromOwnerAndPost(owner, post, t)];
    }

    return const [];
  }

  /// Full `/twitter/threads` payload → flat list of posts
  static List<TwitterPostModel> listFromThreadsResponse(dynamic dataDyn) {
    final data     = _toStringKeyedMap(dataDyn);
    final wrapped  = _toStringKeyedMap(data['data']);
    final threads  = wrapped['threads'];
    if (threads is! List) {
      return [
        TwitterPostModel(
          id: 'dummy-id',
          content: '',
          createdAt: DateTime.now(),
          user: TwitterUserModel.fromJson({}),
          mainPost: null,
          comments: const [],
          isLiked:  false,
        )
      ];
    }

    final all = threads.expand(listFromThread).toList();

    if (all.isEmpty) {
      return [
        TwitterPostModel(
          id: 'dummy-id',
          content: '123456fals',
          createdAt: DateTime.now(),
          user: TwitterUserModel.fromJson({}),
          mainPost: null,
          comments: const [],
          isLiked:  false,
        )
      ];
    }
    return all;
  }

  static TwitterOriginalPost? _parseOriginalPost(dynamic v) {
    if (v is! Map) return null;
    final m  = _toStringKeyedMap(v);
    final ow = _toStringKeyedMap(m['owner']);

    final owner = TwitterUserModel.fromJson(_adaptOwnerToUserJson(ow));

    final media = _asListOf<dynamic>(m['media'])
        .map((e) => _normalizeImage(_asString(e)))
        .where((s) => s.isNotEmpty)
        .toList();

    return TwitterOriginalPost(
      postId      : _asString(m['postId']),
      content     : _asString(m['content']),
      media       : media,
      repostCount  : _asInt(m['repostsCount']),
      likesCount  : _asInt(m['likesCount']),
      repliesCount: _asInt(m['repliesCount']),
      youLiked    : _asBool(m['youLiked']),
      owner       : owner,
    );
  }
}
