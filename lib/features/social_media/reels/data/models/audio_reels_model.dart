import 'new_reels_model.dart';

class ReelsForAudioResponse {
  final bool? status;
  final String? message;
  final ReelsData? data;

  ReelsForAudioResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ReelsForAudioResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ReelsForAudioResponse();
    return ReelsForAudioResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? ReelsData.fromJson(json['data']) : null,
    );
  }


}

class ReelsData {
  final List<Reel>? reels;
  final Pagination? pagination;

  ReelsData({
    this.reels,
    this.pagination,
  });

  factory ReelsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ReelsData();
    return ReelsData(
      reels: (json['reels'] as List<dynamic>?)
          ?.map((e) => Reel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

}

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final bool? isFriend;
  final String? privacy;
  final bool? story;
  final bool? verified;
  final String? profilePictureSignedUrl;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.isFriend,
    this.privacy,
    this.story,
    this.verified,
    this.profilePictureSignedUrl,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User();
    return User(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      isFriend: json['isFriend'] as bool?,
      privacy: json['privacy'] as String?,
      story: json['story'] as bool?,
      verified: json['verified'] as bool?,
      profilePictureSignedUrl: json['profilePictureSignedUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'isFriend': isFriend,
      'privacy': privacy,
      'story': story,
      'verified': verified,
      'profilePictureSignedUrl': profilePictureSignedUrl,
    }..removeWhere((key, value) => value == null);
  }
}

class Pagination {
  final int? countItem;
  final int? pageCount;
  final int? currentPage;

  Pagination({
    this.countItem,
    this.pageCount,
    this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Pagination();
    return Pagination(
      countItem: json['countItem'] as int?,
      pageCount: json['pageCount'] as int?,
      currentPage: json['currentPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countItem': countItem,
      'pageCount': pageCount,
      'currentPage': currentPage,
    }..removeWhere((key, value) => value == null);
  }
}
