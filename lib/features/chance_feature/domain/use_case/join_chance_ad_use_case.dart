import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../data/model/join_chance_ad_model.dart';
import '../repository/chance_repository.dart';

class JoinChanceAdUseCase {
  final ChanceRepository repository;

  JoinChanceAdUseCase(this.repository);

  Future<Either<Failure, bool>> call(JoinChanceAdParams params) async {
    return await repository.joinChanceAd(params);
  }
}

class JoinChanceAdParams {
  final String adId;
  final double amount;

  JoinChanceAdParams({
    required this.adId,
    required this.amount,
  });

  JoinChanceAdModel toModel() {
    return JoinChanceAdModel(
      adId: adId,
      amount: amount,
    );
  }
}