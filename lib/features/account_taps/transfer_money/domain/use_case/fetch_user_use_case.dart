import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/repository/transfer_money_repository.dart';

import '../entities/user_transfer_money_entity.dart';

class FetchUserUseCase
    extends UseCase<List<UserTransferMoneyEntity>, FetchUserParams> {
  final TransferMoneyRepository _transferMoneyRepository;

  FetchUserUseCase(this._transferMoneyRepository);
  @override
  Future<Either<Failure, List<UserTransferMoneyEntity>>> call(
      FetchUserParams params) async {
    return await _transferMoneyRepository.fetchUser(params);
  }
}

class FetchUserParams {
  final String query;

  FetchUserParams({required this.query});

  Map<String, dynamic> toJson() => {
        'query': query,
      };
}
