import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/user_data_tinder_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';



class GetUserDataUseCase extends UseCase<List<UserDataTinderEntity>, GetUsersParams> {
  final TinderRepository _repository;

  GetUserDataUseCase(this._repository);


  @override
  Future<Either<Failure, List<UserDataTinderEntity>>> call(GetUsersParams params) {
    return _repository.getUsers(params);
  }
}


class GetUsersParams {
  final String gender;
  final int page;
  final int limit;

  GetUsersParams({required this.gender, required this.page, required this.limit});

  //toJson
  Map<String, dynamic> toJson() => {
    'gender': gender,
    'page': page,
    'limit': limit,
  };
}