import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_wallet_entity.dart';


abstract class GiftRepository {
  Future<Either<Failure, GiftWalletEntity>> fetchGiftWallet();
  Future<Either<Failure, bool>> requestWithdrawCompetition(String id);
  Future<Either<Failure, bool>> requestWithdrawWheel();
}
