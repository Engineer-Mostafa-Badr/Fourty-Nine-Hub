import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/messages/messages.dart';
import '../../../restaurants_list/data/models/restaurant_mneu_model.dart';
import '../create_resturant_cubit.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'create_menu_state.dart';

class RestaurantMenuCubit extends Cubit<RestaurantMenuState> {
  final ApiConsumer apiConsumer;

  RestaurantMenuCubit(this.apiConsumer) : super(RestaurantMenuInitial());

  final List<RestaurantMneuModel> _menu = [];

  List<RestaurantMneuModel> get menu => _menu;

  updateMenuItem(context, RestaurantMneuModel menuItem) async {
    Map<String, dynamic> data = {
      "picture": menuItem.photo,
      "price": menuItem.price,
      "foodName": menuItem.foodName
    };
    var url = 'https://49backend.com/api/v1/food/add-food';

    final response = await apiConsumer.post(url, data: data);

    return response.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        // return Left(failure);
      },
      (data) {
        showSuccessMessage(context, data['message']);
        print("${data}v");
      },
    );
  }

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
      {required dynamic Function(UploadFileEntity) onUploaded,
      String? subcategoryId}) async {
    if (context
                .read<CreateRestaurantCubit>()
                .createRestaurantParams
                .subcategoryId !=
            null ||
        context
                .read<CreateRestaurantCubit>()
                .createRestaurantParams
                .subcategoryId !=
            "" ||
        subcategoryId != null ||
        subcategoryId! != '') {
      emit(RestaurantUpLoadPhototLoading("Uploading Image..."));
      await UploadFile().uploadImage(
        useWeChatPicker: true,
        subCategoryId: context
                .read<CreateRestaurantCubit>()
                .createRestaurantParams
                .subcategoryId ??
            subcategoryId ??
            '',
        onUploaded: (value) {
          onUploaded(value);
        }, context: context,
      );
      emit(CreateMenuCloseLoading());
    } else {
      emit(RestaurantMenuError("Select Subcategory First"));
    }
  }

  String imageId = "";

  Future<void> uploadMealImage(BuildContext context, {subcategoryId}) async {
       print("========================================   IN UPLOAD MEAL ========================================");
    await _uploadImage(context, subcategoryId: subcategoryId,
        onUploaded: (media) {
          print("========================================${media.mediaId}========================================");
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
