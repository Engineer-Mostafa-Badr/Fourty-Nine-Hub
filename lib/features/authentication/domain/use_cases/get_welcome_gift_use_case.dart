import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/error/failure.dart';

class GetWelcomeGiftUseCase extends UseCase<double, NoParams> {
  final AuthRepository _repository;

  GetWelcomeGiftUseCase(this._repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await _repository.getWelcomeGift();
  }
}
