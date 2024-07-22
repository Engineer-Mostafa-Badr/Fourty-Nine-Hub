import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';

import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import '../../../../../core/error/failure.dart';

import '../../domain/usecases/get_ad_properties_usecase.dart';

part 'create_ad_state.dart';

class CreateAdCubit extends Cubit<CreateAdState> {
  final GetAdPropertiesUsecase _getAdPropertiesUsecase;
  List<String> values = [];
  List<String> images = [];
  String? title, description, price;
  CreateAdCubit(
    this._getAdPropertiesUsecase,
  ) : super(const CreateAdState());

  void loadData({required String subCategoryId}) async {
    getAdProperties(subCategoryId: subCategoryId);
  }

  void getAdProperties({required String subCategoryId}) async {
    final response = await _getAdPropertiesUsecase(subCategoryId);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) {
      for (int i = 0; i < data.length; i++) {
        values[i] = '';
      }
      emit(state.copyWith(adProperties: data));
    });
  }

  void onChanged({required String v, required int index}) {
    values[index] = v;
  }

  void uploadImage({required String subCategoryId}) async {
    final mediaResponse =
        await UploadFile().uploadImage(subCategoryId: subCategoryId);
    mediaResponse.fold((l) => emit(state.copyWith(failure: l, status: CreateAdStates.error)), (mediaId) => images.add(mediaId));

  }
}
