import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competition_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/wallet_repo.dart';

class GetCompetitionsUsecase extends UseCase<List<CompetitionEntity>, NoParams> {
  final WalletRepo _repo;
  GetCompetitionsUsecase(this._repo);
  @override
  Future<Either<Failure, List<CompetitionEntity>>> call(NoParams params) {
    return _repo.getCompetitions();
  }
}