import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';

import '../../../../core/error/failure.dart';
import '../repositories/wheel_repository.dart';

class GetWheelWalletUseCase extends UseCase<WheelWalletEntity, NoParams> {
  final WheelRepository repository;

  GetWheelWalletUseCase(this.repository);

  @override
  Future<Either<Failure, WheelWalletEntity>> call(NoParams params) {
    return repository.getWheelWallet();
  }
}
