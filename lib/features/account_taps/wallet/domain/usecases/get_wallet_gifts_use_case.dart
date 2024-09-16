import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class GetWalletGiftsUseCase extends UseCase<GiftEntity, NoParams> {
  final GiftRepository _repo;
  GetWalletGiftsUseCase(this._repo);
  @override
  Future<Either<Failure, GiftEntity>> call(NoParams params) async {
    return await _repo.fetchGiftWallet();
  }
}
