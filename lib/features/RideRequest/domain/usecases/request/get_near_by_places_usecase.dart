import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/google_search_results.dart';
import 'package:fourtyninehub/features/RideRequest/domain/repositories/ride_request_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../data/models/address_search_params_model.dart';

class GetNearByPlacesUseCase
    extends UseCase<List<GoogleSearchResultModel>, AddressSearchParamsModel> {
  final RideRequestRepo _repo;
  GetNearByPlacesUseCase(this._repo);
  @override
  Future<Either<Failure, List<GoogleSearchResultModel>>> call(
      AddressSearchParamsModel params) {
    return _repo.searchGoogleSearchNearByPlaces(params: params);
  }
}
