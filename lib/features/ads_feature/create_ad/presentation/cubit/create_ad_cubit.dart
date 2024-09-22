import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/detail_entity.dart';

import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

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
  final CreateAdUseCase _createAdUseCase;

  List<SelectionEntity> values = [];

  String? title, description, price, phone;
  final formState = GlobalKey<FormState>();

  CreateAdCubit(this._getAdPropertiesUsecase, this._createAdUseCase)
      : super( CreateAdState());

  void loadData({required String subCategoryId}) async {
    getAdProperties(subCategoryId: subCategoryId);
  }

  void getAdProperties({required String subCategoryId}) async {
    final response = await _getAdPropertiesUsecase(subCategoryId);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) {
          bool selectedPrice = data.any((element) => element.nameAr=='السعر');
          print("selectedPrice:$selectedPrice");
      for (int i = 0; i <= data.length-1; i++) {
        data[i].values.isNotEmpty?values.add(data[i].values.first):values.add(SelectionEntity( nameAr: '', nameEn: ''));
        print(values[i].nameEn);
        emit(state.copyWith(selections: values,isPrice:selectedPrice));
        print(state.selections![i].nameEn);
      }
      // print(object)
          final propertiesList = data.where((element) => element.nameAr!='السعر'&&element.nameEn!='الراتب').toList();

      emit(state.copyWith(adProperties: propertiesList));
    });
  }

  void onChanged({required SelectionEntity v, required int index}) {
    values[index] = v;
    print(values.length);
  }

  void onTextChanged({required String v, required int index}) {
    SelectionEntity data = SelectionEntity(
      nameAr: v,
      nameEn: v
    );
    values[index] = data;
    print(values.length);
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

  final user = UserCubit.to.state.data?.id;
  void createAd(
      {required CategorizationEntity categorize,
      required BuildContext context}) async {
    if ((formState.currentState?.validate() ?? false) &&
        (state.images?.isNotEmpty ?? false)) {
      List<CreateAdEntity> details = [];
      for (int i = 0; i < (state.adProperties?.length ?? 0); i++) {
        details.add(CreateAdEntity(
          propId: state.adProperties![i].id,
            value: state.selections![i]));
      }
      List<CreateAdEntity> selectedDetails = details.where((element) => element.value.nameAr.isNotEmpty).toList();
      final response = await _createAdUseCase(AdModel(
          id: 'id',
          title: title ?? '',
          isUser: state.isUser,
          description: description ?? '',
          phone: phone ?? '',
          images: state.images?.map((e) => e.mediaId).toList() ?? [],
          price: num.parse(price??"0"),
          active: true,
          createdAt: DateTime.now(),
          details: selectedDetails,
          subCategoryId: categorize.subCategory.id,
          mainCategoryId: categorize.mainCategory.id,
      ));

      response.fold(
          (l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)),
          (r) {
        context.pushReplacement(Routes.MYADDS);
      });
    }
  }
}
