import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/images_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/id_s3_request_model/id_s3_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/id_s3_response_model/id_s3_response_model.dart';

class ImagesRepository {
  ImagesDataSource dataSource;
  ImagesRepository({required this.dataSource});
  Future<Either<Failure, IdS3ResponseModel>> getS3Id(
      {required IdS3RequestModel model}) async {
    try {
      var response = await dataSource.getS3(
          json: model.toJson(), endpoint: EndPoints.idLicenseS3);
      log(response.toString(), name: "234234234");
      if (response['status'] == true) {
        return right(IdS3ResponseModel.fromJson(response.data));
      } else {
        return left(ServerFailure(message: response.data["error"]['message']));
      }
    } catch (error) {
      return left(ServerFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, String>> uploadImage(
      {required IdS3ResponseModel model}) async {
    try {
      var response = await dataSource.getS3(
          json: model.toJson(), endpoint: EndPoints.idLicenseS3);
      log(response.toString(), name: "234234234");
      if (response['status'] == true) {
        return right("IdS3ResponseModel.fromJson(response.data)");
      } else {
        return left(ServerFailure(message: response.data["error"]['message']));
      }
    } catch (error) {
      return left(ServerFailure(message: error.toString()));
    }
  }
  // Future<Either<Failure, IdS3RequestModel>> getS3Id(
  //     {required IdS3RequestModel model}) async {
  //   try {
  //     Response response = await dataSource.getS3(
  //         json: model.toJson(), endpoint: EndPoints.idLicenseS3);
  //     if (response.statusCode == 200) {
  //       return right(IdS3RequestModel.fromJson(response.data));
  //     } else {
  //       return left(ServerFailure(message: response.data["error"]['message']));
  //     }
  //   } catch (error) {
  //     return left(ServerFailure(message: error.toString()));
  //   }
  // }
}

// import 'dart:io';
// import 'package:http/http.dart' as http;

// Future<void> uploadImageToS3(File imageFile, String signedUrl) async {
//   try {
// final request = http.Request('PUT', Uri.parse(signedUrl));
// request.headers['Content-Type'] = 'image/png';  // استخدم نوع الملف المناسب
// request.headers['x-amz-acl'] = 'private';       // إذا كنت تستخدم هذا النوع في الـ signedUrl
// request.bodyBytes = await imageFile.readAsBytes();

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       print('Upload successful!');
//     } else {
//       print('Failed to upload. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error uploading image: $e');
//   }
// }
