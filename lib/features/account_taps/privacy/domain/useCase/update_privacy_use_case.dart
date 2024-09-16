import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

class UpdatePrivacyUseCase extends UseCase<PrivacyEntity, UpdatePrivacyParams> {
 final PrivacyRepository _privacyRepository;

  UpdatePrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, PrivacyEntity>> call(UpdatePrivacyParams params) async{
    return await _privacyRepository.updateDataPrivacy(params);
  }
}

class UpdatePrivacyParams {
  final String? privacyCountry;
  final String? privacyPhone;
  final String? privacyEmail;
  final String? privacyBirthDay;
  final String? privacySocialStatus;
  final String? privacyJob;
  final String? privacyCity;
  final String? privacyIsMale;
  final String? privacyLanguage;
  final String? privacyReceiveMessages;
  final String? privacyLastSeen;
  final String? privacyFriendList;
  final String? privacyFollowerList;
  final String? privacyActivity;
  final String? privacyCall;
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
    'privacyCountry': privacyCountry,
    'privacyPhone': privacyPhone,
    'privacyEmail': privacyEmail,
    'privacyBirthDay': privacyBirthDay,
    'privacySocialStatus': privacySocialStatus,
    'privacyJob': privacyJob,
    'privacyCity': privacyCity,
    'privacyIsMale': privacyIsMale,
    'privacyLanguage': privacyLanguage,
    'privacyReceiveMessages': privacyReceiveMessages,
    'privacyLastSeen': privacyLastSeen,
    'privacyFriendList': privacyFriendList,
    'privacyFollowerList': privacyFollowerList,
    'privacyActivity': privacyActivity,
    'privacyCall': privacyCall,
    'privacyFriendRequest': privacyFriendRequest,
    'privacyFollowRequest': privacyFollowRequest,
  };
}
