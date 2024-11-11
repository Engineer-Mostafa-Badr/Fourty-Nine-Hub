import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/add_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_restaurant_details_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';


part 'edit_food_state.dart';

class EditFoodCubit extends Cubit<EditFoodState> {
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  final GetMealsUseCase _getMealsUseCase;
  final AddFoodUseCase _addFoodUseCase;
  final DeleteFoodUseCase _deleteFoodUseCase;

  EditFoodCubit(this._getRestaurantDetailsUseCase, this._getMealsUseCase, this._deleteFoodUseCase, this._addFoodUseCase)
      : super( EditFoodState());

  loadData({required String id,required bool first}) async {
    await getMeals(id: id,first: first);

  }

  Future<void> getRestaurantDetails({required String id}) async {
    final response = await _getRestaurantDetailsUseCase(id);
    response.fold(
            (failure) => emit(state.copyWith(
            failure: failure, status: EditFoodStates.error)),
            (data) async{
              emit(state.copyWith(
             restaurant: data));
            });
  }


  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;
  List<RestaurantMenu> menu=[];

  Future<void> getMeals({required String id,required bool first}) async {
    if(first==true)emit(state.copyWith(status: EditFoodStates.loading));

    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getMealsUseCase(GetMealsParams(restaurantId: id, page: currentPage, limit: pageSize));

    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: EditFoodStates.error)),
          (data) {
        menu.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: EditFoodStates.success,meals: data));
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

  Future<bool> removeItem({required String foodId,required BuildContext context}) async {
    final res = await _deleteFoodUseCase(foodId);
    bool result = false;
    res.fold(
          (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete item')),
        );
      },
          (r) async {
        result=true;
      },
    );

    return result;
  }



  // ================================= upload images =================================
  Future<void> _uploadImage(BuildContext context,
      {required dynamic Function(UploadFileEntity) onUploaded,
        String? subcategoryId}) async {

      await UploadFile().uploadImage(
        subCategoryId: subcategoryId??'' ,
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
          emit(state.copyWith(imagePath:media.file.path));
        });
  }

  updateMenuItem(context,RestaurantMneuModel menuItem) async {
    AddFoodParams params = AddFoodParams(
      foodName: menuItem.foodName??'',
      price: menuItem.price??0.0,
      photo: menuItem.photo??'',
    );
    final response = await _addFoodUseCase(params);
    return response.fold(
          (failure) {},
          (data) {
        print("${data}v");
      },
    );
  }

}
