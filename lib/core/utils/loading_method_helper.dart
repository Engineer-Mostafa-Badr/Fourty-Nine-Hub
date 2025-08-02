import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:path/path.dart' as path;

class LoadingMethodHelper {
  getSignUrl(
      {required Map<String, dynamic>? data,
        required String url,
        required Function(Map<String, dynamic> data) onSuccess}) async {
    var response = await serviceLocator<ApiConsumer>().put(url,data: data);
    response.fold(
          (l) {},
          (r) async {
            print("rtttttttttt$r");
        onSuccess(r);
      },
    );
  }

  getFileExtension(File file) {
    log("image/${path.extension(file.path).substring(1)}");
    if (file.existsSync()) {
      return "image/${path.extension(file.path).substring(1)}";
    } else {
      return "image/png";
    }
  }

  getFileSize(File file) async {
    final bytes = await file.readAsBytes();
    return bytes.length;
  }

  Future<bool> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
  }) async {
    log(signedUrl, name: "signedUrlsignedUrl");
    Uint8List image = await file.readAsBytes();
    print("objectadsad${image.length}");
    Options options = Options(headers: {
      'Accept': "*/*",
      'Content-Type': 'application/octet-stream','Content-Length': image.length,
      'Connection': 'keep-alive',
      'User-Agent': 'ClinicPlush',
    });

    var response = await Dio().put(signedUrl,
        data: Stream.value(image), options: options);
    print( "response123456 $response");

    return response.statusCode == 200;
  }

  Future<bool> successUploadImage({Map<String, dynamic>? data, required String url}) async {
   var response = await serviceLocator<ApiConsumer>().put(url,data: data);
   print("reessponse$response");
   bool isSuccess = false;
   response.fold(
         (l) {
           print("rtttttttttt11$l");

         },
         (r) async {
       print("rtttttttttt11$r");
       isSuccess= r['data']!=null;
     },
   );
   print("isSuccess$isSuccess");
   return isSuccess;
  }

  uploadDriverImage({
    required XFile driverImage,
    required Function(bool isSuccess) onSuccessUploaded
  }) async {
    getSignUrl(
      data: {
        // "document": {
          "type": await getFileExtension(File(driverImage.path)),
          "size": await getFileSize(File(driverImage.path))
        // }
      },
      url: "${EndPoints.developmentBaseUrl}/truck/driver/request-upload-image",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(driverImage.path),
            signedUrl: data['data']['signedUrl']);
        bool response = await successUploadImage(url: "${EndPoints.developmentBaseUrl}/truck/driver/confirm-upload-image");
        onSuccessUploaded(response);
      },
    );
  }

  Future<bool> uploadDriverId(
      {required XFile idImageInFront,
      required XFile idImageInBehind,
      required String idExpiryDate,
        required Function(bool isSuccess) onSuccessUploaded
      }) async {
    bool isSuccess = false;
    await getSignUrl(
      data: {
        "expireDate": idExpiryDate,
        "idFront": {
          "type": await getFileExtension(File(idImageInFront.path)),
          "size": await getFileSize(File(idImageInFront.path))
        },
        "idBehind": {
          "type": await getFileExtension(File(idImageInBehind.path)),
          "size": await getFileSize(File(idImageInBehind.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/loading/driver/info/id",
      onSuccess: (data) async {
        print("data['data']['idBehindData']['signedUrl']${data['data']['idBehindData']['signedUrl']}");
        await sendBinaryFileData(
            file: XFile(idImageInBehind.path),
            signedUrl: data['data']['idBehindData']['signedUrl'])
            .then(
              (value) async {
                print("valllllue$value");
            print("data['data']['idFrontData']['signedUrl']${data['data']['idFrontData']['signedUrl']}");
            await sendBinaryFileData(
                file: XFile(idImageInFront.path),
                signedUrl: data['data']['idFrontData']['signedUrl'])
                .then(
                  (value) async {
                if(value){
                  bool response = await successUploadImage(data: {
                    "frontMediaId": data['data']['idFrontData']['mediaId'],
                    "behindMediaId": data['data']['idBehindData']['mediaId']
                  }, url: "${EndPoints.developmentBaseUrl}/loading/driver/info/success-upload");
                  isSuccess = response;
                  onSuccessUploaded(isSuccess);
                }else{
                  onSuccessUploaded(false);
                }
              },
            );
          },
        );
      },
    );
    return isSuccess;
  }

  uploadDriverLicense(
      {required XFile drivingImageInFront,
        required XFile drivingImageBehind,
        required String drivingExpiryDate,
        required Function(bool isSuccess) onSuccessUploaded
      }
      ) async {
    await getSignUrl(
      data: {
        "expireDate": drivingExpiryDate,
        "drivingLicenseFront": {
          "type": await getFileExtension(File(drivingImageInFront.path)),
          "size": await getFileSize(File(drivingImageInFront.path))
        },
        "drivingLicenseBehind": {
          "type": await getFileExtension((File(drivingImageBehind.path))),
          "size": await getFileSize(File(drivingImageBehind.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/loading/driver/info/driving-license?subCategory=62c8baad8e28a58a3edf5805",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(File(drivingImageInFront.path).path),
            signedUrl: data['data']['drivingLicenseFrontData']['signedUrl'])
            .then(
              (value) async {
            await sendBinaryFileData(
                file: XFile(drivingImageBehind.path),
                signedUrl: data['data']['drivingLicenseBehindData']
                ['signedUrl'])
                .then(
                  (value) async {
                    if(value){
                      bool response = await successUploadImage(data: {
                        "frontMediaId": data['data']['drivingLicenseFrontData']
                        ['mediaId'],
                        "behindMediaId": data['data']['drivingLicenseBehindData']
                        ['mediaId']
                      }, url: "${EndPoints.developmentBaseUrl}/loading/driver/info/success-upload");
                      onSuccessUploaded(response);
                    }else{
                      onSuccessUploaded(false);
                    }
              },
            );
          },
        );
      },
    );
  }

  confirmIdentity({
    required XFile verifyUserImage,
     Function(bool isSuccess)? onSuccessUploaded
  }) async {
    getSignUrl(
      data: {
        // "expireDate": "2024-5-24",
        "document": {
          "name": "confirmIdentity",
          "type": await getFileExtension(File(verifyUserImage.path)),
          "size": await getFileSize(File(verifyUserImage.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(File(verifyUserImage.path).path),
            signedUrl: data['data']['confirmIdentityData']['signedUrl']);
        bool response = await successUploadImage(
            url:
            "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['confirmIdentityData']['mediaId']}");
        onSuccessUploaded?.call(response); // Safely invoke with null check

      },
    );
  }

  Future<bool> uploadCarLicense({
    required XFile carLicenseFrontImage,
    required XFile carLicenseBehindImage,
    required String licenseExpiryDate,
  required Function(bool isSuccess) onSuccessUploaded
}) async {
    bool isSuccess = false;
    await getSignUrl(
      data: {
        "expireDate": licenseExpiryDate,
        "carLicenseFront": {
          "type": await getFileExtension(File(carLicenseFrontImage.path)),
          "size": await getFileSize(File(carLicenseFrontImage.path))
        },
        "carLicenseBehind": {
          "type": await getFileExtension(File(carLicenseBehindImage.path)),
          "size": await getFileSize(File(carLicenseBehindImage.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/loading/driver/info/car-license",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(carLicenseFrontImage.path),
            signedUrl: data['data']['carLicenseFrontData']['signedUrl'])
            .then(
              (value) async {
            await sendBinaryFileData(
                file: XFile(carLicenseBehindImage.path),
                signedUrl: data['data']['carLicenseBehindData']
                ['signedUrl'])
                .then(
                  (value) async {
                    if(value){
                      bool response = await successUploadImage(data: {
                        "frontMediaId": data['data']['carLicenseFrontData']
                        ['mediaId'],
                        "behindMediaId": data['data']['carLicenseBehindData']
                        ['mediaId']
                      }, url: "${EndPoints.developmentBaseUrl}/loading/driver/info/success-upload");
                      isSuccess = response;
                      onSuccessUploaded(isSuccess);
                      log("isCarLicenseSuccess132 $isSuccess");
                      return isSuccess;
                    }else{
                      onSuccessUploaded(false);
                    }

              },
            );
          },
        );
      },
    );
    log("isCarLicenseSuccess $isSuccess");
    return isSuccess;
  }


  Future<bool> uploadCarImage({
    required XFile carImage,
    required Function(bool isSuccess) onSuccessUploaded
  }) async {
    bool isSuccess = false;

    try {
      await getSignUrl(
        data: {
          "carImage": {
            "type": await getFileExtension(File(carImage.path)),
            "size": await getFileSize(File(carImage.path))
          }
        },
        url: "${EndPoints.developmentBaseUrl}/loading/driver/info/car-images",
        onSuccess: (data) async {
          await sendBinaryFileData(
              file: XFile(carImage.path),
              signedUrl: data['data']['signedUrl']
          ).then((value) async {
            if (value) {
              bool response = await successUploadImage(
                data: {"mediaId": data['data']['mediaId']},
                url: "${EndPoints.developmentBaseUrl}/loading/driver/info/success-car-images",
              );
              isSuccess = response;
              print("isssssSuccess$isSuccess");
              onSuccessUploaded(isSuccess);
            } else {
              onSuccessUploaded(false);
            }
          });
        },
      );

      // Wait for the callback to complete before returning
      await Future.delayed(Duration(milliseconds: 100));
      log("isCarImageSuccess $isSuccess");
      return isSuccess;
    } catch (e) {
      log("Error in uploadCarImage: $e");
      onSuccessUploaded(false);
      return false;
    }
  }
}