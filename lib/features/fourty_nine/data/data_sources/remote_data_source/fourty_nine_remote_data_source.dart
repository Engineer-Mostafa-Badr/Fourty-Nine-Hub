import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/json_parser.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../../models/banner_model.dart';
import '../../models/currency_model.dart';
import '../../models/main_category_model.dart';
import '../../models/parent_main_category_model.dart';
import '../../models/question_model.dart';
import '../../../domain/entities/currency_entity.dart';
import '../../../domain/entities/main_category_entity.dart';
import '../../../domain/entities/parent_main_category_entity.dart';
import '../../../domain/entities/question_entity.dart';
import '../../../domain/entities/slider_item_entity.dart';
import '../../../domain/use_cases/answer_question_usecase.dart';
import '../../../domain/use_cases/get_main_categories_use_case.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../domain/entities/wallet_home_entity.dart';
import '../../models/slider_item_model.dart';
import '../../models/wallet_home_model.dart';

abstract class FourtyNineRemoteDataSource {
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories();

  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories(
      MainCategoriesParams params);
  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategoriesCustomPage(
      MainCategoriesParams params);
  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems();

  Future<Either<Failure, MainCategoryEntity>> getMainCategoryDetails(String id);

  Future<Either<Failure, bool>> addMainCategoryToFavorites(String id);
  Future<Either<Failure, bool>> toggleSubCategoryToFavorites(String id);

  Future<Either<Failure, bool>> deleteAd(String id);

  Future<Either<Failure, bool>> removeMainCategoryFromFavorites(String id);
  Future<Either<Failure, BannerModel>> getBannerById({required String id});
  Future<Either<Failure, WalletHomeEntity>> getWalletHome();
  Future<Either<Failure, CurrencyEntity>> getCurrency();
  Future<Either<Failure, bool>> anyCashBack();
  Future<Either<Failure, QuestionEntity>> getQuestion();
  Future<Either<Failure, bool>> answerQuestion(AnswerQuestionParams params);
}

class FourtyNineRemoteDataSourceImpl implements FourtyNineRemoteDataSource {
  final JsonParser _jsonParser;
  final ApiConsumer _apiConsumer;

  FourtyNineRemoteDataSourceImpl(this._apiConsumer, this._jsonParser);

  @override
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories() async {
    final response = await _apiConsumer.get(EndPoints.getParentMainCategories);
    return response.fold(
        (failure) => Left(failure),
        (response) => Right((response['data']['parentCategories'] as List)
            .map((e) => ParentMainCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories(
      MainCategoriesParams params) async {
    final result = await _apiConsumer.get(
      EndPoints.getMainCategoriesWithoutSubcategories,
      queryParameters: params.toJson(),
    );
    return result.fold(
      (failure) {
        CliLogger.error(
            "can't load main categories - from data source - there is an error ${failure.toString()}");
        return Left(failure);
      },
      (response) => Right((response['data']['mainCategories'] as List)
          .map((e) => MainCategoryModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategoriesCustomPage(
      MainCategoriesParams params) async {
    final result = await _apiConsumer.get(
      EndPoints.getMainCategoriesCustomPage,
      queryParameters: params.toJson(),
    );
    return result.fold(
      (failure) {
        CliLogger.error(
            "can't load main categories - from data source - there is an error ${failure.toString()}");
        return Left(failure);
      },
      (response) => Right((response['data']['mainCategories'] as List)
          .map((e) => MainCategoryModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems() async {
    print("Slider data source");
    final result = await _apiConsumer.get(EndPoints.sliderItems);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right((response['data'] as List)
          .map((e) => SliderItemModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, MainCategoryEntity>> getMainCategoryDetails(
      String id) async {
    final result = await _apiConsumer.get(EndPoints.getMainCategoryDetails(id));
    return result.fold(
      (failure) => Left(failure),
      (response) =>
          Right(MainCategoryModel.fromJson(response['data']['mainCategory'])),
    );
  }

  @override
  Future<Either<Failure, bool>> addMainCategoryToFavorites(String id) async {
    final result =
        await _apiConsumer.post(EndPoints.addMainCategoryToFavorite(id));
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(data['status']),
    );
  }

  @override
  Future<Either<Failure, bool>> toggleSubCategoryToFavorites(String id) async {
    final result =
        await _apiConsumer.post(EndPoints.toggleSubCategoryToFavorites(id));
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(data['status']),
    );
  }

  @override
  Future<Either<Failure, bool>> removeMainCategoryFromFavorites(
      String id) async {
    final result =
        await _apiConsumer.delete(EndPoints.deleteMainCategoryFromFavorite(id));
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(data['status']),
    );
  }

  @override
  Future<Either<Failure, BannerModel>> getBannerById(
      {required String id}) async {
    final result = await _apiConsumer.get(
      EndPoints.getBannerByID(id: id),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(BannerModel.fromJson(
          response['data']["mainCategory"] as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<Failure, WalletHomeEntity>> getWalletHome() async {
    final result = await _apiConsumer.get(EndPoints.getWalletHome);
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(WalletHomeModel.fromJson(data['data'])),
    );
  }

  @override
  Future<Either<Failure, CurrencyEntity>> getCurrency() async {
    final result = await _apiConsumer.get(EndPoints.getCurrency);
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(CurrencyModel.fromJson(data['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> anyCashBack() async {
    final result = await _apiConsumer.post(EndPoints.anyCashBack);
    return result.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        return Right(data['status']);
      },
    );
  }

  @override
  Future<Either<Failure, QuestionEntity>> getQuestion() async {
    final result = await _apiConsumer.get(EndPoints.getQuestion);
    return result.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        return Right(QuestionModel.fromJson(data['data']));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> answerQuestion(
      AnswerQuestionParams params) async {
    final result = await _apiConsumer.post(EndPoints.answerQuestion(params.id),
        data: {"answer": params.answer});
    return result.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        return Right(data['status'] ?? (data['success'] ?? false));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteAd(String id) async {
    final result = await _apiConsumer.delete(EndPoints.deleteAd(id));
    return result.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        return Right(data['status']);
      },
    );
  }
}
