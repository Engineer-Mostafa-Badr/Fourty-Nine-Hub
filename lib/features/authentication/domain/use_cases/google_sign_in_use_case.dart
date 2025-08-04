import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/utils/fcm.dart';

// class GoogleSignInUseCase extends UseCase<UserTokensEntity, NoParams> {
//   final AuthRepository _repository;

//   GoogleSignInUseCase(this._repository);

//   @override
//   Future<Either<Failure, UserTokensEntity>> call(NoParams params) {
//     return _repository.signInWithGoogle();
//   }
// }

// class SocialLoginParams extends Equatable {
//   final String idToken;

//   const SocialLoginParams(this.idToken);

//   Future<Map<String, dynamic>> toJson() async => {
//         'idToken': idToken,
//         'fcm': await getFcmToken(),
//         // 'deviceId': await getDeviceId(),
//       };

//   @override
//   List<Object?> get props => [idToken];
// }

class GoogleSignInUseCase extends UseCase<UserTokensEntity, NoParams> {
  final AuthRepository _repository;

  GoogleSignInUseCase(this._repository);

  @override
  Future<Either<Failure, UserTokensEntity>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}


class SocialLoginParams extends Equatable {
  final String idToken;
  final String fcmToken;
  final String deviceId;

  const SocialLoginParams({
    required this.idToken,
    required this.fcmToken,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        'idToken': idToken,
        'fcm': fcmToken,
        'deviceId': deviceId,
      };

  @override
  List<Object?> get props => [idToken, fcmToken, deviceId];
}