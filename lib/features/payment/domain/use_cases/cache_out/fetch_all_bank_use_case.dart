import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../entities/cache_out_entity/list_bank_entity.dart';
import '../../repositories/cache_out/payment_cache_out_repository.dart';

class FetchAllBankUseCase extends UseCase<List<ListBankEntity>, NoParams> {
  final PaymentCacheOutRepository _repo;

  FetchAllBankUseCase(this._repo);

  @override
  Future<Either<Failure, List<ListBankEntity>>> call(NoParams params) async {
    return await _repo.fetchAllBank();
  }
}
