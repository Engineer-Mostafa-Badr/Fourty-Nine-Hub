import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

import '../entity/navigate_bar_entity.dart';
import '../entity/sub_tab_entity.dart';
import '../use_case/update_navigate_bar_use_case.dart';
import '../use_case/update_social_page_use_case.dart';
import '../use_case/update_sub_tab_use_case.dart';

abstract class CustomPageRepository{
  Future<Either<Failure,SocialPageEntity>>fetchSocialPage();
  Future<Either<Failure,bool>>updateSocialPage(SocialPageParams params);
  Future<Either<Failure,SubTabEntity>>fetchSubTab();
  Future<Either<Failure,bool>>updateSubTab(SubTabParams params);
  Future<Either<Failure,NavigateBarEntity>>fetchNavigateBar();
  Future<Either<Failure,bool>>updateNavigateBar(NavigateBarParams params);
}