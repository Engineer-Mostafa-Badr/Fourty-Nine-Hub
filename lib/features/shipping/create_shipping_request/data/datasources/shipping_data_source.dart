import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';

class ShippingDataSource {
  ApiConsumer api;
  ShippingDataSource({required this.api});
  Future<Either<Failure, Map<String, dynamic>>> getBannerData() {
    return api.get(EndPoints.bannerData);
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3(
      {required String endpoint, Map<String, dynamic>? data}) {
    return api.put(endpoint, data: data);
  }
}
