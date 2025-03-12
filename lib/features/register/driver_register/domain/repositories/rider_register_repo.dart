import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/register/driver_register/data/models/rider_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_type_model.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

import '../../../../../core/error/failure.dart';

abstract class RiderRegisterRepo {
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories({
    required String mainCategory,
  });
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes({
    required String subCategory,
  });

  Future<Either<Failure, bool>> postRiderInfo({required RiderInfoModel data});
}
