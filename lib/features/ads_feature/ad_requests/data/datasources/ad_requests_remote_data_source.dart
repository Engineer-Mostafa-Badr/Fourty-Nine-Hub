import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';
import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';

abstract class AdRequestsRemoteDataSource {
  Future<Either<Failure, AddDetailsModel>> getAdDetails({required String id});
  Future<Either<Failure, List<AdModel>>> getRelevantAds({required int id});
}

class AdRequestsRemoteDataSourceImpl extends AdRequestsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AdRequestsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, AddDetailsModel>> getAdDetails(
      {required String id}) async {
    final response = await _apiConsumer.get(EndPoints.adDetails(id));

    return response.fold((failure) => Left(failure), (data) {
      final item = AddDetailsModel.fromJson(data['data']);
      return Right(item);
    });
  }

  @override
  Future<Either<Failure, List<AdModel>>> getRelevantAds(
      {required int id}) async {
    final response = await _apiConsumer.get(Jsons.userAdsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['ads'] as List)
            .map((e) => AdModel.fromJson(e))
            .toList()));
  }


}
