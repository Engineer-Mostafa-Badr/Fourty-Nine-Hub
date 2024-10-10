import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/members_entity.dart';

class MembersModel extends MembersEntity {
  const MembersModel(super.id, super.name, super.points);

  //fromJson

  factory MembersModel.fromJson(Map<String, dynamic> json) {
    return MembersModel(
      json['userDetails']['_id'],
      '${json['userDetails']['firstName']} ${json['userDetails']['lastName']}',
      json['points'],
    );
  }
}
