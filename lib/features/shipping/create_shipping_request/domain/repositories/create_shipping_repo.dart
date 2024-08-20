import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/data/models/address_search_params_model.dart';
import '../../../../ride/RideRequest/data/models/expected_price_model.dart';
import '../../../../ride/RideRequest/data/models/google_search_results.dart';
import '../../../../ride/RideRequest/data/models/params/expected_price_params.dart';
import '../../../../ride/RideRequest/data/models/ride_request_model.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';

abstract class CreateShippingRepo {
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
      {required String mainCategoryId});

  Future<Either<Failure, List<GoogleSearchResultModel>>> getNearByPlaces(
      {required AddressSearchParamsModel params});

  Future<Either<Failure, RideRequestModel>> addShippingRequest(
      {required RideRequestModel request});

  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params});
}
