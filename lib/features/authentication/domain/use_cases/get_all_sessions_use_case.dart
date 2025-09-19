import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/session_entity.dart';

import '../repositories/auth_repository.dart';

class GetAllSessionsUseCase {
  final AuthRepository _repository;

  GetAllSessionsUseCase(this._repository);

  Future<Either<Failure, List<SessionEntity>>> call() {
    return _repository.getAllSessions();
  }
}