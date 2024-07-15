import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../repositories/ads_repo.dart';

class RequestComeWithMeUseCase extends UseCase<bool, RequestParams> {
  final AdsRepo _repo;
  RequestComeWithMeUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(RequestParams params) {
    return _repo.requestComeWithMe(params: params);
  }
}

class RequestParams {
  final String subCategoryId;
  final String phone;
  RequestParams({
    required this.subCategoryId, 
    required this.phone, 
  });
   Map<String, dynamic> toJson() => {
        
        "phone": phone,
      };
}
