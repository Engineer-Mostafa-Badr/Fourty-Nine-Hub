import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';

import '../repositories/fourty_nine_repository.dart';

class GetCurrencyUseCase extends UseCase<CurrencyEntity, NoParams> {
  final FourtyNineRepository _nineRepository;

  GetCurrencyUseCase(this._nineRepository);
  @override
  Future<Either<Failure, CurrencyEntity>> call(NoParams params) async {
    return await _nineRepository.getCurrency();
  }
}
