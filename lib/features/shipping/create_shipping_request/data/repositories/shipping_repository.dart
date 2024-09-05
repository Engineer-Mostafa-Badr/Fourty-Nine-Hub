import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/base_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/shipping_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_images_s3_model/car_images_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/drivnig_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_documents_model/info_documents_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/info_id_s3_model.dart';

class ShippingRepository {
  ShippingDataSource dataSource;
  BaseRepository repository;
  ShippingRepository({required this.dataSource, required this.repository});
  Future<Either<Failure, Map<String, dynamic>>> getBannerData() async {
    try {
      return dataSource.getBannerData();
      // return response;
      // return right(BannerModel.fromJson(response['data']['data']));
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

  Future<Either<Failure, Map<String, dynamic>>> getS3ImageDocuments(
      {required InfoDocumentsModel model}) async {
    // try {
    return dataSource.getS3(
      endpoint: EndPoints.infoDocuments,
      data: model.toJson(),
    );
    // } catch (error) {
    //   return left(ServerFailure(message: error.toString()));
    // }
    // // /api/v1/loading/driver/info/documents
    // {
    // "document": {
    //     "name": "criminalRecord",
    //     "type": "image/png",
    //     "size": 369214
    // }
// }
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3IDImages(
      {required InfoIdS3Model model}) async {
    try {
      log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
      return dataSource.getS3(endpoint: EndPoints.infoId, data: model.toJson());
      // log(response.toString(), name: "lllllllllllllllllllllllllll");
      // return right("Success");
    } catch (error) {
      return left(ServerFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3DrivingLicense(
      {required DrivnigLicenseS3Model model}) {
    log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
    return dataSource.getS3(
        endpoint: EndPoints.drivingLicenseS3, data: model.toJson());

    //api/v1/ride/info/driving-license
//     {
//     "expireDate": "2024-5-24",
//     "drivingLicenseFront": {
//         "type": "image/png",
//         "size": 100034
//     },
//     "drivingLicenseBehind": {
//         "type": "image/png",
//         "size": 100034
//     }
// }
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3CarLicense(
      {required CarLicenseS3Model model}) {
    // try {
    log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
    return dataSource.getS3(
        endpoint: EndPoints.carLicenseS3, data: model.toJson());
    // } catch (error) {
    //   return left(ServerFailure(message: error.toString()));
    // }
    // /api/v1/ride/info/car-license
//     {
//     "expireDate": "2024-5-24",
//     "carLicenseFront": {
//         "type": "image/png",
//         "size": 100034
//     },
//     "carLicenseBehind": {
//         "type": "image/png",
//         "size": 100034
//     }
// }
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3CarImages(
      {required CarImagesS3Model model}) {
    // try {
    log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
    return dataSource.getS3(
        endpoint: EndPoints.carImageS3, data: model.toJson());
    // } catch (error) {
    //   return left(ServerFailure(message: error.toString()));
    // }
    //api/v1/ride/info/car-images
//     {
//     "updateImageIndex": [1, 2, 3, 4, 5],
//     "carImages": [
//         {
//             "type": "image/png",
//             "size": 4000
//         },
//         {
//             "type": "image/png",
//             "size": 4000
//         }
//     ]
// }
  }
}
