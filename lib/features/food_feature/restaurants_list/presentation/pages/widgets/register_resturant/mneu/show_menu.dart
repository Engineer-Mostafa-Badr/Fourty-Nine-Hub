import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/mneu/name/food_name_text_form_field.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/mneu/name/price_text_form_field.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class ShowMneu extends StatelessWidget {
  ShowMneu({super.key});

  TextEditingController foodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String imagePath = "";
  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<RestaurantMenuCubit>();
    return BlocBuilder<RestaurantMenuCubit, RestaurantMenuState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: LocaleKeys.mneu.tr(),
              style: Styles.headerText(),
            ),
            if (state is RestaurantMenuLoaded) ...[
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  /// show data
                  ...state.menu.map(
                    (RestaurantMneuModel e) => Container(
                      height: MediaQuery.of(context).size.width * .2,
                      width: MediaQuery.of(context).size.width * .42,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: .4)),
                      child: Row(
                        children: [
                          ImagePickerPlaceholder(
                            image: XFile(e.photoPath ?? ""),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            children: [
                              Text(e.foodName ?? ""),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("${e.price ?? ""}"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const Sizer(),
            Container(
              height: MediaQuery.of(context).size.width * .8,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: .4)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await createRestaurantCubit.uploadMealImage(context);
                    },
                    child:
                        BlocBuilder<RestaurantMenuCubit, RestaurantMenuState>(
                      builder: (context, state) {
                        if (state is RestaurantMenuImagePicked) {
                          imagePath = state.imagePath;
                          return ImagePickerPlaceholder(
                            image: XFile(state.imagePath),
                          );
                        }
                        return ImagePickerPlaceholder(
                          title: LocaleKeys.photoForMeal.tr(),
                        );
                      },
                    ),
                  ),
                  const Sizer(),
                  FoodNameTextFormField(
                    currentController: foodNameController,
                  ),
                  const Sizer(),
                  PriceTextFormField(currentController: priceController),
                  const Sizer(),
                  const Sizer(),
                  GestureDetector(
                    onTap: () {
                      final foodName = foodNameController.text;
                      final price = double.tryParse(priceController.text);
                      if (foodName.isNotEmpty &&
                          price != null &&
                          imagePath.isNotEmpty) {
                        final menuItem = RestaurantMneuModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          foodName: foodName,
                          price: price,
                          photoPath: imagePath,
                          photo: createRestaurantCubit.imageId,
                        );

                        context
                            .read<RestaurantMenuCubit>()
                            .addMenuItem(context, menuItem);

                        // Clear the input fields
                        foodNameController.clear();
                        priceController.clear();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width * .1,
                      width: MediaQuery.of(context).size.width * .4,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: .4)),
                      child: const Icon(
                        Icons.add,
                        size: 33,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
