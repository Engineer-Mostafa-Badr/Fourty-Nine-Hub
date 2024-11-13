import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

import '../../data/models/tinder_person_model.dart';


class FetchLastSeenUseCase extends UseCase<LastSeenModel, String> {
  final TinderRepository _repository;

  FetchLastSeenUseCase(this._repository);

  @override
  Future<Either<Failure, LastSeenModel>> call(String params) {
    return _repository.fetchLastSeen(params);
  }
}

