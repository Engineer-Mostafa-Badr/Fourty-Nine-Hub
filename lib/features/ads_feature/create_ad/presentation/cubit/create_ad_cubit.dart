import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/detail_entity.dart';

import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
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

  List<String> values = [];

  String? title, description, price, phone;
  final formState = GlobalKey<FormState>();

  CreateAdCubit(this._getAdPropertiesUsecase, this._createAdUseCase)
      : super(CreateAdState());

  void loadData({required String subCategoryId}) async {
    getAdProperties(subCategoryId: subCategoryId);
  }

  void getAdProperties({required String subCategoryId}) async {
    final response = await _getAdPropertiesUsecase(subCategoryId);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) {
      for (int i = 0; i <= data.length; i++) {
        values.add('');
      }

      emit(state.copyWith(adProperties: data));
    });
  }

  void onChanged({required String v, required int index}) {
    values[index] = v;
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
      List<DetailEntiy> details = [];
      for (int i = 0; i < (state.adProperties?.length ?? 0); i++) {
        details.add(DetailEntiy(
            label: state.adProperties![i].label,
            type: state.adProperties![i].type,
            value: values[i]));
      }
      final response = await _createAdUseCase(AdModel(
        id: 'id',
        title: title ?? '',
        isUser: state.isUser,
        description: description ?? '',
        // phone: phone ?? '',
        images: state.images?.map((e) => e.mediaId).toList() ?? [],
        // price: num.parse(price ?? ''),
        active: true,
        createdAt: DateTime.now(),
        details: details,
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
