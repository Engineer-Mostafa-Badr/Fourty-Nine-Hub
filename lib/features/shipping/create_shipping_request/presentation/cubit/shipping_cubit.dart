import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_images_s3_model/car_image.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_images_s3_model/car_images_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_behind.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_front.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/car_license_s3_model/car_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/driving_license_behind.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/driving_license_front.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/drivnig_license_s3_model/drivnig_license_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_documents_model/document.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_documents_model/info_documents_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/id_behind.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/id_front.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/info_id_s3_model/info_id_s3_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/images_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class ShippingCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  final ImagesRepository imageRepository;
  ShippingCubit({required this.repository, required this.imageRepository})
      : super(ShippingInitial());
  RegisterRequestModel model = RegisterRequestModel();
  RequestModel requestModel = RequestModel();
  getBannerData() async {
    var response = await repository.getBannerData();
    response.fold(
      (l) {
        // log(l.message, name: "FailureBanner");
        emit(FailureShippingState(message: l.toString()));
      },
      (r) {
        log(r.toString(), name: "FailureBanner");
        emit(SuccessGetBannerState(model: BannerModel.fromJson(r['data'])));
      },
    );
  }

  selectSubCategory({required SubCategoryEntity subCategory}) {
    model.subCategoryEntity = subCategory;
  }

  getUserImage({required File image}) {
    model.image = image;
  }

  String? validation({required String message, required bool condition}) {
    log((model.subCategoryEntity == null).toString(),
        name: "subCategoryEntity");
    log((condition).toString(), name: "condition");
    if (condition) {
      return message;
    }
    return null;
  }

  //User
  pickImageUser({required File image}) {
    model.image = image;
  }

  //Car
  pickImageCarRight({required File image}) {
    model.carImageRight = image;
  }

  pickImageCarLeft({required File image}) {
    model.carImageLeft = image;
  }

  pickImageCarBehind({required File image}) {
    model.carImageBehind = image;
  }

  pickImageCarInFront({required File image}) {
    model.carImageInFront = image;
  }

  //ID
  pickImageIdBehind({required File image}) {
    model.idImageBehind = image;
  }

  pickImageIdInFront({required File image}) {
    model.idImageInFront = image;
  }

  //Driving
  pickImageDrivingBehind({required File image}) {
    model.drivingImageBehind = image;
  }

  pickImageDrivingInFront({required File image}) {
    model.drivingImageInFront = image;
  }

  // License
  pickImageLicenseBehind({required File image}) {
    model.licenseImageBehind = image;
  }

  pickImageLicenseInFront({required File image}) {
    model.licenseImageInFront = image;
  }

  setGovernorate({required GovernorateEntity governorate}) {
    model.governorate = governorate;
  }

  //Request
  seSubCategoryRequest({required SubCategoryEntity subCategory}) {
    requestModel.subcategoryEntity = subCategory;
  }

  pickIDExpiryDate(DateTime date) {
    model.idExpiryDate = date;
  }

  pickDrivingExpiryDate(DateTime date) {
    model.drivingExpiryDate = date;
  }

  pickLicenseExpiryDate(DateTime date) {
    model.licenseExpiryDate = date;
  }

  // getS3Id() {
  //   log(model.idExpiryDate.toString());
  //   log(model.idImageBehind.toString());
  //   log(model.idImageInFront.toString());
  //   imageRepository.getS3Id(
  //     model: IdS3RequestModel(
  //       expireDate: DateFormat("yyyy-M-dd").format(model.idExpiryDate!),
  //       idBehind: IdBehind(
  //         size: getFileSize(model.idImageBehind!),
  //         type: getFileExtension(model.idImageBehind!),
  //       ),
  //       idFront: IdFront(
  //         size: getFileSize(model.idImageInFront!),
  //         type: getFileExtension(model.idImageInFront!),
  //       ),
  //     ),
  //   );
  // }

  getUserS3Imag() async {
    var response = await repository.getS3ImageDocuments(
        model: InfoDocumentsModel(
            document: Document(
      name: "criminalRecord",
      type: getFileExtension(model.image!),
      size: await getFileSize(model.image!),
    )));
    response.fold(
      (l) {
        log(model.image.toString(),
            name: "lllllllllllllllllllllllllllllllllllllllllllllll");
      },
      (r) async {
        log(r.toString(),
            name: "lllllllllllllllllllllllllllllllllllllllllllllll");
        await sendBinaryFileData(
            file: XFile(model.image!.path),
            signedUrl: r['data']['criminalRecordData']['signedUrl']);
        successSendImage(
          endpoint:
              "${EndPoints.successUpload}/${r['data']['criminalRecordData']['mediaId']}",
        );
      },
    );
  }

  getS3IdImages() async {
    var response = await repository.getS3IDImages(
      model: InfoIdS3Model(
          expireDate: DateFormat("yyyy-MM-dd").format(model.idExpiryDate!),
          // expireDate: model.idExpiryDate!,
          idBehind: IdBehind(
              type: getFileExtension(model.idImageBehind!),
              size: await getFileSize(model.idImageBehind!)),
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
            file: XFile(model.idImageBehind!.path),
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

  // uploadImage(){
  //   try {
  //   final request = http.Request('PUT', Uri.parse(signedUrl));
  //   request.headers['Content-Type'] = 'image/png';  // استخدم نوع الملف المناسب
  //   request.headers['x-amz-acl'] = 'private';       // إذا كنت تستخدم هذا النوع في الـ signedUrl
  //   request.bodyBytes = await imageFile.readAsBytes();

  //   final response = await request.send();

  //   if (response.statusCode == 200) {
  //     print('Upload successful!');
  //   } else {
  //     print('Failed to upload. Status code: ${response.statusCode}');
  //   }
  // } catch (e) {
  //   print('Error uploading image: $e');
  // }
  // }

  getCarImagesS3() async {
    List<File> listFile = [
      model.carImageRight!,
      model.carImageLeft!,
      model.carImageInFront!,
      model.carImageBehind!,
    ];
    List<CarImage>? carImagesList = await Future.wait(listFile.map(
      (e) async => CarImage(
        size: await getFileSize(e!),
        type: getFileExtension(e!),
      ),
    ));
    var response = await repository.getS3CarImages(
      // model: InfoIdS3Model(
      //     expireDate: DateFormat("yyyy-MM-dd").format(model.idExpiryDate!),
      //     // expireDate: model.idExpiryDate!,
      //     idBehind: IdBehind(
      // type: getFileExtension(model.idImageBehind!),
      // size: await getFileSize(model.idImageBehind!)),
      //     idFront: IdFront(
      // type: getFileExtension(model.idImageInFront!),
      // size: await getFileSize(model.idImageInFront!))),
      model: CarImagesS3Model(
        updateImageIndex: [1, 2, 3, 4],
        carImages: carImagesList,
        // carImages: [
        //   CarImage(
        //     type: getFileExtension(model.carImageRight!),
        //     size: await getFileSize(model.carImageRight!),
        //   ),
        //   CarImage(
        //     type: getFileExtension(model.carImageLeft!),
        //     size: await getFileSize(model.carImageLeft!),
        //   ),
        //   CarImage(
        //     type: getFileExtension(model.carImageBehind!),
        //     size: await getFileSize(model.carImageBehind!),
        //   ),
        //   CarImage(
        //     type: getFileExtension(model.carImageInFront!),
        //     size: await getFileSize(model.carImageInFront!),
        //   ),
        // ],
      ),
    );
    response.fold(
      (l) {
        log('llllllllllllllja;sdlkfja;slkdjf;aslkdjf;alskdjfa;slkdjf ${l}');
      },
      (r) async {
        log((r['data'] as List).length.toString(),
            name: "lllllllllllllllllllllllllllllllllllllllllllllll");

        // for (var item in r['data']) {
        //   log(item.toString(), name: "llllllkjsdkfjsdkfjsdkjfsdf");
        // await sendBinaryFileData(
        //     file: XFile(model.idImageInFront!.path),
        //     signedUrl: item['signedUrl']['idFrontData']['signedUrl']);
        // successSendImage(
        //   endpoint: EndPoints.successCarImages,
        //   data: {
        //     "mediaId": item['mediaId'],
        //   },
        // );
        // }
        for (var i = 0; i < carImagesList.length; i++) {
          log(r['data'][i].toString(),
              name:
                  "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
          await sendBinaryFileData(
              file: XFile(listFile[i].path),
              signedUrl: r['data'][i]['signedUrl']);
          successSendImage(
            endpoint: EndPoints.successCarImages,
            data: {
              "mediaId": r['data'][i]['mediaId'],
            },
          );
        }
      },
    );
  }

  getDrivingLicenseS3() async {
    var response = await repository.getS3DrivingLicense(
      model: DrivnigLicenseS3Model(
          expireDate: DateFormat("yyyy-MM-dd").format(model.drivingExpiryDate!),
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
            file: XFile(model.licenseImageBehind!.path),
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
          expireDate: DateFormat("yyyy-MM-dd").format(model.licenseExpiryDate!),
          // expireDate: model.idExpiryDate!,
          carLicenseBehind: CarLicenseBehind(
              type: getFileExtension(model.licenseImageBehind!),
              size: await getFileSize(model.licenseImageBehind!)),
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
            file: XFile(model.licenseImageBehind!.path),
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
    log(response.data.toString(),
        name: "lllllllllllkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    log(response.statusCode.toString(),
        name: "lllllllllllkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  }

  successSendImage(
      {required String endpoint, Map<String, dynamic>? data}) async {
    log(endpoint.toString(),
        name: "suuuuuuuuuuuuuuuuuuuuuuccccccccccccccccccessssssssssssssssss");
    var resposne =
        await serviceLocator<ApiConsumer>().put(endpoint, data: data);
    // log(resposne.toString(),
    //     name: "suuuuuuuuuuuuuuuuuuuuuuccccccccccccccccccessssssssssssssssss");
    resposne.fold(
      (l) {
        log(l.toString(),
            name:
                "suuuuuuuuuuuuuuuuuuuuuuccccccccccccccccccessssssssssssssssss");
      },
      (r) {
        log(r.toString(),
            name:
                "suuuuuuuuuuuuuuuuuuuuuuccccccccccccccccccessssssssssssssssss");
      },
    );
  }
}
