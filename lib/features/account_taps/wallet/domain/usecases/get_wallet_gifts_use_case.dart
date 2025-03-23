import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class GetWalletGiftsUseCase extends UseCase<GiftWalletEntity, NoParams> {
  final GiftRepository _repo;
  GetWalletGiftsUseCase(this._repo);
  @override
  Future<Either<Failure, GiftWalletEntity>> call(NoParams params) async {
    return await _repo.fetchGiftWallet();
  }
}
