import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../domain/entities/wallet/main_category_entity.dart';
import '../../domain/entities/wallet/wallet_history_entity.dart';
import '../../domain/entities/wallet/wallet_subscription_entity.dart';
import '../../domain/usecases/get_wallet_history_use_case.dart';
import '../../domain/usecases/main_category_use_case.dart';
import '../models/wallet/main_category_model.dart';
import '../models/wallet/wallet_history_model.dart';
import '../models/wallet/wallet_model.dart';
import '../models/wallet/wallet_subscription_model.dart';

abstract class WalletRemoteDataSource {
  Future<Either<Failure, WalletModel>> getWallet();

  Future<Either<Failure, List<WalletHistoryEntity>>> fetchHistoryWallet(
      WalletHistoryParams params);

  Future<Either<Failure, List<WalletSubscriptionEntity>>>
      fetchSubscriptionWallet();

  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchMainCategory(
      MainCategoryParams params);

  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchSubCategory(
      MainCategoryParams params);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiConsumer _apiConsumer;

  WalletRemoteDataSourceImpl(this._apiConsumer);

  @override
  // Future<Either<Failure, List<CompetitionEntity>>> getCompetitions() async {
  //   final response = await _apiConsumer.get(Jsons.competitionList);
  //   return response.fold(
  //       (l) => Left(l),
  //       (data) => Right((data['data']['items'] as List)
  //           .map((e) => CompetitionModel.fromJson(e))
  //           .toList()));
  // }

  @override
  Future<Either<Failure, WalletModel>> getWallet() async {
    final response = await _apiConsumer.get(EndPoints.getWallet);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(WalletModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> fetchHistoryWallet(
      WalletHistoryParams params) async {
    final response = await _apiConsumer.get(EndPoints.getHistoryWallet(params));
    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data'] as List)
          .map((e) => WalletHistoryModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<WalletSubscriptionModel>>>
      fetchSubscriptionWallet() async {
    final response = await _apiConsumer.get(EndPoints.getSubscription);

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => WalletSubscriptionModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchMainCategory(
      MainCategoryParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.geMainCategoryWallet(),
      queryParameters: params.paginationParams.toJson(),
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data']['mainCategories'] as List)
            .map((e) => MainCategoryWalletModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchSubCategory(MainCategoryParams params)async {
    final response = await _apiConsumer.get(
      EndPoints.geSubCategoryWallet(params.id!),
      queryParameters: params.paginationParams.toJson(),
    );

    return response.fold(
          (failure) => Left(failure),
          (response) {
        final list = (response['data']['subcategories'] as List)
            .map((e) => MainCategoryWalletModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }
}
