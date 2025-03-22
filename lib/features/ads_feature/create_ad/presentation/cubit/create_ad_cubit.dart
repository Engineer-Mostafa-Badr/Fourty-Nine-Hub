import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/functions/global/upload_images.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/edit_my_ads_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/my_ads_auction.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/edit_my_ads_use_case.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/filter_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../routes/routes.dart';
import '../../../../account_taps/my_adds/domain/usecases/fetch_my_ads_by_id_usecase.dart';
import '../../domain/entities/categorization_entity.dart';
import '../../domain/usecases/create_ad_usecase.dart';
import '../../domain/usecases/get_ad_properties_usecase.dart';

part 'create_ad_state.dart';

class CreateAdCubit extends Cubit<CreateAdState> {
  final GetAdPropertiesUsecase _getAdPropertiesUsecase;
  final GetGovernoratesUseCase _governoratesUseCase;
  final GetCitiesUseCase _citiesUseCase;
  final CreateAdUseCase _createAdUseCase;
  final FilterAdUseCase _filterAdUseCase;
  final EditMyAdsUseCase _editMyAdsUseCase;
  final FetchMyAdsByIdUseCase _adsByIdUseCase;

  List<SelectionEntity> values = [];

  String? title, description, price, priceFrom, priceTo, phone;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final formState = GlobalKey<FormState>();
  final formStatic = GlobalKey<FormState>();

  CreateAdCubit(
      this._getAdPropertiesUsecase,
      this._createAdUseCase,
      this._governoratesUseCase,
      this._citiesUseCase,
      this._filterAdUseCase,
      this._editMyAdsUseCase,
      this._adsByIdUseCase)
      : super(CreateAdState());

  void loadData({required String subCategoryId,required bool fromMarriage}) async {
    emit(state.copyWith(status: CreateAdStates.loading));
    print("fromMarriage$fromMarriage");

    await Future.wait([
      getAdProperties(subCategoryId: subCategoryId, fromMarriage: fromMarriage),
      _getGovernorates(),
    ]);
    emit(state.copyWith(status: CreateAdStates.success));
  }

  void loadDataInEdit(
      {required String subCategoryId, required String id,required bool fromMarriage}) async {
    // emit(state.copyWith(status: CreateAdStates.loading));
    print("fromMarriage$fromMarriage");
    await Future.wait([
      getAdProperties(subCategoryId: subCategoryId, fromMarriage: fromMarriage),
      _getGovernorates(),
      fetchMyAdsById(id: id),
    ]);
    // emit(state.copyWith(status: CreateAdStates.success));
  }

  Future<void> getAdProperties({required String subCategoryId,required bool? fromMarriage}) async {
    final response = await _getAdPropertiesUsecase(GetAdPropertiesParams(id: subCategoryId, fromMarriage: fromMarriage));
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) {
      bool selectedPrice = data.any((element) => element.nameAr == 'السعر');
      print("selectedPrice:$selectedPrice");
      for (int i = 0; i <= data.length - 1; i++) {
        data[i].values.isNotEmpty
            ? values.add(data[i].values.first)
            : values.add(SelectionEntity(nameAr: '', nameEn: ''));
        print(values[i].nameEn);
        emit(state.copyWith(selections: values, isPrice: selectedPrice));
        print(state.selections![i].nameEn);
      }
      // print(object)
      final propertiesList = data
          .where((element) =>
              element.nameAr != 'السعر' && element.nameAr != 'الراتب')
          .toList();

      emit(state.copyWith(
          adProperties: propertiesList, filterAdProperties: data));
    });
  }

  void onChanged({required SelectionEntity v, required int index}) {
    values[index] = v;
    print(values.length);
  }

  void onChangedd({required SelectionEntity v, required int index}) {
    // Ensure the list is large enough to accommodate the index
    while (index >= values.length) {
      values.add(SelectionEntity(
          nameAr: v.nameAr,
          nameEn:
              v.nameEn)); // Add a default SelectionEntity for each missing slot
    }

    values[index] = v; // Assign the actual value
    print(values[index].nameEn);
  }

  void onTextChanged(
      {required String v,
      required int index,
      bool? isNumber = false,
      bool? from = true,
      String? type}) {
    if (isNumber == true) {
      if (from == true) {
        var model = values[index];
        SelectionEntity data =
            SelectionEntity(nameAr: v, nameEn: model.nameEn, type: type);
        values[index] = data;
      } else {
        var model = values[index];
        SelectionEntity data = SelectionEntity(nameAr: model.nameAr, nameEn: v);
        values[index] = data;
      }
    } else {
      SelectionEntity data = SelectionEntity(nameAr: v, nameEn: v);
      values[index] = data;
    }
    print(values[index].nameAr);
    print(values[index].nameEn);
  }
  bool loadImage = false;
   pickImage(
      {bool isGallery = true,
        required String subCategoryId,
        required BuildContext context,
        required Function(UploadFileEntity) onUploaded}) async {
     loadImage = true;
     emit(state.copyWith(status: CreateAdStates.uploadImage));
     print("objectUpload0");

    final file = await FilePickerHelper()
        .pickImage(isGallery: isGallery)
        .then((file) async {
      if (file != null) {
        showLoadingDialog(context);

        final tempDir = await getTemporaryDirectory();
        final uniqueFileName =
            'compressed_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        final targetPath = '${tempDir.path}/$uniqueFileName';
        print("file.path${file.path}");
        print("file.path$targetPath");
        print("objectUpload2");
        var result = await FlutterImageCompress.compressAndGetFile(
          file.path,
          targetPath,
          quality: 50,
          rotate: 360,
        );
        final bytes = await result!.readAsBytes();
        int size = bytes.length;
        // get signed url
        final signedURLResponse =
        await serviceLocator<ApiConsumer>().post(EndPoints.mediaUrl, data: {
          "type": "image/${file.mimeType ?? 'png'}",
          "size": size,
          "subcategoryId": subCategoryId
        });
        // send to w3 storage
        signedURLResponse.fold((l) {
          print(l.toString());
        }, (data) async {
          print("objectUpload3");
          log("responseData: ${jsonEncode(data)}");
          final tempDir = await getTemporaryDirectory();
          final uniqueFileName =
              'compressed_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
          final targetPath = '${tempDir.path}/$uniqueFileName';
          var result = await FlutterImageCompress.compressAndGetFile(
            file.path,
            targetPath,
            quality: 50,
            rotate: 360,
          );
          await sendBinaryFileData(
              file: result!, signedUrl: data['data']['signedUrl'])
              .then((value) async {
            print("amdl;maldmaslkd");
            final mediaId = data['data']['mediaId'];
            final confirmUploadResponse = await serviceLocator<ApiConsumer>()
                .put(EndPoints.confirmUpload(mediaId));
            /* confirmUploadResponse.fold((l) {
              print("object22222");
              return Left(l);
            }, (data) { */
            print("object111");
            onUploaded(UploadFileEntity(mediaId: mediaId, file: file));
            return const Right(true);
            // });
          });
        });
      }
    });

    return null;
  }
  Future<void> sendBinaryFileData(
      {required XFile file, required String signedUrl}) async {
    print("signedUrl$signedUrl");
    Uint8List image = await file.readAsBytes();
    print("object${image.length}");
    print("object$image");
    // var newFile = await FlutterImageCompress.=
    String fileName = file.path.split('/').last;

    Options options = Options(contentType: file.mimeType, headers: {
      'Accept': "*/*",
      'Content-Type': 'application/octet-stream',
      'Content-Length': image.length,
      'Connection': 'keep-alive',
      'User-Agent': 'ClinicPlush',
      // 'File-Name': fileName,
    });

    await Dio().put(signedUrl, data: image, options: options);
    print("aasl;das;ld,");
  }
  void uploadImage({required String subCategoryId,required BuildContext context}) async {
    loadImage = true;
    emit(state.copyWith(status: CreateAdStates.uploadImage));
    UploadImages uploadFile = UploadImages();
    final mediaResponse = await uploadFile.uploadImage( subCategoryId: subCategoryId,
        context:context,
        onUploaded: (UploadImagesEntity media) {
          // context.pop();
          final images = state.images ?? [];
          final files = state.files ?? [];
          images.addAll(media.mediaIds);
          files.addAll(media.files);
          print("objectUpload1");
          loadImage = false;

          emit(state.copyWith(
            images: images,files:files, status: CreateAdStates.initState,));
        }).then((value) {
      if (value == null) {
        emit(state.copyWith(status: CreateAdStates.initState));
      }
    });
    // final mediaResponse = await pickImage(
    //         subCategoryId: subCategoryId,
    //         context:context,
    //         onUploaded: (UploadFileEntity media) {
    //           context.pop();
    //           final images = state.images ?? [];
    //           images.add(media);
    //           print("objectUpload1");
    //           loadImage = false;
    //
    //           emit(state.copyWith(
    //               images: images, status: CreateAdStates.initState,));
    //         })
    //     .then((value) {
    //   if (value == null) {
    //     emit(state.copyWith(status: CreateAdStates.initState));
    //   }
    // });
    mediaResponse?.fold(
        (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
        (r) {
      emit(state.copyWith(status: CreateAdStates.initState));
    });
  }

  void removeImage({required String image}) {
    final images = state.images;
    images?.remove(image);
    emit(state.copyWith(images: images));
  }

  void selectGovernorate(String id) {
    emit(state.copyWith(governorate: id, city: ''));
  }

  void selectCity(String id) {
    emit(state.copyWith(city: id));
  }

  final user = UserCubit.to.state.data?.id;

  void createAd(
      {required CategorizationEntity categorize,
      required BuildContext context}) async {
    print(categorize.subCategory.hasAuction);

    String type = '';
    if(categorize.fromMarriage==true){
      type='user';
    }else if (categorize.mainCategory.nameEn == 'Dating' && state.isMale == true) {
      type = 'male';
    } else if (categorize.mainCategory.nameEn == 'Dating' &&
        state.isMale == false) {
      type = 'female';
    } else if (categorize.subCategory.hasAuction == false &&
        state.isUser == false) {
      type = "provider";
    } else if (categorize.subCategory.hasAuction == false &&
        state.isUser == true) {
      type = "user";
    } else if (categorize.subCategory.hasAuction == true &&
        state.isSale == false) {
      print(state.isSale);
      type = "rent";
    } else if (categorize.subCategory.hasAuction == true &&
        state.isSale == true) {
      print(state.isSale);
      type = "sale";
    }

    if (formStatic.currentState?.validate() ?? false) {
      print("object");
    } else {
      print("object3132");
    }
    if ((formState.currentState?.validate() ?? false) &&
        (state.images?.isNotEmpty ?? false) &&
        (state.city != '') &&
        state.governorate != '') {
      List<CreateAdEntity> details = [];
      for (int i = 0; i < (state.adProperties?.length ?? 0); i++) {
        details.add(CreateAdEntity(
            propId: state.adProperties![i].id, value: state.selections![i]));
      }
      List<CreateAdEntity> selectedDetails =
          details.where((element) => element.value.nameAr.isNotEmpty).toList();
      final response = await _createAdUseCase(AdModel(
        id: 'id',
        title: title ?? '',
        type: type,
        city: state.city,
        governorate: state.governorate,
        // isUser: categorize.subCategory.hasAuction==true?state.isSale:state.isUser,
        description: description ?? '',
        phone: phone ?? '',
        images: state.images?? [],
        price: num.parse(price ?? "0"),
        active: true,
        createdAt: DateTime.now(),
        details: selectedDetails,
        subCategoryId: categorize.subCategory.id,
        mainCategoryId: categorize.mainCategory.id,
        approved: false,
      ));

      response.fold(
          (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
          (r) {
        context.pushReplacement(Routes.MYADDS);
      });
    } else if (state.images == [] || state.images == null) {
      showErrorMessage(context, LocaleKeys.uploadOneImage.localize);
    } else if (state.governorate == '') {
      showErrorMessage(context, LocaleKeys.selectGovernorate.localize);
    } else if (state.city == '') {
      showErrorMessage(context, LocaleKeys.selectCity.localize);
    }
  }

  void filterAds(
      {required CategorizationEntity categorize,
      required BuildContext context,}) async {
    if (true) {
      print("ss");
      List<CreateAdEntity> details = [];
      for (int i = 0; i < (state.filterAdProperties?.length ?? 0); i++) {
        details.add(CreateAdEntity(
            propId: state.filterAdProperties![i].id,
            value: SelectionEntity(
                nameAr: state.selections![i].nameAr,
                nameEn: state.selections![i].nameEn,
                type: state.filterAdProperties![i].type)));
      }
      String priceId = (state.filterAdProperties != null &&
              state.filterAdProperties!.isNotEmpty&&categorize.fromMarriage==false)
          ? state.filterAdProperties
                  ?.firstWhere((element) =>
                      element.nameAr == 'السعر' || element.nameAr == 'الراتب')
                  .id ??
              ''
          : '';
      List<CreateAdEntity> selectedDetails = details.isNotEmpty
          ? details
              .where((element) =>
                  element.value.nameAr.isNotEmpty && element.propId != priceId)
              .toList()
          : [];
      CreateAdEntity? price = (details.isNotEmpty&&categorize.fromMarriage==false)
          ? details.firstWhere((element) => element.propId == priceId)
          : null;
      for (var item in selectedDetails) {
        print(item.toJson());
      }

      FilterModel model = FilterModel(
          price: price,
          props: selectedDetails,
          cityId: state.city ?? '',
          governorateId: state.governorate ?? '',
          limit: 10,
          page: 1,
          subCategoryId: categorize.subCategory.id);
      if(categorize.fromMarriage==true){
        context.pop(model);
        return;
      }
      final response = await _filterAdUseCase(model);
      response.fold(
          (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
          (r) {
        context.pop(model);
      });
    } else if (state.governorate == '') {
      showErrorMessage(context, LocaleKeys.selectGovernorate.localize);
    } else if (state.city == '') {
      showErrorMessage(context, LocaleKeys.selectCity.localize);
    }
  }

  void filterGovernorateAds(
      {required CategorizationEntity categorize,
      required BuildContext context}) async {
    if (state.governorate != '' && state.city != '') {
      FilterModel model = FilterModel(
          cityId: state.city ?? '',
          governorateId: state.governorate ?? '',
          limit: 10,
          page: 1,
          subCategoryId: categorize.subCategory.id);
      if(categorize.fromMarriage==true){
        context.pop(model);
        return;
      }
      final response = await _filterAdUseCase(model);
      response.fold(
          (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
          (r) {
        context.pop(model);
      });
    } else if (state.governorate == '') {
      showErrorMessage(context, LocaleKeys.selectGovernorate.localize);
    } else if (state.city == '') {
      showErrorMessage(context, LocaleKeys.selectCity.localize);
    }
  }

  Future<void> _getGovernorates() async {
    final response = await _governoratesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) {
      emit(state.copyWith(governorates: data));
    });
  }

  Future<void> getCities(String governorateId) async {
    emit(state.copyWith(status: CreateAdStates.loadCities));
    final response = await _citiesUseCase.call(governorateId);

    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: CreateAdStates.error)),
      (data) => emit(state.copyWith(
          cities: data, status: CreateAdStates.loadCitiesSuccess)),
    );
  }

  Future<void> editMyAds({
    required MyAuctionAdsEntity categorization,
    SelectionEntity? selectedExperienceLevel,
    SelectionEntity? selectedEducationLevel,
    required String title,
    required String desc,
    required String phone,
    required num price,
  }) async {
    print('state.images ${state.images?? []}');
    // final List<Map<String, dynamic>> props = [];
    // final List<Map<String, dynamic>> props2 = [];
    // final existingProps = state.myAdById!.props;

    // for (var prop in existingProps) {
    //   if (selectedExperienceLevel != null &&
    //       selectedEducationLevel == null) {
    //     props.add({
    //       "propertyId": '66f56c06414240a8e48520b3',
    //       // Experience property ID
    //       "value": {
    //         "ar": selectedExperienceLevel.nameAr,
    //         "en": selectedExperienceLevel.nameEn,
    //       },
    //     });
    //     // No need to add education level if only experience is selected
    //     continue; // Skip the rest of the loop for this iteration
    //   }
    //
    //   // Check if education level is selected
    //   if (selectedEducationLevel != null &&
    //       selectedExperienceLevel == null) {
    //     props.add({
    //       "propertyId": "66f56c06414240a8e48520b2",
    //       // Education property ID
    //       "value": {
    //         "ar": selectedEducationLevel.nameAr,
    //         "en": selectedEducationLevel.nameEn,
    //       },
    //     });
    //     // No need to add experience level if only education is selected
    //     continue; // Skip the rest of the loop for this iteration
    //   }
    //
    //   // Add both experience and education if both are selected
    //   if (selectedExperienceLevel != null &&
    //       selectedEducationLevel != null) {
    //     props.add({
    //       "propertyId": '66f56c06414240a8e48520b3',
    //       // Experience property ID
    //       "value": {
    //         "ar": selectedExperienceLevel.nameAr,
    //         "en": selectedExperienceLevel.nameEn,
    //       },
    //     });
    //     props.add({
    //       "propertyId": "66f56c06414240a8e48520b2",
    //       // Education property ID
    //       "value": {
    //         "ar": selectedEducationLevel.nameAr,
    //         "en": selectedEducationLevel.nameEn,
    //       },
    //     });
    //     break; // Exit the loop once both are added
    //   }
    //
    //   // Default to existing values if neither experience nor education are selected
    //   if (selectedExperienceLevel == null &&
    //       selectedEducationLevel == null) {
    //     props2.add({
    //       "propertyId": prop.id,
    //       "value": {
    //         "ar": prop.value.ar,
    //         "en": prop.value.en,
    //       },
    //     });
    //   }
    // }

    String type = '';
    if (categorization.mainCategory?.nameEn == 'Dating' &&
        state.isMale == true) {
      type = 'male';
    } else if (categorization.mainCategory?.nameEn == 'Dating' &&
        state.isMale == false) {
      type = 'female';
    } else if (categorization.subCategory.hasAuction == false &&
        state.isUser == false) {
      type = "provider";
    } else if (categorization.subCategory.hasAuction == false &&
        state.isUser == true) {
      type = "user";
    } else if (categorization.subCategory.hasAuction == true &&
        state.isSale == false) {
      print(state.isSale);
      type = "rent";
    } else if (categorization.subCategory.hasAuction == true &&
        state.isSale == true) {
      print(state.isSale);
      type = "sale";
    }

    List<CreateAdEntity> details = [];
    for (int i = 0; i < (state.adProperties?.length ?? 0); i++) {
      final adProperty = state.adProperties![i];
      final propValue = state.selections![i];

// Check if propValue is of type SelectionEntity
      details.add(CreateAdEntity(
        propId: adProperty.id,
        value: propValue, // Now safely assign propValue
      ));
    }

    List<CreateAdEntity> selectedDetails =
        details.where((element) => element.value.nameAr.isNotEmpty).toList();

    emit(state.copyWith(status: CreateAdStates.loading));

    final response = await _editMyAdsUseCase(EditParams(
      id: categorization.id,
      title: title,
      description: desc,
      phone: phone,
      type: type,
      price: price,
      details: selectedDetails,
      subCategoryId: categorization.subCategory.id,
      mainCategoryId: categorization.mainCategory!.id,
      governorate: (state.governorate?.isEmpty ?? true)
          ? state.myAdById?.governmentDataId
          : state.governorate,
      city: (state.city?.isEmpty ?? true)
          ? state.myAdById?.cityDataId
          : state.city,
      images: state.images??
          state.myAdById!.images.map((e) => e.id).toList(),
    ));
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (r) {
      emit(state.copyWith(status: CreateAdStates.updateSuccess));
      fetchMyAdsById(id: categorization.id);
    });
  }

  Future<void> fetchMyAdsById({
    required String id,
  }) async {
    final response = await _adsByIdUseCase(id);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (r) =>
            emit(state.copyWith(myAdById: r, status: CreateAdStates.success)));
  }
}
