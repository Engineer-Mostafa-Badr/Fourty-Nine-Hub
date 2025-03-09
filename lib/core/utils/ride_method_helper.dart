import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:path/path.dart' as path;

class RideMethodHelper {
  getSignUrl(
      {required Map<String, dynamic>? data,
        required String url,
        required Function(Map<String, dynamic> data) onSuccess}) async {
    var response = await serviceLocator<ApiConsumer>().put(url,data: data);
    response.fold(
          (l) {},
          (r) async {
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

  Future<void> sendBinaryFileData({
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
    log(response.data.toString(), name: "uploadImage");
    log(response.extra.toString(), name: "uploadImage");
    log(response.statusCode.toString(), name: "uploadImage");
  }

  successUploadImage({Map<String, dynamic>? data, required String url}) async {
    await serviceLocator<ApiConsumer>().put(url,data: data);
  }

  uploadDriverId(
      {required XFile idImageInFront,
      required XFile idImageInBehind,
      required String idExpiryDate}) async {
    getSignUrl(
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
      url: "${EndPoints.developmentBaseUrl}/ride/info/id",
      onSuccess: (data) async {
        print("data['data']['idBehindData']['signedUrl']${data['data']['idBehindData']['signedUrl']}");
        await sendBinaryFileData(
            file: XFile(idImageInBehind.path),
            signedUrl: data['data']['idBehindData']['signedUrl'])
            .then(
              (value) async {
            print("data['data']['idFrontData']['signedUrl']${data['data']['idFrontData']['signedUrl']}");
            await sendBinaryFileData(
                file: XFile(idImageInFront.path),
                signedUrl: data['data']['idFrontData']['signedUrl'])
                .then(
                  (value) async {
                await successUploadImage(data: {
                  "frontMediaId": data['data']['idFrontData']['mediaId'],
                  "behindMediaId": data['data']['idBehindData']['mediaId']
                }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-upload");
              },
            );
          },
        );
      },
    );
  }

  uploadDriverImage({
    required XFile driverImage,
  }) async {
    getSignUrl(
      data: {
        "document": {
          "type": await getFileExtension(File(driverImage.path)),
          "size": await getFileSize(File(driverImage.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/driver-picture",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(driverImage.path),
            signedUrl: data['data']['undefinedData']['signedUrl']);
        await successUploadImage(data: {
          "mediaId": data['data']['undefinedData']['mediaId'],
          "type": "Ride" // Loading or Ride
        }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-driver-picture");
      },
    );
  }

  uploadDriverLicense(
      {required XFile drivingImageInFront,
        required XFile drivingImageBehind,
        required String drivingExpiryDate}
      ) async {
    getSignUrl(
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
      url: "${EndPoints.developmentBaseUrl}/ride/info/driving-license",
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
                await successUploadImage(data: {
                  "frontMediaId": data['data']['drivingLicenseFrontData']
                  ['mediaId'],
                  "behindMediaId": data['data']['drivingLicenseBehindData']
                  ['mediaId']
                }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-upload");
              },
            );
          },
        );
      },
    );
  }

  confirmIdentity({
    required XFile verifyUserImage,
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
        await successUploadImage(
            url:
            "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['confirmIdentityData']['mediaId']}");
      },
    );
  }

  uploadCarLicense({
    required XFile carLicenseFrontImage,
    required XFile carLicenseBehindImage,
    required String licenseExpiryDate
}) async {
    getSignUrl(
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
      url: "${EndPoints.developmentBaseUrl}/ride/info/car-license",
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
                await successUploadImage(data: {
                  "frontMediaId": data['data']['carLicenseFrontData']
                  ['mediaId'],
                  "behindMediaId": data['data']['carLicenseBehindData']
                  ['mediaId']
                }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-upload");
              },
            );
          },
        );
      },
    );
  }


  uploadCarImage({
    required XFile carImage,
}) async {
    getSignUrl(
      data: {
        "updateImageIndex": [1],
        "carImages": [
          {
            "type": await getFileExtension(File(carImage.path)),
            "size": await getFileSize(File(carImage.path))
          }
        ]
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/car-images",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(carImage.path),
            signedUrl: data['data'][0]['signedUrl']).then((value) async {
          await successUploadImage(
          data: {"mediaId": data['data'][0]['mediaId']},
          url: "${EndPoints.developmentBaseUrl}/ride/info/success-car-images",
          );
        });

        log("criminalRecordData");
      },
    );
  }

  uploadDrugAnalysis({
    required XFile dragAnalysis,
    required String dragAnalysisDate
  }) async {
    getSignUrl(
      data: {
        "expireDate": dragAnalysisDate,
        "document": {
          "name": "drugAnalysis",
          "type": await getFileExtension(File(dragAnalysis.path)),
          "size": await getFileSize(File(dragAnalysis.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(dragAnalysis.path),
            signedUrl: data['data']['drugAnalysisData']['signedUrl']);
        await successUploadImage(
            url:
            "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['drugAnalysisData']['mediaId']}");
        log("drugAnalysisData");
      },
    );
  }

  uploadTechnicalExamination({
    required XFile technicalExaminationImage,
    required String technicalExaminationDate
  }) async {
    getSignUrl(
      data: {
        "expireDate": technicalExaminationDate,
        "document": {
          "name": "technicalExamination",
          "type": await getFileExtension(File(technicalExaminationImage.path)),
          "size": await getFileSize(File(technicalExaminationImage.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(technicalExaminationImage.path),
            signedUrl: data['data']['technicalExaminationData']['signedUrl']);
        await successUploadImage(
            url:
            "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['technicalExaminationData']['mediaId']}");
        log("technicalExaminationData");
      },
    );
  }

  uploadCriminalRecord({
    required XFile criminalRecordImage,
    required String criminalRecordDate
  }) async {
    getSignUrl(
      data: {
        "expireDate": criminalRecordDate,
        "document": {
          "name": "criminalRecord",
          "type": await getFileExtension(File(criminalRecordImage.path)),
          "size": await getFileSize(File(criminalRecordImage.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(criminalRecordImage.path),
            signedUrl: data['data']['criminalRecordData']['signedUrl']);
        await successUploadImage(
            url:
            "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['criminalRecordData']['mediaId']}");
        log("criminalRecordData");
      },
    );
  }


}