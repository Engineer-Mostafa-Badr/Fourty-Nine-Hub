import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class VerifyQuestionsUseCase extends UseCase<String, VerifyQuestionsParams> {
  final AuthRepository _repository;

  VerifyQuestionsUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(VerifyQuestionsParams params) {
    return _repository.verifyQuestions(params);
  }
}


class VerifyQuestionsParams extends Equatable {
  final String userId;
  final int caskBackBalance;
  final int walletAmount;
  final int giftWalletAmount;

  const VerifyQuestionsParams({
    required this.userId,
    required this.caskBackBalance,
    required this.walletAmount,
    required this.giftWalletAmount,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    "answers":{
      "caskBackBalance": caskBackBalance,
      "walletAmount": walletAmount,
      "giftWalletAmount": giftWalletAmount
    }
  };
  @override
  List<Object?> get props => [
        userId,
        caskBackBalance,
        walletAmount,
        giftWalletAmount,
      ];
}
