import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/privacy_status_enum.dart';

class UpdatePrivacyUseCase extends UseCase<PrivacyEntity, UpdatePrivacyParams> {
 final PrivacyRepository _privacyRepository;

  UpdatePrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, PrivacyEntity>> call(UpdatePrivacyParams params) async{
    return await _privacyRepository.updateDataPrivacy(params);
  }
}

class UpdatePrivacyParams {
  final PrivacyStatus? privacyCountry;
  final PrivacyStatus? privacyPhone;
  final PrivacyStatus? privacyEmail;
  final PrivacyStatus? privacyBirthDay;
  final PrivacyStatus? privacySocialStatus;
  final PrivacyStatus? privacyJob;
  final PrivacyStatus? privacyCity;
  final PrivacyStatus? privacyIsMale;
  final PrivacyStatus? privacyLanguage;
  final PrivacyStatus? privacyReceiveMessages;
  final PrivacyStatus? privacyLastSeen;
  final PrivacyStatus? privacyFriendList;
  final PrivacyStatus? privacyFollowerList;
  final PrivacyStatus? privacyActivity;
  final PrivacyStatus? privacyCall;
  final bool? privacyFriendRequest;
  final bool? privacyFollowRequest;

  UpdatePrivacyParams(
      { this.privacyCountry,
       this.privacyPhone,
       this.privacyEmail,
       this.privacyBirthDay,
       this.privacySocialStatus,
       this.privacyJob,
       this.privacyCity,
       this.privacyIsMale,
       this.privacyLanguage,
       this.privacyReceiveMessages,
       this.privacyLastSeen,
       this.privacyFriendList,
       this.privacyFollowerList,
       this.privacyActivity,
       this.privacyCall,
       this.privacyFriendRequest,
       this.privacyFollowRequest});


  Map<String, dynamic> toJson() => {
    'privacyCountry': privacyCountry?.name,  // Serialize the enum as a string
    'privacyPhone': privacyPhone?.name,
    'privacyEmail': privacyEmail?.name,
    'privacyBirthDay': privacyBirthDay?.name,
    'privacySocialStatus': privacySocialStatus?.name,
    'privacyJob': privacyJob?.name,
    'privacyCity': privacyCity?.name,
    'privacyIsMale': privacyIsMale?.name,
    'privacyLanguage': privacyLanguage?.name,
    'privacyReceiveMessages': privacyReceiveMessages?.name,
    'privacyLastSeen': privacyLastSeen?.name,
    'privacyFriendList': privacyFriendList?.name,
    'privacyFollowerList': privacyFollowerList?.name,
    'privacyActivity': privacyActivity?.name,
    'privacyCall': privacyCall?.name,
    'privacyFriendRequest': privacyFriendRequest,  // Booleans don't need conversion
    'privacyFollowRequest': privacyFollowRequest,
  };

}
