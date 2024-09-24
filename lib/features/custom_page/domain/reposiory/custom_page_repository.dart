import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

abstract class CustomPageRepository{
  Future<Either<Failure,SocialPageEntity>>fetchSocialPage();
}