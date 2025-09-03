import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/functions/global/upload_file.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../health_feature/create_doctor/domain/entities/city.dart';
import '../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';
import '../../../health_feature/create_doctor/domain/usecases/get_cities.dart';
import '../../../health_feature/create_doctor/domain/usecases/get_governorates.dart';
import '../../../social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import '../../restaurants_list/domain/entities/food_category_entity.dart';
import '../../restaurants_list/domain/entities/restaurant_mneu.dart';
import '../../restaurants_list/domain/usecases/create_restaurant.dart';
import '../../restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import '../../restaurants_list/domain/usecases/restaurant_shared_data.dart';
import '../../restaurants_list/presentation/cubit/restaurants_list_cubit.dart';

part 'create_resturant_state.dart';

class CreateRestaurantCubit extends Cubit<CreateRestaurantState> {
  final RestaurantSharedData _shareCubit;
  final GetMealCategoriesWithCountRestaurantsUseCase
      _getSubSubcategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final UpdateRestaurantUseCase _updateRestaurantUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final CreateRestaurantUseCase _createREstaurant;
  final ApiConsumer apiConsumer;
  XFile? licenseFirstPage;
  XFile? licenseSecondPage;
  XFile? licenseThirdPage;

  // updateRestaurant(id) async {
  //   CreateRestaurantParams params = createRestaurantParams;
  //
  //   Map<String, dynamic> data = {
  //     // "workFrom": params.workFrom,
  //     // "workTo": params.workTo,
  //     // "countryCode": params.countryCode,
  //     // "deliveryFee": params.deliveryFee,
  //     // "deliveryTime": params.deliveryTime,
  //     "name": params.name,
  //     "phone": params.number,
  //     "subcategoryId": params.subcategoryId,
  //     "restaurantMedia": params.restaurantMedia,
  //     "licenseMedia": params.licenseMedia,
  //     "government": params.government,
  //     "city": params.city,
  //   };
  //   var url = 'https://31b3c19d4d0a.ngrok-free.app/api/v1/restaurants/update-restaurant-info/$id';
  //
  //   final response = await apiConsumer.put(url, data: data);
  //
  //   return response.fold(
  //     (Failure failure) {
  //       // return Left(failure);
  //     },
  //     (data) {
  //       print(data.toString() + "122222223");
  //       // return Right(data['status']);
  //     },
  //   );
  // }

  // Future<String> updateRestaurant(id) async {
  //   var res = 'fail';
  //   _validationState();
  //
  //   if ((createRestaurantParams.name?.isNotEmpty ?? false) &&
  //       (createRestaurantParams.government?.isNotEmpty ?? false) &&
  //       (createRestaurantParams.city?.isNotEmpty ?? false) &&
  //       (createRestaurantParams.licenseMedia?.isNotEmpty ?? false) &&
  //       (createRestaurantParams.restaurantMedia?.isNotEmpty ?? false) &&
  //       (createRestaurantParams.mneu?.isNotEmpty ?? false)) {
  //     saveTextEditingController();
  //     emit(CreateResturantLoading(LocaleKeys.creatingRestaurant.tr()));
  //     final response = await _createREstaurant.call(createRestaurantParams);
  //     emit(CreateRestaurantCloseLoading());
  //     response.fold((Failure failure) {
  //       if (failure is ServerFailure) {
  //         emit(CreateResturantError(failure.message));
  //       } else if (failure is UnauthorizedFailure) {
  //         emit(CreateResturantError(failure.toString()));
  //         AppPages.router.routerDelegate.navigatorKey.currentContext!
  //             .pushNamed(Routes.LOGIN);
  //       }
  //       res = 'fail';
  //     }, (data) {
  //       res = 'success';
  //       emit(CreateRestaurantSuccess(LocaleKeys
  //           .youHaveSubmittedYourRegistrationSuccessfullyWaitingForAdministrationApproval
  //           .tr()));
  //
  //       AppPages.router.routerDelegate.navigatorKey.currentContext!
  //           .read<RestaurantsCubit>()
  //           .loadData();
  //
  //       AppPages.router.routerDelegate.pop();
  //       return res;
  //     });
  //   } else {
  //     res = 'fail';
  //     ScaffoldMessenger.of(
  //             AppPages.router.routerDelegate.navigatorKey.currentContext!)
  //         .showSnackBar(SnackBar(
  //       content: Text(LocaleKeys.completeAllFields.tr()),
  //       backgroundColor: Colors.red,
  //     ));
  //     return res;
  //   }
  //   return res;
  // }

  bool isSubCategory = false;

  final CreateRestaurantParams createRestaurantParams =
      CreateRestaurantParams();

  List<XFile> restaurantImages = [];

  List<String> restaurantImagesIds = [];

  List<String> licensRestaurantImagesIds = [];

  final name = TextEditingController();

  final number = TextEditingController();

  final phoneController = TextEditingController();

  CreateRestaurantCubit(
      this._shareCubit,
      this._getSubSubcategoriesUseCase,
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._createREstaurant,
      this.apiConsumer,
      this._updateRestaurantUseCase)
      : super(CreateRestaurantInitial());

  @override
  Future<void> close() {
    name.dispose();
    phoneController.dispose();
    return super.close();
  }

  Future<void> loadData() async {
    emit(CreateRestaurantLoading());
    await _getSubCategories();
    await _getGovernorates();
    emit(CreateRestaurantFinish());
  }

  saveNumberTextEditingController() {
    createRestaurantParams.number = phoneController.text;
  }

  saveTextEditingController() {
    createRestaurantParams.name = name.text;
  }

  void selectCity(CityEntity value) {
    createRestaurantParams.city = value.id;
  }

  // ================================ dropdowns ===============================
  Future<void> selectGovernorate(GovernorateEntity value) async {
    createRestaurantParams.government = value.id;

    await _getCities(value.id);
  }

  void selectSubcategory(FoodCategoryEntity subCategoryModel) {
    createRestaurantParams.subcategoryId = subCategoryModel.id ?? "";
  }

  Future<String> submit(context) async {
    var res = 'fail';
    _validationState();

    if ((createRestaurantParams.name?.isNotEmpty ?? false) &&
        (createRestaurantParams.government?.isNotEmpty ?? false) &&
        (createRestaurantParams.city?.isNotEmpty ?? false) &&
        (createRestaurantParams.licenseMedia?.isNotEmpty ?? false) &&
        (createRestaurantParams.restaurantMedia?.isNotEmpty ?? false) &&
        (createRestaurantParams.mneu?.isNotEmpty ?? false)) {
      saveTextEditingController();
      log("create data:${createRestaurantParams.toMap()}");
      emit(CreateResturantLoading(LocaleKeys.creatingRestaurant.tr()));
      final response = await _createREstaurant.call(createRestaurantParams);
      emit(CreateRestaurantCloseLoading());
      response.fold((Failure failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        if (failure is ServerFailure) {
          emit(CreateResturantError(failure.message));
        } else if (failure is UnauthorizedFailure) {
          emit(CreateResturantError(failure.toString()));

          return pleaseLoginDialog(context);
          // AppPages.router.routerDelegate.navigatorKey.currentContext!
          //     .pushNamed(Routes.LOGIN);
        }
        res = 'fail';
      }, (data) {
        res = 'success';
        emit(CreateRestaurantSuccess(LocaleKeys
            .youHaveSubmittedYourRegistrationSuccessfullyWaitingForAdministrationApproval
            .tr()));

        Navigator.pop(context);

        AppPages.router.routerDelegate.navigatorKey.currentContext!
            .read<RestaurantsCubit>()
            .loadData();

        AppPages.router.routerDelegate.pop();

        return res;
      });
    } else {
      log("create data:${createRestaurantParams.toMap()}");
      res = 'fail';
      ScaffoldMessenger.of(
              AppPages.router.routerDelegate.navigatorKey.currentContext!)
          .showSnackBar(SnackBar(
        content: Text(LocaleKeys.completeAllFields.tr()),
        backgroundColor: Colors.red,
      ));
      return res;
    }
    return res;
  }

  updateRestaurant1(context) async {
    CreateRestaurantParams params = createRestaurantParams;

    // List<Map<String, dynamic>> mneu = [];
    // params.mneu?.forEach((element) {
    //   final toMap = {
    //     "foodName": element.foodName,
    //     "picture": element.photo,
    //     "price": element.price,
    //   };
    //   mneu.add(toMap);
    // });
    Map<String, dynamic> data = {
      if (params.name != null) "name": params.name,
      if (params.number != null) "phone": params.number,
      if (params.subcategoryId != null) "subcategoryId": params.subcategoryId,
      if (params.restaurantMedia != null)
        "restaurantMedia": params.restaurantMedia,
      // if (params.licenseMedia!=null) "licenseMedia": params.licenseMedia,
      if (params.government != null) "government": params.government,
      if (params.city != null) "city": params.city,
      // "menu": mneu,
    };

    if ((params.name == null || params.name!.isEmpty) &&
        (params.number == null || params.number!.isEmpty) &&
        (params.subcategoryId == null || params.subcategoryId!.isEmpty) &&
        (params.restaurantMedia == null || params.restaurantMedia!.isEmpty) &&
        (params.government == null || params.government!.isEmpty) &&
        (params.city == null || params.city!.isEmpty)) {
      _validationUpdateState();

      return;
    }

    final result = await _updateRestaurantUseCase(
      UpdateRestaurantParams(
        city: params.city,
        government: params.government,
        subcategoryId: params.subcategoryId,
        name: params.name,
        number: params.number,
        restaurantMedia: params.restaurantMedia,
      ),
    );

    return result.fold(
      (Failure failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data1) {
        Navigator.pop(context);
      },
    );
  }

  Future<void> uploadLicenseFirstPageImage(
      {required BuildContext context}) async {
    await _uploadImage(
      context: context,
      onUploaded: (media) {
        licenseFirstPage = media.file;
        licensRestaurantImagesIds.add(media.mediaId);
        createRestaurantParams.licenseMedia = licensRestaurantImagesIds;
        emit(CreateRestaurantRefreshUI());
      },
    );
  }

  Future<void> uploadLicenseSecondPageImage(
      {required BuildContext context}) async {
    await _uploadImage(
      context: context,
      onUploaded: (media) {
        licenseSecondPage = media.file;
        licensRestaurantImagesIds.add(media.mediaId);
        createRestaurantParams.licenseMedia = licensRestaurantImagesIds;
        emit(CreateRestaurantRefreshUI());
      },
    );
  }

  Future<void> uploadLicenseThiredPageImage(
      {required BuildContext context}) async {
    await _uploadImage(
      context: context,
      onUploaded: (media) {
        licenseThirdPage = media.file;
        licensRestaurantImagesIds.add(media.mediaId);
        createRestaurantParams.licenseMedia = licensRestaurantImagesIds;
        emit(CreateRestaurantRefreshUI());
      },
    );
  }

  Future<void> uploadProfileImage({
    subcategoryId,
    required BuildContext context,
    int? index,
  }) async {
    print(
        "========================================   IN UPLOAD Profile ========================================");
    await _uploadImage(
        subcategoryId: subcategoryId,
        context: context,
        onUploaded: (media) {
          print(
              "========================================${media.mediaId}========================================");
          if (index != null) {
            if (index >= 0 && index < restaurantImages.length) {
              restaurantImages[index] = media.file;
              restaurantImagesIds[index] = media.mediaId;
              log("after :${restaurantImagesIds[index]}");
            }
          } else {
            restaurantImages.add(media.file);
            restaurantImagesIds.add(media.mediaId);
          }

          createRestaurantParams.restaurantMedia = restaurantImagesIds;

          emit(CreateRestaurantUploadProfileImage(restaurantImages));
        });
  }

  Future<void> _getCities(String governorateId) async {
    emit(CreateRestaurantCitiesLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateResturantError(LocaleKeys.cantLoadCities.tr()));
      },
      (data) => emit(CreateRestaurantCitiesLoaded(data)),
    );
  }

  Future<void> _getGovernorates() async {
    if (_shareCubit.governorates.isEmpty) {
      final response = await _getGovernoratesUseCase.call(const NoParams());
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateResturantError(LocaleKeys.cantLoadGovernorates.tr()));
      }, (data) {
        _shareCubit.governorates = data;
        emit(CreateRestaurantGovernoratesLoaded(data));
      });
    } else {
      emit(CreateRestaurantGovernoratesLoaded(_shareCubit.governorates));
    }
  }

  Future<void> _getSubCategories() async {
    if (_shareCubit.subCategories.isEmpty) {
      final response =
          await _getSubSubcategoriesUseCase(params: const PostCommentsParams());
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateResturantError(LocaleKeys.cantLoadSubCategories.tr()));
      }, (data) {
        _shareCubit.subCategories = data;
        emit(CreateResturantSubCategoriesLoaded(data));
      });
    } else {
      emit(CreateResturantSubCategoriesLoaded(_shareCubit.subCategories));
    }
  }

  // ================================= upload images =================================
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded,
      required BuildContext context,
      subcategoryId}) async {
    if (createRestaurantParams.subcategoryId != null ||
        createRestaurantParams.subcategoryId != "" ||
        subcategoryId != null) {
      emit(CreateResturantLoading(LocaleKeys.uploadingImage.tr()));
      await UploadFile().uploadImage(
        useWeChatPicker: true,
        subCategoryId: createRestaurantParams.subcategoryId ??
            subcategoryId ??
            "62c8babb8e28a58a3edf581d",
        onUploaded: (value) {
          onUploaded(value);
        },
        context: context,
      );
      emit(CreateRestaurantCloseLoading());
    } else {
      emit(CreateResturantError(LocaleKeys.selectSubcategoryFirst.tr()));
    }
  }

  _validationState() {
    isSubCategory = (createRestaurantParams.subcategoryId?.isEmpty ?? true);

    emit(ValidationState(
      isCity: createRestaurantParams.city?.isEmpty ?? true,
      isGovernorate: createRestaurantParams.government?.isEmpty ?? true,
      isName: createRestaurantParams.name?.isEmpty ?? true,
      isNumber: createRestaurantParams.name?.isEmpty ?? true,
      isRestaurantPhoto:
          createRestaurantParams.restaurantMedia?.isEmpty ?? true,
      isSubCategory: createRestaurantParams.subcategoryId?.isEmpty ?? true,
      isCommercialPhoto: (createRestaurantParams.licenseMedia?.length ?? 0) < 3,
      isCommercialFirstPage:
          (createRestaurantParams.licenseMedia?.length ?? 0) < 1,
      isCommercialSecondPage:
          (createRestaurantParams.licenseMedia?.length ?? 1) < 2,
      isCommercialThirdPage:
          (createRestaurantParams.licenseMedia?.length ?? 2) < 3,
      isMneu: createRestaurantParams.mneu?.isEmpty ?? true,
    ));
  }

  _validationUpdateState() {
    // isSubCategory = (createRestaurantParams.subcategoryId?.isEmpty ?? true);

    emit(ValidationState(
      isCity: createRestaurantParams.city?.isEmpty ?? true,
      isGovernorate: createRestaurantParams.government?.isEmpty ?? true,
      isName: createRestaurantParams.name?.isEmpty ?? true,
      isNumber: createRestaurantParams.name?.isEmpty ?? true,
      isSubCategory: createRestaurantParams.subcategoryId?.isEmpty ?? true,
    ));
  }
}
