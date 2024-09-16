import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/payment/domain/entities/instapay_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class InstaPayUseCase extends UseCase<InstaPayResponseEntity, InstaPayParams> {
  final PaymentProviderRepository _repo;

  InstaPayUseCase(this._repo);

  @override
  Future<Either<Failure, InstaPayResponseEntity>> call(
      InstaPayParams params) async {
    return await _repo.postInstaPay(params);
  }
}
