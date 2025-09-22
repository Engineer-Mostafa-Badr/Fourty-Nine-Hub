import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetVerificationUseCase extends UseCase<bool, NoParams> {
  final TwitterRepo _repo;

  GetVerificationUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _repo.getVerification();
  }
}
