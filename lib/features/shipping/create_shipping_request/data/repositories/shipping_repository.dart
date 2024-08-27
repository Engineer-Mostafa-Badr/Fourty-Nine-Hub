import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/base_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/shipping_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_images_s3_model/car_images_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/driver_register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/drivnig_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_documents_model/info_documents_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/info_id_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;

class ShippingRepository {
  ShippingDataSource dataSource;
  BaseRepository repository;
  ShippingRepository({required this.dataSource, required this.repository});
  Future<Either<Failure, Map<String, dynamic>>> getBannerData() async {
    try {
      return dataSource.getBannerData();
    } catch (error) {
      log(error.toString(), name: "Error Error");
      return left(ServerFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3ImageDocuments(
      {required Map<String, dynamic> json, required String endpoint}) async {
    // try {
    return dataSource.getS3(
      endpoint: endpoint,
      data: json,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3IDImages(
      {required InfoIdS3Model model}) async {
    try {
      log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
      return dataSource.getS3(endpoint: EndPoints.infoId, data: model.toJson());
    } catch (error) {
      return left(ServerFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3DrivingLicense(
      {required DrivnigLicenseS3Model model}) {
    log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
    return dataSource.getS3(
        endpoint: EndPoints.drivingLicenseS3, data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3CarLicense(
      {required CarLicenseS3Model model}) {
    // try {
    log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
    return dataSource.getS3(
        endpoint: EndPoints.carLicenseS3, data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3CarImages(
      {required CarImagesS3Model model}) {
    // try {
    log(model.toJson().toString(), name: "lllllllllllllllllllllllllll");
    return dataSource.getS3(
        endpoint: EndPoints.carImageS3, data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> register(
      {required DriverRegisterRequestModel model}) {
    log(model.register().toString(),
        name: "ksdjsldkjslkdjfslkdjflskdjflskdjflskdjf");
    return dataSource.register(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> favorite({required String id}) {
    return dataSource.favorite(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> confirm({required String id}) {
    return dataSource.confirm(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> createTrip(
      {required RequestModel model}) async {
    List<S3UploadModel> imagesS3 = [];
    // ignore: unused_local_variable
    // if (model.tripImages != null) {
    //   for (var image in model.tripImages!) {
    //     var responseUploadImage = await uploadImages(
    //         image: image, subcategoryId: model.subcategoryEntity?.id ?? "");
    //     await responseUploadImage.fold(
    //       (l) async {
    //         log(l.toString());
    //       },
    //       (r) async {
    //         var json = r;
    //         var mediaId = json['data']['mediaId'];
    //         model.mediaIds ??= [];
    //         model.mediaIds!.add(mediaId);
    //         imagesS3.add(S3UploadModel(image,
    //             sigendUrl: json['data']['signedUrl'], mediaId: mediaId));
    //         // await confirmResponse.fold(
    //         //   (l) async {
    //         //     log(l.toString());
    //         //   },
    //         //   (r) {

    //         //   },
    //         // );
    //       },
    //     );
    //   }
    // }

    var response = await dataSource.createTrip(model: model);

    return response;
  }

  Future<Either<Failure, Map<String, dynamic>>> getAllTripBySubCategory() {
    return dataSource.getAllTripBySubCategory();
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptLoadingTripOffer(
      {required String id}) {
    return dataSource.acceptLoadingTripOffer(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> sendOfferPremium(
      {required String id, required double price}) {
    return dataSource.sendOfferPremium(id: id, price: price);
  }

  Future<Either<Failure, Map<String, dynamic>>> sendOffer(
      {required String id, required double price}) {
    return dataSource.sendOffer(id: id, price: price);
  }

  Future<Either<Failure, Map<String, dynamic>>> report(
      {required String loadingTripId}) {
    return dataSource.report(
      loadingTripId: loadingTripId,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getMyTrip() {
    return dataSource.getMyTrip();
  }
  // Future<Either<Failure, Map<String, dynamic>>> uploadImages(
  //     {required XFile image, required String subcategoryId}) async {
  //   Map<String, dynamic> json = {};
  //   String mediaId = "";
  //   return dataSource.signedUrl(
  //     json: {
  //       "type": getFileExtension(File(image.path)),
  //       "size": await getFileSize(File(image.path)),
  //       "subcategoryId": subcategoryId
  //     },
  //   );
  // }

  // getFileExtension(File file) {
  //   log("image/${path.extension(file.path).substring(1)}");
  //   if (file.existsSync()) {
  //     return "image/${path.extension(file.path).substring(1)}";
  //   } else {
  //     return "image/png";
  //   }
  // }

  // getFileSize(File file) async {
  //   final bytes = await file.readAsBytes();
  //   return bytes.length;
  // }

  Future<Either<Failure, Map<String, dynamic>>> getCallMessage(
      {required String ownerId, required String subcategoryId}) {
    return dataSource.callMessage(
        ownerId: ownerId, subcategoryId: subcategoryId);
  }

  Future<Either<Failure, Map<String, dynamic>>> loadingTripRequests() {
    return dataSource.loadingTripRequests();
  }
  Future<Either<Failure, Map<String, dynamic>>> getShippingRequests() {
    return dataSource.getShippingRequests();
  }
}

class S3UploadModel {
  final String sigendUrl;
  final String mediaId;
  final XFile image;

  S3UploadModel(this.image, {required this.sigendUrl, required this.mediaId});
}

// class CreateTripReturnModel {
//   final Map<String, dynamic> data;
//   final List<S3UploadModel> images;

//   CreateTripReturnModel({required this.data, required this.images});
// }
