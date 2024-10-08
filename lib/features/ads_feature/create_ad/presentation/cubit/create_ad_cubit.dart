import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
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
import 'package:go_router/go_router.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../routes/routes.dart';
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

  List<SelectionEntity> values = [];

  String? title, description,price, priceFrom,priceTo, phone;
  final formState = GlobalKey<FormState>();
  final formStatic = GlobalKey<FormState>();

  CreateAdCubit(this._getAdPropertiesUsecase, this._createAdUseCase,
      this._governoratesUseCase, this._citiesUseCase, this._filterAdUseCase)
      : super(CreateAdState());

  void loadData({required String subCategoryId}) async {
    emit(state.copyWith(status: CreateAdStates.loading));

    await Future.wait([
      getAdProperties(subCategoryId: subCategoryId),
      _getGovernorates(),
    ]);
    emit(state.copyWith(status: CreateAdStates.success));
  }

  Future<void> getAdProperties({required String subCategoryId}) async {
    final response = await _getAdPropertiesUsecase(subCategoryId);
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

      emit(state.copyWith(adProperties: propertiesList,filterAdProperties:data));
    });
  }

  void onChanged({required SelectionEntity v, required int index}) {
    values[index] = v;
    print(values.length);
  }

  void onTextChanged({required String v, required int index,bool? isNumber=false,bool? from =true,String? type}) {
    if(isNumber==true){
      if(from==true){
        var model = values[index];
        SelectionEntity data = SelectionEntity(nameAr: v, nameEn: model.nameEn,type: type);
        values[index] = data;
      }else{
        var model = values[index];
        SelectionEntity data = SelectionEntity(nameAr: model.nameAr, nameEn: v);
        values[index] = data;
      }
    }else {
      SelectionEntity data = SelectionEntity(nameAr: v, nameEn: v);
      values[index] = data;
    }
    print(values[index].nameAr);
    print(values[index].nameEn);
  }

  void uploadImage({required String subCategoryId}) async {
    emit(state.copyWith(status: CreateAdStates.imageUploading));
    final mediaResponse = await UploadFile().uploadImage(
        subCategoryId: subCategoryId,
        onUploaded: (UploadFileEntity media) {
          final images = state.images ?? [];
          images.add(media);
          emit(
              state.copyWith(images: images, status: CreateAdStates.initState));
        });
    mediaResponse?.fold(
        (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
        (r) {
      emit(state.copyWith(status: CreateAdStates.initState));
    });
  }

  void removeImage({required UploadFileEntity image}) {
    final images = state.images;
    images?.remove(image);
    emit(state.copyWith(images: images));
  }

  void selectGovernorate(String id){
    emit(state.copyWith(governorate: id,city: ''));
  }
  void selectCity(String id){
    emit(state.copyWith(city: id));
  }

  final user = UserCubit.to.state.data?.id;
  void createAd(
      {required CategorizationEntity categorize,
      required BuildContext context}) async {
    print(categorize.subCategory.hasAuction);

    String type = '';
    if (categorize.subCategory.hasAuction == false && state.isUser == false) {
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

    if(formStatic.currentState?.validate()??false){
      print("object");
    }else{
      print("object3132");
    }
    if ((formState.currentState?.validate() ?? false) && (state.images?.isNotEmpty ?? false)&&(state.city !='')&&state.governorate !='') {
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
        images: state.images?.map((e) => e.mediaId).toList() ?? [],
        price: num.parse(price ?? "0"),
        active: true,
        createdAt: DateTime.now(),
        details: selectedDetails,
        subCategoryId: categorize.subCategory.id,
        mainCategoryId: categorize.mainCategory.id, approved: false,
      ));

      response.fold(
          (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
          (r) {
        context.pushReplacement(Routes.MYADDS);
      });
    }else if(state.images==[]||state.images==null){
      showErrorMessage(context, LocaleKeys.uploadOneImage.localize);
    }else if(state.governorate == ''){
      showErrorMessage(context, LocaleKeys.selectGovernorate.localize);
    }else if(state.city == ''){
      showErrorMessage(context, LocaleKeys.selectCity.localize);
    }
  }

  void filterAds(
      {required CategorizationEntity categorize,
        required BuildContext context}) async
  {
    if((formState.currentState?.validate() ?? false)&&(state.city !='')&&state.governorate !=''){
      print("ss");
      List<CreateAdEntity> details = [];
      for (int i = 0; i < (state.filterAdProperties?.length ?? 0); i++) {
        details.add(CreateAdEntity(
            propId: state.filterAdProperties![i].id, value: SelectionEntity(nameAr: state.selections![i].nameAr, nameEn: state.selections![i].nameEn,type: state.filterAdProperties![i].type)));
      }
      String priceId = state.filterAdProperties?.firstWhere((element) => element.nameAr== 'السعر'||element.nameAr=='الراتب').id??'';
      List<CreateAdEntity> selectedDetails =
      details.where((element) => element.value.nameAr.isNotEmpty&&element.propId!=priceId).toList();
      CreateAdEntity price = details.firstWhere((element) => element.propId == priceId);
      for (var item in selectedDetails){
        print(item.toJson());
      }

      FilterModel model =FilterModel(price: price, props: selectedDetails, cityId: state.city??'',governorateId: state.governorate??'', limit: 10, page: 1, subCategoryId:categorize.subCategory.id);
      final response = await _filterAdUseCase(model);
      response.fold(
              (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
              (r) {
                context.pop(model);
          });
    }else if(state.governorate == ''){
      showErrorMessage(context, LocaleKeys.selectGovernorate.localize);
    }else if(state.city == ''){
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
      (failure) => emit(state.copyWith(failure: failure, status: CreateAdStates.error)),
      (data) => emit(state.copyWith(cities: data, status: CreateAdStates.loadCitiesSuccess)),
    );
  }
}
