import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
part 'create_menu_state.dart';

class RestaurantMenuCubit extends Cubit<RestaurantMenuState> {
  RestaurantMenuCubit() : super(RestaurantMenuInitial());

  final List<RestaurantMneuModel> _menu = [];
  List<RestaurantMneuModel> get menu => _menu;

  void addMenuItem(BuildContext context, RestaurantMneuModel menuItem) {
    _menu.add(menuItem);
    emit(RestaurantMenuLoaded(List.from(_menu)));
    context.read<CreateRestaurantCubit>().createRestaurantParams.mneu = _menu;
    print(
        "params: ${context.read<CreateRestaurantCubit>().createRestaurantParams.toJson()}");
  }

  void removeMenuItem(BuildContext context, RestaurantMneuModel index) {
    _menu.remove(index);
    context.read<CreateRestaurantCubit>().createRestaurantParams.mneu = _menu;
    emit(RestaurantMenuLoaded(List.from(_menu)));
  }

  // ================================= upload images =================================
  Future<void> _uploadImage(BuildContext context,
      {required dynamic Function(UploadFileEntity) onUploaded}) async {
    if (context
                .read<CreateRestaurantCubit>()
                .createRestaurantParams
                .subcategoryId !=
            null ||
        context
                .read<CreateRestaurantCubit>()
                .createRestaurantParams
                .subcategoryId !=
            "") {
      emit(RestaurantUpLoadPhototLoading("Uploading Image..."));
      await UploadFile().uploadImage(
        subCategoryId: context
                .read<CreateRestaurantCubit>()
                .createRestaurantParams
                .subcategoryId ??
            "",
        onUploaded: (value) {
          onUploaded(value);
        },
      );
      emit(CreateMenuCloseLoading());
    } else {
      emit(RestaurantMenuError("Select Subcategory First"));
    }
  }

  String imageId = "";
  Future<void> uploadMealImage(BuildContext context) async {
    await _uploadImage(context, onUploaded: (media) {
      imageId = media.mediaId;
      emit(RestaurantMenuImagePicked(media.file.path));
    });
  }

  final foodNameController = TextEditingController();
  final priceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Future<void> close() {
    priceController.dispose();
    foodNameController.dispose();
    imageId = "";
    return super.close();
  }
}
