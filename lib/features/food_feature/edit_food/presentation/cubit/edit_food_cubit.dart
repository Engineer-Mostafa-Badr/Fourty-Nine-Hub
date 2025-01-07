import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/add_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_restaurant_details_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

part 'edit_food_state.dart';

class EditFoodCubit extends Cubit<EditFoodState> {
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  final GetMealsUseCase _getMealsUseCase;
  final AddFoodUseCase _addFoodUseCase;
  final DeleteFoodUseCase _deleteFoodUseCase;
  final IsResturantUsecase _isResturantUseCase;

  EditFoodCubit(this._getRestaurantDetailsUseCase, this._getMealsUseCase,
      this._deleteFoodUseCase, this._addFoodUseCase, this._isResturantUseCase)
      : super(const EditFoodState());

  loadData({required String id, required bool first}) async {
    // menu.clear();
    await getMeals(id: id, first: first);
    await _getUser();
    await isRestaurant();
  }

  Future<void> getRestaurantDetails({required String id}) async {
    final response = await _getRestaurantDetailsUseCase(id);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: EditFoodStates.error)),
        (data) async {
      emit(state.copyWith(restaurant: data));
    });
  }

  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;
  List<RestaurantMenu> menu = [];

  Future<void> getMeals({required String id, required bool first}) async {
    if (first == true) emit(state.copyWith(status: EditFoodStates.loading));

    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getMealsUseCase(
        GetMealsParams(restaurantId: id, page: currentPage, limit: pageSize));

    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: EditFoodStates.error)),
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

  // ================================= upload images =================================
  Future<void> _uploadImage(BuildContext context,
      {required dynamic Function(UploadFileEntity) onUploaded,
      String? subcategoryId}) async {
    await UploadFile().uploadImage(
      subCategoryId: subcategoryId ?? '',
      onUploaded: (value) {
        onUploaded(value);
      },
    );
  }

  String imageId = "";

  Future<void> uploadMealImage(BuildContext context, {subcategoryId}) async {
    await _uploadImage(context, subcategoryId: subcategoryId,
        onUploaded: (media) {
      imageId = media.mediaId;
      emit(state.copyWith(imagePath: media.file.path));
    });
  }

  UserEntity? user;
  Future<void> _getUser() async {
    await serviceLocator<UserCubit>()
        .getUser()
        .then((Either<Failure, UserEntity>? value) {
      value?.fold(
        (failure) => print("Failed to get user: $failure"),
        (u) => user = u,
      );
    });
  }

  Future<void> isRestaurant() async {
    if (user != null) {
      final response = await _isResturantUseCase.call(const NoParams());
      response
          .fold((failure) => emit(state.copyWith(status: EditFoodStates.error)),
              (data) {
        print('sadafasfasvsdvd$data');
        emit(state.copyWith(isResturant: data));
      });
    } else {
      emit(state.copyWith(
          isResturant:
              IsRestaurantModel(isRestaurant: false, approved: false)));
    }
  }

  updateMenuItem(context, RestaurantMneuModel menuItem,
      {required String id}) async {
    AddFoodParams params = AddFoodParams(
      foodName: menuItem.foodName ?? '',
      price: menuItem.price ?? 0.0,
      photo: menuItem.photo ?? '',
      subcategory: state.isResturant!.subCategoryId!,
    );
    final response = await _addFoodUseCase(params);
    return response.fold(
      (failure) {},
      (data) {
        menu.insert(0, data);
        emit(state.copyWith(
            status: EditFoodStates.success, meals: menu, imagePath: ''));
      },
    );
  }
}
