import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/data/data_source/custom_page_remote_data_source.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

import '../../domain/reposiory/custom_page_repository.dart';

 class CustomPageRepositoryImpl extends CustomPageRepository{
   final CustomPageRemoteDataSource _customPageRemoteDataSource;

  CustomPageRepositoryImpl(this._customPageRemoteDataSource);
  @override
  Future<Either<Failure, SocialPageEntity>> fetchSocialPage() {
    return _customPageRemoteDataSource.fetchSocialPage();
  }

 }