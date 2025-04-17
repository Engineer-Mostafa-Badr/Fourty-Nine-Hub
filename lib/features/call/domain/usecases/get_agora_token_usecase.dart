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
  const GetAgoraTokenParams();

  Map<String, dynamic> toMap() => {
        'type': 'publisher',
      };

  @override
  List<Object?> get props => [];
}
