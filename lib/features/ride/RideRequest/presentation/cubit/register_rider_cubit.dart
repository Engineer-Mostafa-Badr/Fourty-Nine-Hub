import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class RegisterRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repo;
  GlobalKey<FormState> socketFormKey = GlobalKey();
  final ShippingRepository repository;
  RiderRegisterModel model = RiderRegisterModel();
  MultiSelectController<SubCategory> multiSelectController =
      MultiSelectController<SubCategory>([]);
  List RICH_VALID_SUBCATEGORY_IDS = [
    '62c8ba9f8e28a58a3edf57eb',
    '62c8baa08e28a58a3edf57ed',
    '62c8baa18e28a58a3edf57ef',
    '62c8baa28e28a58a3edf57f1',
    '62c8baa38e28a58a3edf57f3'
  ];

  List WOMEN_SUBCATEGORY_IDS = [
    '62ea012a69ea29c91dfc3917',
    '62c8baa08e28a58a3edf57ed',
    '62c8baa38e28a58a3edf57f3'
  ];
  List<String> NO_SOCKET_SUBCATEGORY_IDS = [
    "62c8baa48e28a58a3edf57f5",
    "62c8baa78e28a58a3edf57f9",
    "62c8baa88e28a58a3edf57fd",
    "62c8baaa8e28a58a3edf57ff",
    "62c8baab8e28a58a3edf5801",
    "62c8baa68e28a58a3edf57f7",
  ];
  List<String> SOCKET_CATEGORY_IDS = [
    "62c8ba9e8e28a58a3edf57e9",
    "6698736fdaa111da2d775627"
  ];
  List<SubCategory> SELECTED_RICH_VALID_SUBCATEGORY_IDS = [];
  List<SubCategory> SELECTED_WOMEN_SUBCATEGORY_IDS = [];
  List<SubCategory> SELECTED_NO_SOCKET_SUBCATEGORY_IDS = [];
  List<SubCategory> SELECTED_SOCKET_CATEGORY_IDS = [];
  List<SubCategory> selectedSubCategoryList = [];
  SubCategory? selectedSubCategoryNoSocket;

  RegisterRiderCubit({required this.repo, required this.repository})
      : super(RiderInitial());

  pickCategory(String id) {
    model.subcategoryId = id;
  }

  selectSubCategory({required SubCategory subCategory}) {
    if (subCategory.subCategoryId == "62c8baa08e28a58a3edf57ed" ||
        subCategory.subCategoryId == "62c8baa38e28a58a3edf57f3") {
      if (SELECTED_WOMEN_SUBCATEGORY_IDS.isNotEmpty) {
        if (SELECTED_WOMEN_SUBCATEGORY_IDS.contains(subCategory)) {
          SELECTED_WOMEN_SUBCATEGORY_IDS.remove(subCategory);
        } else {
          SELECTED_WOMEN_SUBCATEGORY_IDS.add(subCategory);
        }
      } else {
        if (SELECTED_RICH_VALID_SUBCATEGORY_IDS.contains(subCategory)) {
          SELECTED_RICH_VALID_SUBCATEGORY_IDS.remove(subCategory);
        } else {
          SELECTED_RICH_VALID_SUBCATEGORY_IDS.add(subCategory);
        }
      }
    } else {
      if (RICH_VALID_SUBCATEGORY_IDS.contains(subCategory.subCategoryId)) {
        log("RICH_VALID_SUBCATEGORY_IDS");
        SELECTED_WOMEN_SUBCATEGORY_IDS.clear();
        SELECTED_NO_SOCKET_SUBCATEGORY_IDS.clear();
        SELECTED_SOCKET_CATEGORY_IDS.clear();
        if (SELECTED_RICH_VALID_SUBCATEGORY_IDS.contains(subCategory)) {
          log("remove");
          SELECTED_RICH_VALID_SUBCATEGORY_IDS.remove(subCategory);
        } else {
          log("add");
          SELECTED_RICH_VALID_SUBCATEGORY_IDS.add(subCategory);
        }
      } else if (WOMEN_SUBCATEGORY_IDS.contains(subCategory.subCategoryId)) {
        log("WOMEN_SUBCATEGORY_IDS");
        SELECTED_NO_SOCKET_SUBCATEGORY_IDS.clear();
        SELECTED_RICH_VALID_SUBCATEGORY_IDS.clear();
        SELECTED_SOCKET_CATEGORY_IDS.clear();
        if (SELECTED_WOMEN_SUBCATEGORY_IDS.contains(subCategory)) {
          SELECTED_WOMEN_SUBCATEGORY_IDS.remove(subCategory);
        } else {
          SELECTED_WOMEN_SUBCATEGORY_IDS.add(subCategory);
        }
      } else if (SOCKET_CATEGORY_IDS.contains(subCategory.subCategoryId)) {
        log("SOCKET_CATEGORY_IDS");
        SELECTED_NO_SOCKET_SUBCATEGORY_IDS.clear();
        SELECTED_RICH_VALID_SUBCATEGORY_IDS.clear();
        SELECTED_SOCKET_CATEGORY_IDS.clear();
        if (SELECTED_SOCKET_CATEGORY_IDS.contains(subCategory)) {
          SELECTED_SOCKET_CATEGORY_IDS.clear();
        } else {
          SELECTED_SOCKET_CATEGORY_IDS = [subCategory];
        }
      } else {
        log("SELECTED_NO_SOCKET_SUBCATEGORY_IDS",
            name: subCategory.subCategoryId.toString());
        SELECTED_RICH_VALID_SUBCATEGORY_IDS.clear();
        SELECTED_WOMEN_SUBCATEGORY_IDS.clear();
        SELECTED_SOCKET_CATEGORY_IDS.clear();
        if (SELECTED_NO_SOCKET_SUBCATEGORY_IDS.contains(subCategory)) {
          SELECTED_NO_SOCKET_SUBCATEGORY_IDS.remove(subCategory);
        } else {
          SELECTED_NO_SOCKET_SUBCATEGORY_IDS = [subCategory];
        }
      }
    }
    if (SELECTED_WOMEN_SUBCATEGORY_IDS.isNotEmpty) {
      selectedSubCategoryList = SELECTED_WOMEN_SUBCATEGORY_IDS;
    }
    if (SELECTED_RICH_VALID_SUBCATEGORY_IDS.isNotEmpty) {
      selectedSubCategoryList = SELECTED_RICH_VALID_SUBCATEGORY_IDS;
    }
    if (SELECTED_NO_SOCKET_SUBCATEGORY_IDS.isNotEmpty) {
      selectedSubCategoryList = SELECTED_NO_SOCKET_SUBCATEGORY_IDS;
    }
    if (SELECTED_SOCKET_CATEGORY_IDS.isNotEmpty) {
      selectedSubCategoryList = SELECTED_SOCKET_CATEGORY_IDS;
    }
    log(selectedSubCategoryList.toString(),
        name: "SELECTED_RICH_VALID_SUBCATEGORY_IDS");
  }

  String? validation({required String message, required bool condition}) {
    if (condition) {
      return message;
    }
    return null;
  }

  pickSmoker(bool value) {
    model.smoker = value;
  }

  pickAirCondition(bool value) {
    model.airCondition = value;
  }

  pickImageCar(File image) {
    model.carImage = image;
  }

  pickDrivingInFrontImage(File image) {
    model.drivingImageInFront = image;
  }

  pickDrivingBehindImage(File image) {
    model.drivingImageBehind = image;
  }

  pickLicenseInFrontImage(File image) {
    model.licenseImageInFront = image;
  }

  pickLicenseBehindImage(File image) {
    model.licenseImgeBehind = image;
  }

  pickIdInFrontImage(File image) {
    model.idImageInFront = image;
  }

  pickIdBehindImage(File image) {
    model.idImageInBehind = image;
  }

  pickIdExpiryDate(DateTime date) {
    model.idExpiryDate = date.toString();
  }

  pickDrivingExpiryDate(DateTime date) {
    model.drvingExpiryDate = date.toString();
  }

  pickLicenseExpiryDate(DateTime date) {
    model.licenseExpiryDate = date.toString();
  }

  pickBrand(String brand) {
    log(brand);
    model.vehicleBrand = brand;
  }

  pickModel(String carModel) {
    log(carModel);
    model.vehicleModel = carModel;
  }

  pickYear(String year) {
    log(year);
    model.vehicleYear = year;
  }

  pickUserImage({required File image}) {
    model.driverImage = image;
    print();
  }

  pickFirstName({required String name}) {
    log(name.toString());
    model.driverFirstName = name;
    log(model.driverFirstName.toString(), name: "lsdkjflskdjflskdjf");
  }

  pickLastName({required String name}) {
    model.driverLastName = name;
  }

  pickBirthDate({required DateTime date}) {
    model.birthDate = date;
  }

  pickPhone({required String phone}) {
    model.phone = phone;
  }

  pickIdNumberDriver({required String idNumber}) {
    model.idNumber = idNumber;
  }

  pickEndDateDriverLicense({required DateTime date}) {
    model.idExpiryDate = date.toString();
  }

  pickVerifyUserImage({required File image}) {
    model.verfiyUserImage = image;
  }

  pickFrontCarLicenseImage({required File image}) {
    model.carLicenseFrontImage = image;
  }

  pickBehindCarLicenseImage({required File image}) {
    model.carLicenseBehindImage = image;
  }

  pickWorkType({required String value}) {
    model.workingType = value;
  }

  pickPlateInfo({required String value}) {
    model.plateInfo = value;
  }

  print() {
    log(model.driverImage.toString());
  }

  registerOne() async {
    model.subcategoryIds =
        selectedSubCategoryList.map((e) => e.subCategoryId ?? '').toList();
    log(model.subcategoryId.toString(), name: "lsdjflsdjflsdjflsdjflsjdfldjf");
    var response = await repo.registerDriver(model: model);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) async {
        emit(SuccessRegisterRiderState(message: "Success Register"));
        await uploadImages();
      },
    );
  }

  registerTow(BuildContext context) async {
    log("message");
    model.subcategoryId = selectedSubCategoryList.first.subCategoryId ?? "";
    var response = await repo.riderRegister(model: model);
    response.fold(
      (l) {
        log(getFailureMessage(l, context), name: "lllllllllllllllll");
        emit(FailureRiderState(failure: l));
      },
      (r) async {
        emit(SuccessRegisterRiderState(message: "Success Register"));
        uploadImages();
      },
    );
  }

  uploadImages() async {
    await uploadDriverImage();
    await uploadDriverLicense();
    await uploadDriverId();
    await uploadVerifyImage();
    
    await uploadCarLicnse();
    await uploadCarImage();
    await uploadDrugAnalysis();
    await uploadTechnicalExamination();
    await uploadCriminalRecord();
  }

  getSignUrl(
      {required Map<String, dynamic>? data,
      required String url,
      required Function(Map<String, dynamic> data) ifRight}) async {
    var response = await repo.getSignUrl(data: data, url: url);
    response.fold(
      (l) {},
      (r) async {
        ifRight(r);
      },
    );
  }

  successUploadImage({Map<String, dynamic>? data, required String url}) async {
    var response = await repo.successUpload(data: data, url: url);
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

    Options options = Options(contentType: file.mimeType, headers: {
      'Accept': "*/*",
      'Content-Type': 'application/octet-stream',
      'Content-Length': image.length,
      'Connection': 'keep-alive',
      'User-Agent': 'ClinicPlush',
      // 'File-Name': fileName,
    });

    var response = await Dio().put(signedUrl,
        data: Stream.fromIterable(image.map((e) => [e])), options: options);
    log(response.data.toString(), name: "uploadImage");
    log(response.statusCode.toString(), name: "uploadImage");
  }

  uploadDriverImage({requi}) async {
    getSignUrl(
      data: {
        "document": {
          "type": await getFileExtension(model.driverImage!),
          "size": await getFileSize(model.driverImage!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/driver-picture",
      ifRight: (data) async {
        await sendBinaryFileData(
            file: XFile(model.driverImage!.path),
            signedUrl: data['data']['undefinedData']['signedUrl']);
        await successUploadImage(data: {
          "mediaId": data['data']['undefinedData']['mediaId'],
          "type": "Ride" // Loading or Ride
        }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-driver-picture");
      },
    );
  }

  uploadDriverLicense() async {
    getSignUrl(
      data: {
        "expireDate": model.drvingExpiryDate,
        "drivingLicenseFront": {
          "type": await getFileExtension(model.drivingImageInFront!),
          "size": await getFileSize(model.drivingImageInFront!)
        },
        "drivingLicenseBehind": {
          "type": await getFileExtension(model.drivingImageBehind!),
          "size": await getFileSize(model.drivingImageInFront!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/driving-license",
      ifRight: (data) async {
        await sendBinaryFileData(
                file: XFile(model.drivingImageInFront!.path),
                signedUrl: data['data']['drivingLicenseFrontData']['signedUrl'])
            .then(
          (value) async {
            await sendBinaryFileData(
                    file: XFile(model.drivingImageBehind!.path),
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

  uploadDriverId() async {
    getSignUrl(
      data: {
        "expireDate": model.idExpiryDate,
        "idFront": {
          "type": await getFileExtension(model.idImageInFront!),
          "size": await getFileSize(model.idImageInFront!)
        },
        "idBehind": {
          "type": await getFileExtension(model.idImageInBehind!),
          "size": await getFileSize(model.idImageInBehind!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/id",
      ifRight: (data) async {
        await sendBinaryFileData(
                file: XFile(model.idImageInFront!.path),
                signedUrl: data['data']['idBehindData']['signedUrl'])
            .then(
          (value) async {
            await sendBinaryFileData(
                    file: XFile(model.idImageInBehind!.path),
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

  uploadVerifyImage({requi}) async {
    getSignUrl(
      data: {
        // "expireDate": "2024-5-24",
        "document": {
          "name": "confirmIdentity",
          "type": await getFileExtension(model.verfiyUserImage!),
          "size": await getFileSize(model.verfiyUserImage!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      ifRight: (data) async {
        await sendBinaryFileData(
            file: XFile(model.verfiyUserImage!.path),
            signedUrl: data['data']['confirmIdentityData']['signedUrl']);
        await successUploadImage(
            url:
                "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['confirmIdentityData']['mediaId']}");
      },
    );
  }

  uploadDrugAnalysis({requi}) async {
    getSignUrl(
      data: {
        "expireDate": model.dragAnalysisDate,
        "document": {
          "name": "drugAnalysis",
          "type": await getFileExtension(model.dragAnalysis!),
          "size": await getFileSize(model.dragAnalysis!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      ifRight: (data) async {
        await sendBinaryFileData(
            file: XFile(model.dragAnalysis!.path),
            signedUrl: data['data']['drugAnalysisData']['signedUrl']);
        await successUploadImage(
            url:
                "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['drugAnalysisData']['mediaId']}");
        log("drugAnalysisData");
      },
    );
  }

  uploadTechnicalExamination({requi}) async {
    getSignUrl(
      data: {
        "expireDate": model.technicalExaminationDate,
        "document": {
          "name": "technicalExamination",
          "type": await getFileExtension(model.technicalExaminationImage!),
          "size": await getFileSize(model.technicalExaminationImage!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      ifRight: (data) async {
        await sendBinaryFileData(
            file: XFile(model.technicalExaminationImage!.path),
            signedUrl: data['data']['technicalExaminationData']['signedUrl']);
        await successUploadImage(
            url:
                "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['technicalExaminationData']['mediaId']}");
        log("technicalExaminationData");
      },
    );
  }

  uploadCriminalRecord({requi}) async {
    getSignUrl(
      data: {
        "expireDate": model.criminalRecordDate,
        "document": {
          "name": "criminalRecord",
          "type": await getFileExtension(model.criminalRecordImage!),
          "size": await getFileSize(model.criminalRecordImage!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/documents",
      ifRight: (data) async {
        await sendBinaryFileData(
            file: XFile(model.criminalRecordImage!.path),
            signedUrl: data['data']['criminalRecordData']['signedUrl']);
        await successUploadImage(
            url:
                "${EndPoints.developmentBaseUrl}/ride/info/documents/${data['data']['criminalRecordData']['mediaId']}");
        log("criminalRecordData");
      },
    );
  }

  uploadCarLicnse() async {
    getSignUrl(
      data: {
        "expireDate": model.licenseExpiryDate,
        "carLicenseFront": {
          "type": await getFileExtension(model.carLicenseFrontImage!),
          "size": await getFileSize(model.carLicenseFrontImage!)
        },
        "carLicenseBehind": {
          "type": await getFileExtension(model.carLicenseBehindImage!),
          "size": await getFileSize(model.carLicenseBehindImage!)
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/car-license",
      ifRight: (data) async {
        await sendBinaryFileData(
                file: XFile(model.carLicenseFrontImage!.path),
                signedUrl: data['data']['carLicenseFrontData']['signedUrl'])
            .then(
          (value) async {
            await sendBinaryFileData(
                    file: XFile(model.carLicenseBehindImage!.path),
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

  uploadCarImage() async {
    getSignUrl(
      data: {
        "updateImageIndex": [1],
        "carImages": [
          {
            "type": await getFileExtension(model.carImage!),
            "size": await getFileSize(model.carImage!)
          }
        ]
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/car-images",
      ifRight: (data) async {
        await sendBinaryFileData(
            file: XFile(model.carImage!.path),
            signedUrl: data['data'][0]['signedUrl']);
        await successUploadImage(
          data: {"mediaId": data['data'][0]['mediaId']},
          url: "${EndPoints.developmentBaseUrl}/ride/info/success-car-images",
        );
        log("criminalRecordData");
      },
    );
  }

  // getSigninUrl({required String url, required Map<String, dynamic> data}){
  //   var response = await repo.getSignUrl(data: data, url: url);
  // }

  // getS3IdImages() async {
  //   var response = await repository.getS3IDImages(
  //     model: InfoIdS3Model(
  //         expireDate: DateFormat("yyyy-MM-dd")
  //             .format(DateTime.parse(model.idExpiryDate ?? "")),
  //         idBehind: IdBehind(
  //             type: getFileExtension(model.idImageInBehind!),
  //             size: await getFileSize(model.idImageInBehind!)),
  //         idFront: IdFront(
  //             type: getFileExtension(model.idImageInFront!),
  //             size: await getFileSize(model.idImageInFront!))),
  //   );
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       log(r.toString(),
  //           name: "lllllllllllllllllllllllllllllllllllllllllllllll");
  //       await sendBinaryFileData(
  //           file: XFile(model.idImageInBehind!.path),
  //           signedUrl: r['data']['idBehindData']['signedUrl']);
  //       await sendBinaryFileData(
  //           file: XFile(model.idImageInFront!.path),
  //           signedUrl: r['data']['idFrontData']['signedUrl']);
  //       successSendImage(
  //         endpoint: EndPoints.successUpload,
  //         data: {
  //           "frontMediaId": r['data']['idFrontData']['mediaId'],
  //           "behindMediaId": r['data']['idBehindData']['mediaId']
  //         },
  //       );
  //     },
  //   );
  // }

  // getCarImagesS3() async {
  //   log("123123123123123");
  //   List<File> listFile = [
  //     model.carImage!,
  //   ];
  //   List<CarImage>? carImagesList = await Future.wait(listFile.map(
  //     (e) async => CarImage(
  //       size: await getFileSize(e),
  //       type: getFileExtension(e),
  //     ),
  //   ));
  //   var response = await repository.getS3CarImages(
  //     model: CarImagesS3Model(
  //       updateImageIndex: [1],
  //       carImages: carImagesList,
  //     ),
  //   );
  //   response.fold(
  //     (l) {
  //       log('llllllllllllllja;sdlkfja;slkdjf;aslkdjf;alskdjfa;slkdjf $l');
  //     },
  //     (r) async {
  //       for (var i = 0; i < carImagesList.length; i++) {
  //         // log(r['data']["$i"].toString(),
  //         //     name:
  //         //         "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
  //         await sendBinaryFileData(
  //             file: XFile(listFile[i].path),
  //             signedUrl: r['data']["$i"]['signedUrl']);
  //         successSendImage(
  //           endpoint: EndPoints.successCarImages,
  //           data: {
  //             "mediaId": r['data']["$i"]['mediaId'],
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  // getDrivingLicenseS3() async {
  //   // log(model.drivingImageBehind.toString(),
  //   //     name: "llllllllllllllllkkkkkkkkkkkkkkkkkkkkkk");
  //   var response = await repository.getS3DrivingLicense(
  //     model: DrivnigLicenseS3Model(
  //         expireDate: DateFormat("yyyy-MM-dd")
  //             .format(DateTime.parse(model.drvingExpiryDate ?? '')),
  //         // expireDate: model.idExpiryDate!,
  //         drivingLicenseBehind: DrivingLicenseBehind(
  //             type: getFileExtension(model.drivingImageBehind!),
  //             size: await getFileSize(model.drivingImageBehind!)),
  //         drivingLicenseFront: DrivingLicenseFront(
  //             type: getFileExtension(model.drivingImageInFront!),
  //             size: await getFileSize(model.drivingImageInFront!))),
  //   );
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       log(r.toString(),
  //           name: "lllllllllllllllllllllllllllllllllllllllllllllll");
  //       await sendBinaryFileData(
  //           file: XFile(model.drivingImageBehind!.path),
  //           signedUrl: r['data']['drivingLicenseBehindData']['signedUrl']);
  //       await sendBinaryFileData(
  //           file: XFile(model.drivingImageInFront!.path),
  //           signedUrl: r['data']['drivingLicenseFrontData']['signedUrl']);
  //       successSendImage(
  //         endpoint: EndPoints.successUpload,
  //         data: {
  //           "frontMediaId": r['data']['drivingLicenseFrontData']['mediaId'],
  //           "behindMediaId": r['data']['drivingLicenseBehindData']['mediaId']
  //         },
  //       );
  //     },
  //   );
  // }

  // getLicenseS3() async {
  //   var response = await repository.getS3CarLicense(
  //     model: CarLicenseS3Model(
  //         expireDate: DateFormat("yyyy-MM-dd")
  //             .format(DateTime.parse(model.licenseExpiryDate ?? "")),
  //         carLicenseBehind: CarLicenseBehind(
  //             type: getFileExtension(model.licenseImageInFront!),
  //             size: await getFileSize(model.licenseImgeBehind!)),
  //         carLicenseFront: CarLicenseFront(
  //             type: getFileExtension(model.licenseImageInFront!),
  //             size: await getFileSize(model.licenseImageInFront!))),
  //   );
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       log(r.toString(),
  //           name: "lllllllllllllllllllllllllllllllllllllllllllllll");
  //       await sendBinaryFileData(
  //           file: XFile(model.licenseImgeBehind!.path),
  //           signedUrl: r['data']['carLicenseBehindData']['signedUrl']);
  //       await sendBinaryFileData(
  //           file: XFile(model.licenseImageInFront!.path),
  //           signedUrl: r['data']['carLicenseFrontData']['signedUrl']);
  //       successSendImage(
  //         endpoint: EndPoints.successUpload,
  //         data: {
  //           "frontMediaId": r['data']['carLicenseFrontData']['mediaId'],
  //           "behindMediaId": r['data']['carLicenseBehindData']['mediaId']
  //         },
  //       );
  //     },
  //   );
  // }

  // successSendImage(
  //     {required String endpoint, Map<String, dynamic>? data}) async {
  //   var resposne =
  //       await serviceLocator<ApiConsumer>().put(endpoint, data: data);
  //   // log(resposne.toString(),
  //   //     name:` "suuuuuuuuuuuuuuuuuuuuuuccccccccccccccccccessssssssssssssssss");
  //   resposne.fold(
  //     (l) {
  //       log(l.toString(), name: "failuerRequest");
  //     },
  //     (r) {
  //       log(r.toString(), name: "successRequest");
  //     },
  //   );
  // }

  //DriverLicense
  // uploadBehindDriverLicense() async {
  //   var response = await repo.getSignUrl(data: {
  //     "document": {
  //       "type": await getFileExtension(model.driverImage!),
  //       "size": await getFileSize(model.driverImage!)
  //     }
  //   }, url: "${EndPoints.developmentBaseUrl}/ride/info/driver-picture");
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       await sendBinaryFileData(
  //           file: XFile(model.driverImage!.path),
  //           signedUrl: r['data']['undefinedData']['signedUrl']);
  //       successBehindDriverLicense(data: {
  //         "mediaId": r['data']['undefinedData']['mediaId'],
  //         "type": "Ride"
  //       }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-driver-picture");
  //     },
  //   );
  // }

  // successBehindDriverLicense(
  //     {required Map<String, dynamic>? data, required String url}) async {
  //   var response = await repo.successUpload(data: data, url: url);
  // }

  // uploadFrontDriverLicense() async {
  //   var response = await repo.getSignUrl(data: {
  //     "document": {
  //       "type": await getFileExtension(model.driverImage!),
  //       "size": await getFileSize(model.driverImage!)
  //     }
  //   }, url: "${EndPoints.developmentBaseUrl}/ride/info/driver-picture");
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       await sendBinaryFileData(
  //           file: XFile(model.driverImage!.path),
  //           signedUrl: r['data']['undefinedData']['signedUrl']);
  //       successFrontDriverLicense(data: {
  //         "mediaId": r['data']['undefinedData']['mediaId'],
  //         "type": "Ride"
  //       }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-driver-picture");
  //     },
  //   );
  // }

  // successFrontDriverLicense(
  //     {required Map<String, dynamic>? data, required String url}) async {
  //   var response = await repo.successUpload(data: data, url: url);
  // }

  // //Driver Image
  // uploadDriverImage() async {
  //   var response = await repo.getSignUrl(data: {
  //     "document": {
  //       "type": await getFileExtension(model.driverImage!),
  //       "size": await getFileSize(model.driverImage!)
  //     }
  //   }, url: "${EndPoints.developmentBaseUrl}/ride/info/driver-picture");
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       await sendBinaryFileData(
  //           file: XFile(model.driverImage!.path),
  //           signedUrl: r['data']['undefinedData']['signedUrl']);
  //       successUploadDriverImage(data: {
  //         "mediaId": r['data']['undefinedData']['mediaId'],
  //         "type": "Ride"
  //       }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-driver-picture");
  //     },
  //   );
  // }

  // successUploadDriverImage(
  //     {required Map<String, dynamic>? data, required String url}) async {
  //   var response = await repo.successUpload(data: data, url: url);
  // }

  // //Id Driver
  // uploadBehindIdImage() async {
  //   var response = await repo.getSignUrl(data: {
  //     "document": {
  //       "type": await getFileExtension(model.driverImage!),
  //       "size": await getFileSize(model.driverImage!)
  //     }
  //   }, url: "${EndPoints.developmentBaseUrl}/ride/info/driver-picture");
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       await sendBinaryFileData(
  //           file: XFile(model.driverImage!.path),
  //           signedUrl: r['data']['undefinedData']['signedUrl']);
  //       successBehindIdImage(data: {
  //         "mediaId": r['data']['undefinedData']['mediaId'],
  //         "type": "Ride"
  //       }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-driver-picture");
  //     },
  //   );
  // }

  // successBehindIdImage(
  //     {required Map<String, dynamic>? data, required String url}) async {
  //   var response = await repo.successUpload(data: data, url: url);
  // }

  // uploadFrontIdImage() async {
  //   var response = await repo.getSignUrl(data: {
  //     "document": {
  //       "type": await getFileExtension(model.driverImage!),
  //       "size": await getFileSize(model.driverImage!)
  //     }
  //   }, url: "${EndPoints.developmentBaseUrl}/ride/info/driver-picture");
  //   response.fold(
  //     (l) {},
  //     (r) async {
  //       await sendBinaryFileData(
  //           file: XFile(model.driverImage!.path),
  //           signedUrl: r['data']['undefinedData']['signedUrl']);
  //       successFrontDriverLicense(data: {
  //         "mediaId": r['data']['undefinedData']['mediaId'],
  //         "type": "Ride"
  //       }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-driver-picture");
  //     },
  //   );
  // }

  // successFrontIdImage(
  //     {required Map<String, dynamic>? data, required String url}) async {
  //   var response = await repo.successUpload(data: data, url: url);
  // }

  //verify Image
}
