import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/call/domain/entities/agora_info_entity.dart';
import 'package:fourtyninehub/features/call/domain/repositories/call_repository.dart';

class GetAgoraTokenUsecase {
  final CallRepository _callRepository;

  GetAgoraTokenUsecase(this._callRepository);

  Future<Either<Exception, AgoraInfoEntity>> call(GetAgoraTokenParams params) =>
      _callRepository.getAgoraToken(params);
}

class GetAgoraTokenParams extends Equatable {
  final int expirationTime;
  final String caseId;

  const GetAgoraTokenParams(
      {required this.expirationTime, required this.caseId});

  Map<String, dynamic> toMap() => {
        'callId': caseId,
        'expirationTime': expirationTime,
        'type': 'publisher',
      };

  @override
  List<Object?> get props => [expirationTime, caseId];
}
