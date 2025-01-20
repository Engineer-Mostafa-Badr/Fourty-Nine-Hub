import 'package:either_dart/src/either.dart';
import 'package:fourtyninehub/features/call/data/datasources/call_remote_datasource.dart';
import 'package:fourtyninehub/features/call/domain/entities/agora_info_entity.dart';
import 'package:fourtyninehub/features/call/domain/repositories/call_repository.dart';
import 'package:fourtyninehub/features/call/domain/usecases/get_agora_token_usecase.dart';

class CallRepositoryImpl implements CallRepository {
  final CallRemoteDatasource _callRemoteDatasource;

  CallRepositoryImpl(this._callRemoteDatasource);

  @override
  Future<Either<Exception, AgoraInfoEntity>> getAgoraToken(
          GetAgoraTokenParams params) =>
      _callRemoteDatasource.getAgoraToken(params);
}
