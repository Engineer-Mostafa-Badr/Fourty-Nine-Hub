import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/fourty_nine_repository.dart';

class GetCurrencyUseCase extends UseCase<String, NoParams> {
  final FourtyNineRepository _nineRepository;

  GetCurrencyUseCase(this._nineRepository);
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await _nineRepository.getCurrency();
  }
}
