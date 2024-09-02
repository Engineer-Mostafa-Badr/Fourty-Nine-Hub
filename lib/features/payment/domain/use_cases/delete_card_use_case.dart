
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_delete_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

class DeleteCardUseCase extends UseCase<DeleteCardResponse, String> {
  final PaymentProviderRepository _repo;

  DeleteCardUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteCardResponse>> call(String cardId) async {
    return await _repo.deleteCard(cardId);
  }
}
