import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/data/models/address_search_params_model.dart';
import '../../../../ride/RideRequest/data/models/expected_price_model.dart';
import '../../../../ride/RideRequest/data/models/google_search_results.dart';
import '../../../../ride/RideRequest/data/models/params/expected_price_params.dart';
import '../../../../ride/RideRequest/data/models/ride_request_model.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';
import '../../domain/repositories/create_shipping_repo.dart';
import '../datasources/create_shipping_remote_data_source.dart';

class CreateShippingRepoImpl implements CreateShippingRepo {
  final CreateShippingRemoteDataSource _remoteDataSource;
  CreateShippingRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, RideRequestModel>> addShippingRequest(
      {required RideRequestModel request}) async {
    return await _remoteDataSource.addShippingRequest(request: request);
  }

  @override
  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params}) async {
    return await _remoteDataSource.getExpectedPrice(params: params);
  }

  @override
  Future<Either<Failure, List<GoogleSearchResultModel>>> getNearByPlaces(
      {required AddressSearchParamsModel params}) async {
    return await _remoteDataSource.getNearByPlaces(params: params);
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
      {required String mainCategoryId}) async {
    return await _remoteDataSource.getSubCategories(
        mainCategoryId: mainCategoryId);
  }
}
