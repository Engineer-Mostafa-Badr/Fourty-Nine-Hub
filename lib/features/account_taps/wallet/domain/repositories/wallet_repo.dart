import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/wallet_entity.dart';

abstract class WalletRepo {
  Future<Either<Failure, WalletEntity>> getWallet();
}
