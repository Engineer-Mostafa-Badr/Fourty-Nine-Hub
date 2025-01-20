import 'package:either_dart/either.dart';
import 'package:fourtyninehub/features/call/domain/entities/agora_info_entity.dart';
import 'package:fourtyninehub/features/call/domain/usecases/get_agora_token_usecase.dart';

abstract class CallRepository {
  Future<Either<Exception, AgoraInfoEntity>> getAgoraToken(
      GetAgoraTokenParams params);
}
