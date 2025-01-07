import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/fourty_nine/data/models/banner_model.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/question_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/wallet_home_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/answer_question_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/parent_main_category_entity.dart';
import '../../domain/repositories/fourty_nine_repository.dart';
import '../data_sources/remote_data_source/fourty_nine_remote_data_source.dart';

class FourtyNineRepositoryImpl implements FourtyNineRepository {
  final FourtyNineRemoteDataSource _fourtyNineRemoteDataSource;

  FourtyNineRepositoryImpl(this._fourtyNineRemoteDataSource);

  @override
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories() {
    return _fourtyNineRemoteDataSource.getParentMainCategories();
  }

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategories(
      MainCategoriesParams params) {
    return _fourtyNineRemoteDataSource.getMainCategories(params);
  }

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategoriesCustomPage(
      MainCategoriesParams params) {
    return _fourtyNineRemoteDataSource.getMainCategoriesCustomPage(params);
  }

  @override
  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems() {
    print("Slider Rep");
    return _fourtyNineRemoteDataSource.getSliderItems();
  }

  @override
  Future<Either<Failure, MainCategoryEntity>> getMainCategoryDetails(
      String id) {
    return _fourtyNineRemoteDataSource.getMainCategoryDetails(id);
  }

  @override
  Future<Either<Failure, bool>> addMainCategoryToFavorites(String id) {
    return _fourtyNineRemoteDataSource.addMainCategoryToFavorites(id);
  }

  @override
  Future<Either<Failure, bool>> toggleSubCategoryToFavorites(String id) {
    return _fourtyNineRemoteDataSource.toggleSubCategoryToFavorites(id);
  }

  @override
  Future<Either<Failure, bool>> removeMainCategoryFromFavorites(String id) {
    return _fourtyNineRemoteDataSource.removeMainCategoryFromFavorites(id);
  }

  @override
  Future<Either<Failure, BannerModel>> getBannerById({required String id}) {
    return _fourtyNineRemoteDataSource.getBannerById(id: id);
  }

  @override
  Future<Either<Failure, WalletHomeEntity>> getWalletHome() {
    return _fourtyNineRemoteDataSource.getWalletHome();
  }

  @override
  Future<Either<Failure, CurrencyEntity>> getCurrency() {
    return _fourtyNineRemoteDataSource.getCurrency();
  }

  @override
  Future<Either<Failure, bool>> anyCashBack() {
    return _fourtyNineRemoteDataSource.anyCashBack();
  }

  @override
  Future<Either<Failure, QuestionEntity>> getQuestion() {
    return _fourtyNineRemoteDataSource.getQuestion();
  }

  @override
  Future<Either<Failure, bool>> answerQuestion(AnswerQuestionParams params) {
    return _fourtyNineRemoteDataSource.answerQuestion(params);
  }
}
