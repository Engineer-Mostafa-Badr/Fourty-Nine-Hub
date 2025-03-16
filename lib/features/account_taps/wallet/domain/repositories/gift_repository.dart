import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_wallet_entity.dart';

import '../usecases/request_withdraw_wallet_use_case.dart';


abstract class GiftRepository {
  Future<Either<Failure, GiftWalletEntity>> fetchGiftWallet();
  Future<Either<Failure, bool>> requestWithdrawCompetition(String id);
  Future<Either<Failure, bool>> requestWithdrawWheel();
  Future<Either<Failure, bool>> requestWithdrawWallet(RequestWithdrawParams params);
}
