import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../domain/entities/gift_and_competition_entity.dart';
import '../../domain/entities/wallet/main_category_entity.dart';
import '../../domain/entities/wallet/wallet_history_entity.dart';
import '../../domain/entities/wallet/wallet_subscription_entity.dart';
import '../../domain/usecases/add_subscribe_use_case.dart';
import '../../domain/usecases/delete_subscription_use_case.dart';
import '../../domain/usecases/get_wallet_history_use_case.dart';
import '../../domain/usecases/main_category_use_case.dart';
import '../models/gift_and_competition_model.dart';
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

  Future<Either<Failure, bool>> deleteSubscription(
      DeleteSubscriptionParams params);

  Future<Either<Failure, bool>> addSubscription(AddSubscriptionParams params);

  Future<Either<Failure, GiftAndCompetitionEntity>> getGiftCompetitions();
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
    try {
      final response =
          await _apiConsumer.get(EndPoints.getHistoryWallet(params));
      return response.fold((l) {
        return Left(l);
      }, (data) {
        final list = (data['data'] as List)
            .map((e) => WalletHistoryModel.fromJson(e))
            .toList();
        return Right(list);
      });
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<WalletSubscriptionModel>>>
      fetchSubscriptionWallet() async {
    try {
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
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchMainCategory(
      MainCategoryParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.geMainCategoryWallet(params),
        // queryParameters: params.paginationParams.toJson(),
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
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchSubCategory(
      MainCategoryParams params) async {
    try {
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
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSubscription(
      DeleteSubscriptionParams params) async {
    try {
      final response = await _apiConsumer.delete(
        EndPoints.deleteSubscription(params.subscriptionId!),
      );
      return response.fold(
        (failure) => Left(failure),
        (response) => Right(response['status']),
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> addSubscription(
      AddSubscriptionParams params) async {
    try {
      final response =
          await _apiConsumer.post(EndPoints.addSubscription(), data: {
        'subCategoryId': params.subCategoryId,
        'paymentMethodType': params.paymentMethod,
        'isPremium': params.isPremium,
        'period': params.period,
        'periodType': params.periodType,
      });
      return response.fold(
        (failure) => Left(failure),
        (response) => Right(response['status']),
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, GiftAndCompetitionEntity>>
      getGiftCompetitions() async {
    final response = await _apiConsumer.get(EndPoints.getGiftAndCompetitions);

    try {
      return response.fold(
        (failure) => Left(failure),
        (response) {
          // final list = (response['data'] as List)
          //     .map((e) => GiftCompetitionModel.fromJson(e))
          //     .toList();
          return Right(GiftAndCompetitionModel.fromJson(response['data']));
        },
      );
    } catch (e) {
      print(e);
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }
}
