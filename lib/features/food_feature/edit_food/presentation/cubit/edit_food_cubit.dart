import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../restaurant_details/domain/usecases/add_food_usecase.dart';
import '../../../restaurant_details/domain/usecases/delete_food_usecase.dart';
import '../../../restaurant_details/domain/usecases/get_meals_usecase.dart';
import '../../../restaurant_details/domain/usecases/get_restaurant_details_usecase.dart';
import '../../../restaurants_list/data/models/is_restaurant_model.dart';
import '../../../restaurants_list/data/models/restaurant_mneu_model.dart';
import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../../restaurants_list/domain/entities/restaurant_mneu.dart';
import '../../../restaurants_list/domain/usecases/is_resturant_usecase.dart';

part 'edit_food_state.dart';

class EditFoodCubit extends Cubit<EditFoodState> {
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  final GetMealsUseCase _getMealsUseCase;
  final AddFoodUseCase _addFoodUseCase;
  final DeleteFoodUseCase _deleteFoodUseCase;
  final IsResturantUsecase _isResturantUseCase;

  bool isLoadingMore = false;

  bool hasMoreData = true;

  int currentPage = 1;

  int pageSize = 10;
  List<RestaurantMenu> menu = [];
  List<XFile> restaurantImages = [];
  List<String> restaurantImagesIds = [];
  String imageId = "";

  // Future<void> uploadMealImage(BuildContext context, {subcategoryId}) async {
  //   await _uploadImage(context, subcategoryId: subcategoryId,
  //       onUploaded: (media) {
  //     imageId = media.mediaId;
  //     emit(state.copyWith(imagePath: media.file.path));
  //   });
  // }

  UserEntity? user;

  EditFoodCubit(this._getRestaurantDetailsUseCase, this._getMealsUseCase,
      this._deleteFoodUseCase, this._addFoodUseCase, this._isResturantUseCase)
      : super(const EditFoodState());

  Future<void> getMeals({required String id, required bool first}) async {
    if (first == true) emit(state.copyWith(status: EditFoodStates.loading));

    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getMealsUseCase(
        GetMealsParams(restaurantId: id, page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: EditFoodStates.error));
      },
      (data) {
        menu.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: EditFoodStates.success, meals: data));
      },
    );
  }

  Future<void> getRestaurantDetails({required String id}) async {
    final response = await _getRestaurantDetailsUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: EditFoodStates.error));
    }, (data) async {
      emit(state.copyWith(restaurant: data));
    });
  }

  Future<void> isRestaurant() async {
    if (user != null) {
      final response = await _isResturantUseCase.call(const NoParams());
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(status: EditFoodStates.error));
      }, (data) {
        print('sadafasfasvsdvd$data');
        emit(state.copyWith(isResturant: data));
      });
    } else {
      emit(state.copyWith(
          isResturant:
              IsRestaurantModel(isRestaurant: false, approved: false)));
    }
  }

  loadData({required String id, required bool first}) async {
    // menu.clear();
    await getMeals(id: id, first: first);
    await _getUser();
    await isRestaurant();
  }

  // Future<void> getMeals({required String id,required bool first}) async {
  //   if(first==true)emit(state.copyWith(status: EditFoodStates.loading));
  //   final response = await _getMealsUseCase(id);
  //   response.fold(
  //           (failure) => emit(state.copyWith(
  //           failure: failure, status: EditFoodStates.error)),
  //           (data) async{
  //             await getRestaurantDetails(id: id);
  //             emit(state.copyWith(
  //            status: EditFoodStates.success,meals: data));
  //           });
  // }

  Future<bool> removeItem(
      {required String foodId, required BuildContext context}) async {
    final res = await _deleteFoodUseCase(foodId);
    bool result = false;
    res.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete item')),
        );
      },
      (r) async {
        result = true;
      },
    );

    return result;
  }

  updateMenuItem(context, RestaurantMneuModel menuItem,
      {required String id}) async {
    AddFoodParams params = AddFoodParams(
      foodName: menuItem.foodName ?? '',
      price: menuItem.price ?? 0.0,
      photo: imageId, // Use the stored image ID here
      // subcategory: state.isResturant!.subCategoryId!,
    );
    print("Here ${menuItem.photo}");
    final response = await _addFoodUseCase(params);
    return response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(status: EditFoodStates.error));
      },
      (data) {
        menu.insert(0, data);
        emit(state.copyWith(
            status: EditFoodStates.success, meals: menu, imagePath: ''));
      },
    );
  }

  Future<void> uploadProfileImage(
      {subcategoryId, required BuildContext context}) async {
    await _uploadImage(
      subcategoryId: subcategoryId,
      context: context,
      onUploaded: (media) {
        restaurantImages.add(media.file);
        restaurantImagesIds.add(media.mediaId);

        // Store the image ID
        imageId = media.mediaId;

        emit(state.copyWith(
            files: restaurantImages, imagePath: media.file.path));
      },
    );
  }

  Future<void> _getUser() async {
    user = serviceLocator<UserCubit>().state.data;
    // await serviceLocator<UserCubit>()
    //     .getUser()
    //     .then((Either<Failure, UserEntity>? value) {
    //   value?.fold(
    //     (failure) => print("Failed to get user: $failure"),
    //     (u) => user = u,
    //   );
    // });
  }

  // ================================= upload images =================================
  // Future<void> _uploadImage(BuildContext context,
  //     {required dynamic Function(UploadFileEntity) onUploaded,
  //     String? subcategoryId}) async {
  //   await UploadFile().uploadImage(
  //     subCategoryId: subcategoryId ?? '',
  //     onUploaded: (value) {
  //       onUploaded(value);
  //     }, context: context,
  //   );
  // }
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded,
      required BuildContext context,
      subcategoryId}) async {
    // if (createRestaurantParams.subcategoryId != null ||
    //     createRestaurantParams.subcategoryId != "" ||
    //     subcategoryId != null) {
    //   emit(state.copyWith(uploadImageError:LocaleKeys.uploadingImage.tr()));
    await UploadFile().uploadImage(
      subCategoryId: subcategoryId ?? '',
      // createRestaurantParams.subcategoryId ?? subcategoryId ?? '',
      onUploaded: (value) {
        onUploaded(value);
      },
      context: context,
    );
    // emit(CreateRestaurantCloseLoading());
    // } else {
    //   emit(state.copyWith(uploadImageError:LocaleKeys.selectSubcategoryFirst.tr()));
    // }
  }
}
