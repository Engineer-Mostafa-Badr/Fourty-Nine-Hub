import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_competitions_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/gift_and_competition_entity.dart';
import '../repositories/wallet_repo.dart';

class GetGiftCompetitionsUseCase
    extends UseCase<GiftAndCompetitionEntity, NoParams> {
  final WalletRepo _repo;
  GetGiftCompetitionsUseCase(this._repo);
  @override
  Future<Either<Failure, GiftAndCompetitionEntity>> call(NoParams params) {
    return _repo.getGiftCompetitions();
  }
}
