import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/base_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/shipping_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';

class ShippingRepository {
  ShippingDataSource dataSource;
  BaseRepository repository;
  ShippingRepository({required this.dataSource, required this.repository});
  Future<Either<ServerFailure, BannerModel>> getBannerData() async {
    try {
      Response response = await dataSource.getBannerData();
      log(response.data.toString());
      return right(BannerModel.fromJson(response.data['data']));
    } catch (error) {
      log(error.toString(), name: "Error Error");
      return left(ServerFailure(message: error.toString()));
    }
    //   var response = await repository.repository(
    //     dataSource.getBannerData(),
    //     fromJsonT: (json) => json,
    //   );
    // log(response.toString(), name: )
    // return response.fold(
    //   (l) {
    //     return left(ServerFailure(message: l.message));
    //   },
    //   (r) {
    //     log(r.message.toString(), name: "a;lksdjf");
    //     return right(BannerModel.fromJson(r.data));
    //   },
    // );
  }
}
