import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_images_s3_model/car_image.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_images_s3_model/car_images_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_behind.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_front.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/driving_license_behind.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/driving_license_front.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/drivnig_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/id_behind.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/id_front.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/info_id_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class RegisterRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repo;
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
  List<SubCategory> SELECTED_RICH_VALID_SUBCATEGORY_IDS = [];
  List WOMEN_SUBCATEGORY_IDS = [
    '62ea012a69ea29c91dfc3917',
    '62c8baa08e28a58a3edf57ed',
    '62c8baa38e28a58a3edf57f3'
  ];
  List<SubCategory> SELECTED_WOMEN_SUBCATEGORY_IDS = [];

  RegisterRiderCubit({required this.repo, required this.repository})
      : super(RiderInitial());

  pickCategory(String id) {
    model.subcategoryId = id;
  }

  selectSubCategory({required List<SubCategory> subCategory}) {
    for (var item in subCategory) {
      if (RICH_VALID_SUBCATEGORY_IDS.contains(item.subCategoryId)) {
        SELECTED_WOMEN_SUBCATEGORY_IDS.clear();
        if (!SELECTED_RICH_VALID_SUBCATEGORY_IDS.contains(item)) {
          SELECTED_RICH_VALID_SUBCATEGORY_IDS.add(item);
        }
      } else if (WOMEN_SUBCATEGORY_IDS.contains(item.subCategoryId)) {
        if (!SELECTED_WOMEN_SUBCATEGORY_IDS.contains(item)) {
          SELECTED_WOMEN_SUBCATEGORY_IDS.add(item);
        }
        SELECTED_RICH_VALID_SUBCATEGORY_IDS.clear();
      } else {
        log("noooooooooooooooooooooooooooooo");
      }
    }

    // multiSelectController
    log(SELECTED_RICH_VALID_SUBCATEGORY_IDS.toString(),
        name: "SELECTED_RICH_VALID_SUBCATEGORY_IDS");
    log(SELECTED_WOMEN_SUBCATEGORY_IDS.toString(),
        name: "SELECTED_WOMEN_SUBCATEGORY_IDS");
  }

// const RICH_VALID_SUBCATEGORY_IDS = [
//   CAPTAIN_CATEGORY_ID,
//   PREMIUM_CATEGORY_ID,
//   PICKUP_CATEGORY_ID,
//   SUV_CATEGORY_ID,
//   INTERCITY_CATEGORY_ID,
// ];

// const WOMEN_SUBCATEGORY_IDS = [WOMEN_CATEGORY_ID, INTERCITY_CATEGORY_ID, PREMIUM_CATEGORY_ID];
// const CAPTAIN_CATEGORY_ID = '62c8ba9f8e28a58a3edf57eb';
// const SCOOTER_CATEGORY_ID = '6698736fdaa111da2d775627';
// const WOMEN_CATEGORY_ID = '62ea012a69ea29c91dfc3917';
// const INTERCITY_CATEGORY_ID = '62c8baa08e28a58a3edf57ed';
// const PICKUP_CATEGORY_ID = '62c8baa18e28a58a3edf57ef';
// const SUV_CATEGORY_ID = '62c8baa28e28a58a3edf57f1';
// const PREMIUM_CATEGORY_ID = '62c8baa38e28a58a3edf57f3';
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
    model.vehicleBrand = brand;
  }

  pickModel(String carModel) {
    model.vehicleModel = carModel;
  }

  pickYear(String year) {
    log(year);
    model.vehicleYear = year;
  }

  registerOne() async {
    var response = await repo.registerDriver(model: model);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) async {
        emit(SuccessRegisterRiderState(message: "Success Register"));
        await getCarImagesS3();
        await getS3IdImages();
        await getDrivingLicenseS3();
        await getLicenseS3();
      },
    );
  }

  registerTow(BuildContext context) async {
    var response = await repo.riderRegister(model: model);
    response.fold(
      (l) {
        log(getFailureMessage(l, context), name: "lllllllllllllllll");
        emit(FailureRiderState(failure: l));
      },
      (r) async {
        log(r.toString(), name: "sdkjflskdjf");
        emit(SuccessRegisterRiderState(message: "Success Register"));
        await getCarImagesS3();
        await getS3IdImages();
        await getDrivingLicenseS3();
        await getLicenseS3();
      },
    );
  }

  getS3IdImages() async {
    var response = await repository.getS3IDImages(
      model: InfoIdS3Model(
          expireDate: DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(model.idExpiryDate ?? "")),
          idBehind: IdBehind(
              type: getFileExtension(model.idImageInBehind!),
              size: await getFileSize(model.idImageInBehind!)),
          idFront: IdFront(
              type: getFileExtension(model.idImageInFront!),
              size: await getFileSize(model.idImageInFront!))),
    );
    response.fold(
      (l) {},
      (r) async {
        log(r.toString(),
            name: "lllllllllllllllllllllllllllllllllllllllllllllll");
        await sendBinaryFileData(
            file: XFile(model.idImageInBehind!.path),
            signedUrl: r['data']['idBehindData']['signedUrl']);
        await sendBinaryFileData(
            file: XFile(model.idImageInFront!.path),
            signedUrl: r['data']['idFrontData']['signedUrl']);
        successSendImage(
          endpoint: EndPoints.successUpload,
          data: {
            "frontMediaId": r['data']['idFrontData']['mediaId'],
            "behindMediaId": r['data']['idBehindData']['mediaId']
          },
        );
      },
    );
  }

  getCarImagesS3() async {
    log("123123123123123");
    List<File> listFile = [
      model.carImage!,
    ];
    List<CarImage>? carImagesList = await Future.wait(listFile.map(
      (e) async => CarImage(
        size: await getFileSize(e),
        type: getFileExtension(e),
      ),
    ));
    var response = await repository.getS3CarImages(
      model: CarImagesS3Model(
        updateImageIndex: [1],
        carImages: carImagesList,
      ),
    );
    response.fold(
      (l) {
        log('llllllllllllllja;sdlkfja;slkdjf;aslkdjf;alskdjfa;slkdjf $l');
      },
      (r) async {
        for (var i = 0; i < carImagesList.length; i++) {
          // log(r['data']["$i"].toString(),
          //     name:
          //         "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
          await sendBinaryFileData(
              file: XFile(listFile[i].path),
              signedUrl: r['data']["$i"]['signedUrl']);
          successSendImage(
            endpoint: EndPoints.successCarImages,
            data: {
              "mediaId": r['data']["$i"]['mediaId'],
            },
          );
        }
      },
    );
  }

  getDrivingLicenseS3() async {
    // log(model.drivingImageBehind.toString(),
    //     name: "llllllllllllllllkkkkkkkkkkkkkkkkkkkkkk");
    var response = await repository.getS3DrivingLicense(
      model: DrivnigLicenseS3Model(
          expireDate: DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(model.drvingExpiryDate ?? '')),
          // expireDate: model.idExpiryDate!,
          drivingLicenseBehind: DrivingLicenseBehind(
              type: getFileExtension(model.drivingImageBehind!),
              size: await getFileSize(model.drivingImageBehind!)),
          drivingLicenseFront: DrivingLicenseFront(
              type: getFileExtension(model.drivingImageInFront!),
              size: await getFileSize(model.drivingImageInFront!))),
    );
    response.fold(
      (l) {},
      (r) async {
        log(r.toString(),
            name: "lllllllllllllllllllllllllllllllllllllllllllllll");
        await sendBinaryFileData(
            file: XFile(model.drivingImageBehind!.path),
            signedUrl: r['data']['drivingLicenseBehindData']['signedUrl']);
        await sendBinaryFileData(
            file: XFile(model.drivingImageInFront!.path),
            signedUrl: r['data']['drivingLicenseFrontData']['signedUrl']);
        successSendImage(
          endpoint: EndPoints.successUpload,
          data: {
            "frontMediaId": r['data']['drivingLicenseFrontData']['mediaId'],
            "behindMediaId": r['data']['drivingLicenseBehindData']['mediaId']
          },
        );
      },
    );
  }

  getLicenseS3() async {
    var response = await repository.getS3CarLicense(
      model: CarLicenseS3Model(
          expireDate: DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(model.licenseExpiryDate ?? "")),
          carLicenseBehind: CarLicenseBehind(
              type: getFileExtension(model.licenseImageInFront!),
              size: await getFileSize(model.licenseImgeBehind!)),
          carLicenseFront: CarLicenseFront(
              type: getFileExtension(model.licenseImageInFront!),
              size: await getFileSize(model.licenseImageInFront!))),
    );
    response.fold(
      (l) {},
      (r) async {
        log(r.toString(),
            name: "lllllllllllllllllllllllllllllllllllllllllllllll");
        await sendBinaryFileData(
            file: XFile(model.licenseImgeBehind!.path),
            signedUrl: r['data']['carLicenseBehindData']['signedUrl']);
        await sendBinaryFileData(
            file: XFile(model.licenseImageInFront!.path),
            signedUrl: r['data']['carLicenseFrontData']['signedUrl']);
        successSendImage(
          endpoint: EndPoints.successUpload,
          data: {
            "frontMediaId": r['data']['carLicenseFrontData']['mediaId'],
            "behindMediaId": r['data']['carLicenseBehindData']['mediaId']
          },
        );
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
    Uint8List image = await file.readAsBytes();
    String fileName = file.path.split('/').last;
    log(image.length.toString(), name: 'signedUrlll');
    log(signedUrl.toString(), name: 'signedUrlll');

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

  successSendImage(
      {required String endpoint, Map<String, dynamic>? data}) async {
    var resposne =
        await serviceLocator<ApiConsumer>().put(endpoint, data: data);
    // log(resposne.toString(),
    //     name:` "suuuuuuuuuuuuuuuuuuuuuuccccccccccccccccccessssssssssssssssss");
    resposne.fold(
      (l) {
        log(l.toString(), name: "failuerRequest");
      },
      (r) {
        log(r.toString(), name: "successRequest");
      },
    );
  }
}
