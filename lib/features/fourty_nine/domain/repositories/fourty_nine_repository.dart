import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/question_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/answer_question_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';

import '../../../../core/error/failure.dart';
import '../entities/parent_main_category_entity.dart';
import '../entities/wallet_home_entity.dart';

abstract class FourtyNineRepository {
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories();

  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategories(
      MainCategoriesParams params);
  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategoriesCustomPage(
      MainCategoriesParams params);

  Future<Either<Failure, MainCategoryEntity>> getMainCategoryDetails(String id);

  Future<Either<Failure, bool>> addMainCategoryToFavorites(String id);
  Future<Either<Failure, bool>> anyCashBack();
  Future<Either<Failure, QuestionEntity>> getQuestion();
  Future<Either<Failure, bool>> answerQuestion(AnswerQuestionParams params);
  Future<Either<Failure, bool>> toggleSubCategoryToFavorites(String id);

  Future<Either<Failure, bool>> deleteAd(String id);

  Future<Either<Failure, bool>> removeMainCategoryFromFavorites(String id);

  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems();
  Future<Either<Failure, Banner>> getBannerById({required String id});

  Future<Either<Failure, WalletHomeEntity>> getWalletHome();
  Future<Either<Failure, CurrencyEntity>> getCurrency();
}
