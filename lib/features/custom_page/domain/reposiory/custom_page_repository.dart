import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

import '../use_case/update_social_page_use_case.dart';

abstract class CustomPageRepository{
  Future<Either<Failure,SocialPageEntity>>fetchSocialPage();
  Future<Either<Failure,bool>>updateSocialPage(SocialPageParams params);
}