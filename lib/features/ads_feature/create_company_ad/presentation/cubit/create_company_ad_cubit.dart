import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/functions/global/upload_images.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/fetch_post_company_advertise_params.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/usecases/pay_company_ad_use_case.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../domain/entities/company_ad_entity.dart';
import '../../domain/entities/company_ad_option_entity.dart';
import '../../domain/entities/price_entity.dart';
import '../../domain/usecases/delete_company_ad_use_case.dart';
import '../../domain/usecases/get_company_add_use_case.dart';
import '../../domain/usecases/get_posts_company_ad_use_case.dart';
import '../../domain/usecases/get_price_use_case.dart';

part 'create_company_ad_state.dart';

class CreateCompanyAdCubit extends Cubit<CreateCompanyAdState> {
  final GetPriceUseCases _getPriceUseCases;
  final GetCompanyAddUseCases _companyAddUseCases;
  final DeleteCompanyAddUseCases _deleteCompanyAddUseCases;
  final GetPostsCompanyAdUseCase _getPostsCompanyAdUseCase;
  final PayCompanyAdUseCase _payCompanyAdUseCase;
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final GetSubCategoriesUseCase _getSubcategoriesUseCase;

  CreateCompanyAdCubit(
    this._getPriceUseCases,
    this._companyAddUseCases,
    this._deleteCompanyAddUseCases,
    this._getPostsCompanyAdUseCase,
    this._payCompanyAdUseCase,
    this._getMainCategoriesUseCase,
    this._getSubcategoriesUseCase,
  ) : super(const CreateCompanyAdState());

  Future<bool> addPostCompanyAdvertise({
    String? post,
    required String type,
    String? description,
    required num totalPrice,
    required BuildContext context,
  }) async {
    bool result = false;
    emit(state.copyWith(status: StateStatus.loading));
    var response = await _companyAddUseCases(
      CompanyAddParams(
        advertisementType: type,
        totalPrice: totalPrice,
        media: state.mediaIds,
        description: description,
        post: post,
      ),
    );
    response.fold(
      (l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        result = false;
        emit(state.copyWith(failure: l, status: StateStatus.error));
        Navigator.of(context).pop();
        showErrorMessage(context, getFailureMessage(l, context));
      },
      (data) {
        result = true;
        emit(state.copyWith(advertise: data, status: StateStatus.success));
        print('Media IDs cleared after successful post.');
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        showSuccessMessage(context, LocaleKeys.postSubmitted.localize);
      },
    );
    return result;
  }

  Future<bool> deleteCompanyAd({required String id}) async {
    emit(state.copyWith(status: StateStatus.loading)); // Start loading state
    final response = await _deleteCompanyAddUseCases(
      DeleteCompanyAdParams(id: id),
    );
    bool result = false;

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (success) {
        result = success;
        emit(state.copyWith(status: StateStatus.success));
      },
    );
    return result;
  }

  Future<List<CompanyAdEntity>> getCompanyAdPosts(String filter,
      {required PaginationParams params}) async {
    List<CompanyAdEntity> company = [];
    final response = await _getPostsCompanyAdUseCase(
      FetchPostCompanyAdvertiseParams(filter: filter, paginationParams: params),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        company = data;
      },
    );
    return company;
  }

  Future<void> getCompanyAdPrice() async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await _getPriceUseCases.call(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) => emit(state.copyWith(price: data, status: StateStatus.success)),
    );
  }

  Future<void> getSubcategories(
      {required PaginationParams paginationParams,
      required String mainCategoryId}) async {
    emit(state.copyWith(status: StateStatus.loadingSubCategories));
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUseCase(GetSubCategoriesParams(
        mainCategoryId: mainCategoryId,
        paginationParams: paginationParams,
        userId: user ?? ''));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
        failure: failure,
        status: StateStatus.error,
      ));
    }, (r) {
      emit(state.copyWith(subCategories: r, status: StateStatus.success));
    });
  }

  void loadData() async {
    await getCompanyAdPrice();
  }

  Future<void> loadMainCategories(BuildContext context) async {
    print("loadData");

    emit(state.copyWith(status: StateStatus.loading));
    final user = UserCubit.to.state.data?.id;
    print('userId1$user');
    print('userId1$user');
    final result = await _getMainCategoriesUseCase(
        MainCategoriesParams(page: 1, limit: 100, userId: user ?? ''));
    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
        CliLogger.error(
            'can\'t load main categories there is an error ${failure.toString()}');
      },
      (r) async {
        CliLogger.info('main categories loaded in loadData : ${r.length}');
        emit(state.copyWith(status: StateStatus.success, mainCategories: r));
      },
    );
  }

  onRemoveVideo() {
    emit(state.copyWith(mediaIds: [], video: '', status: StateStatus.success));
  }

  onSelectMainCategory(MainCategoryEntity? selectedMainCategories) {
    emit(state.copyWith(selectedMainCategories: selectedMainCategories));
    getSubcategories(
        paginationParams: PaginationParams(page: 1, limit: 100),
        mainCategoryId: selectedMainCategories?.id ?? '');
  }

  onSelectSubCategory(SubCategoryEntity? selectedSubCategories) {
    emit(state.copyWith(selectedSubCategories: selectedSubCategories));
  }

  onUploadVideo(String video) {
    List<String> mediaIds = [];
    mediaIds.add(video);
    emit(state.copyWith(
        mediaIds: mediaIds, video: video, status: StateStatus.success));
  }

  Future<void> payCompanyAd(PayCompanyAdParams params) async {
    emit(state.copyWith(status: StateStatus.loading)); // Start loading state
    final response = await _payCompanyAdUseCase(params);
    return response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (success) {
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }

  removePhoto(XFile? file, String? mediaId) {
    print("XFile ${file?.path} mediaId $mediaId");
    final mediaIds = state.mediaIds ?? [];
    final files = state.files ?? [];
    mediaIds.remove(mediaId);
    files.remove(file);
    emit(state.copyWith(
        mediaIds: mediaIds, files: files, status: StateStatus.updated));
  }

  uploadPhoto(
      {bool isGallery = true,
      required BuildContext context,
      bool? hasLoading}) async {
    UploadImages uploadFile = UploadImages();
    final mediaResponse = await uploadFile
        .uploadImage(
            subCategoryId: Constants.companyAdsSubCategory,
            context: context,
            onUploaded: (UploadImagesEntity media) {
              // context.pop();
              final mediaIds = state.mediaIds ?? [];
              final files = state.files ?? [];
              mediaIds.addAll(media.mediaIds);
              files.addAll(media.files);
              print("objectUpload1");
              // loadImage = false;

              emit(state.copyWith(
                  mediaIds: mediaIds,
                  files: files,
                  status: StateStatus.updated));
            })
        .then((value) {
      // if (value == null) {
      emit(state.copyWith(image: null));
      // }
    });
  }
}
