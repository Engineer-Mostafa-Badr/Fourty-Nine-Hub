import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/register/driver_register/data/models/rider_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_type_model.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

import '../../domain/repositories/rider_register_repo.dart';

class RiderRegisterRepoImpl extends RiderRegisterRepo {
  @override
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes(
      {required String subCategory}) {
    // TODO: implement getCarTypes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
      {required String mainCategory}) {
    // TODO: implement getSubCategories
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> postRiderInfo({required RiderInfoModel data}) {
    // TODO: implement postRiderInfo
    throw UnimplementedError();
  }
}
