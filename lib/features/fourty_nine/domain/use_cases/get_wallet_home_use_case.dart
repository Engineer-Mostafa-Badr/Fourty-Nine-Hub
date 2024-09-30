import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entities/wallet_home_entity.dart';
import '../repositories/fourty_nine_repository.dart';

class GetWalletHomeUseCase extends UseCase<WalletHomeEntity, NoParams> {
  final FourtyNineRepository _nineRepository;

  GetWalletHomeUseCase(this._nineRepository);
  @override
  Future<Either<Failure, WalletHomeEntity>> call(NoParams params) async {
    return await _nineRepository.getWalletHome();
  }
}
