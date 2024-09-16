import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';

class PrivacyModel extends PrivacyEntity {
  PrivacyModel(
      {required super.id,
      required super.userId,
      required super.privacyCountry,
      required super.privacyPhone,
      required super.privacyEmail,
      required super.privacyBirthDay,
      required super.privacySocialStatus,
      required super.privacyJob,
      required super.privacyCity,
      required super.privacyIsMale,
      required super.privacyLanguage,
      required super.privacyReceiveMessages,
      required super.privacyLastSeen,
      required super.privacyFriendList,
      required super.privacyFollowerList,
      required super.privacyActivity,
      required super.privacyCall,
      required super.privacyFriendRequest,
      required super.privacyFollowRequest,
      required super.createdAt,
      required super.updatedAt,
      required super.usersStoryPrivacy,
      required super.privacyStories});

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
      return PrivacyModel(
          id: json['_id'],
          userId: json['userId'],
          privacyCountry: json['privacyCountry'],
          privacyPhone: json['privacyPhone'],
          privacyEmail: json['privacyEmail'],
          privacyBirthDay: json['privacyBirthDay'],
          privacySocialStatus: json['privacySocialStatus'],
          privacyJob: json['privacyJob'],
          privacyCity: json['privacyCity'],
          privacyIsMale: json['privacyIsMale'],
          privacyLanguage: json['privacyLanguage'],
          privacyReceiveMessages: json['privacyReceiveMessages'],
          privacyLastSeen: json['privacyLastSeen'],
          privacyFriendList: json['privacyFriendList'],
          privacyFollowerList: json['privacyFollowerList'],
          privacyActivity: json['privacyActivity'],
          privacyCall: json['privacyCall'],
          privacyFriendRequest: json['privacyFriendRequest'],
          privacyFollowRequest: json['privacyFollowRequest'],
          createdAt: json['createdAt'],
          updatedAt: json['updatedAt'],
          usersStoryPrivacy: json['usersStoryPrivacy'] ?? [],
          privacyStories: json['privacyStories'],
      );
  }
}
