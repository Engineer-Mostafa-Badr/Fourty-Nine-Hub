import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_saved_cards_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetSavedCardsUseCase extends UseCase<List<CardEntity>, NoParams> {
  final PaymentProviderRepository _repository;

  GetSavedCardsUseCase(this._repository);

  @override
  Future<Either<Failure, List<CardEntity>>> call(NoParams params) async {
    return await _repository.getSavedCards();
  }
}
