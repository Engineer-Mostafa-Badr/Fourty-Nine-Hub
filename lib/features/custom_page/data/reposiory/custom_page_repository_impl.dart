import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/data/data_source/custom_page_remote_data_source.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/activate_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/navigate_bar_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/sub_tab_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_favourite_cat_use_case.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_navigate_bar_use_case.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_social_page_use_case.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_sub_tab_use_case.dart';

import '../../domain/entity/custom_page_categories_entity.dart';
import '../../domain/reposiory/custom_page_repository.dart';

class CustomPageRepositoryImpl extends CustomPageRepository {
  final CustomPageRemoteDataSource _customPageRemoteDataSource;

  CustomPageRepositoryImpl(this._customPageRemoteDataSource);
  @override
  Future<Either<Failure, SocialPageEntity>> fetchSocialPage() {
    return _customPageRemoteDataSource.fetchSocialPage();
  }

  @override
  Future<Either<Failure, bool>> updateSocialPage(SocialPageParams params) {
    return _customPageRemoteDataSource.updateSocialPage(params);
  }

  @override
  Future<Either<Failure, SubTabEntity>> fetchSubTab() {
    return _customPageRemoteDataSource.fetchSubTab();
  }

  @override
  Future<Either<Failure, bool>> updateSubTab(SubTabParams params) {
    return _customPageRemoteDataSource.updateSubTab(params);
  }

  @override
  Future<Either<Failure, NavigateBarEntity>> fetchNavigateBar() {
    return _customPageRemoteDataSource.fetchNavigateBar();
  }

  @override
  Future<Either<Failure, bool>> updateNavigateBar(NavigateBarParams params) {
    return _customPageRemoteDataSource.updateNavigateBar(params);
  }

  @override
  Future<Either<Failure, List<CustomPageCategoriesEntity>>> fetchFavouriteCat() {
    return _customPageRemoteDataSource.fetchFavouriteCat();
  }

  @override
  Future<Either<Failure, bool>> updateFavouriteCat(FavouriteCatParams params) {
    return _customPageRemoteDataSource.updateFavouriteCat(params);
  }

  @override
  Future<Either<Failure, ActivateEntity>> fetchActivate() {
    return _customPageRemoteDataSource.fetchActivate();
  }

  @override
  Future<Either<Failure, bool>> updateActivate({required bool customPage}) {
    return _customPageRemoteDataSource.updateActivate(customPage: customPage);
  }
}
