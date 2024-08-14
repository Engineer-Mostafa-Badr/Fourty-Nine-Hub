import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/id_s3_request_model/id_behind.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/id_s3_request_model/id_front.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/id_s3_request_model/id_s3_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/images_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
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
        log(l.message, name: "FailureBanner");
        emit(FailureShippingState(message: l.message));
      },
      (r) {
        log(r.toString(), name: "FailureBanner");
        emit(SuccessGetBannerState(model: r));
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

  getS3Id() {
    log(model.idExpiryDate.toString());
    log(model.idImageBehind.toString());
    log(model.idImageInFront.toString());
    imageRepository.getS3Id(
      model: IdS3RequestModel(
        expireDate: DateFormat("yyyy-M-dd").format(model.idExpiryDate!),
        idBehind: IdBehind(
          size: getFileSize(model.idImageBehind!),
          type: getFileExtension(model.idImageBehind!),
        ),
        idFront: IdFront(
          size: getFileSize(model.idImageInFront!),
          type: getFileExtension(model.idImageInFront!),
        ),
      ),
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

  getFileExtension(File file) {
    log("image/${path.extension(file.path).substring(1)}");
    if (file.existsSync()) {
      return "image/${path.extension(file.path).substring(1)}";
    } else {
      return "image/png";
    }
  }

  getFileSize(File file) {
    return file.lengthSync();
  }
}
