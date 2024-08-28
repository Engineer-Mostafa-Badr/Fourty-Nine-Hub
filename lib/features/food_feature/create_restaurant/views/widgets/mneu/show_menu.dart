import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
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
        return Form(
          key: createRestaurantCubit.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: LocaleKeys.mneu.tr(),
                style: Styles.headerText(color: Colors.red),
              ),
              if (createRestaurantCubit.menu.isNotEmpty) ...[
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      /// show data
                      ...createRestaurantCubit.menu.map(
                        (RestaurantMneuModel e) => Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: .4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImagePickerPlaceholder(
                                fit: BoxFit.cover,
                                image: XFile(e.photoPath ?? ""),
                              ),
                              const Sizer(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    e.foodName ?? "",
                                    style: Styles.headerText(color: Colors.red),
                                  ),
                                  const Sizer(height: 50),
                                  Text(
                                    "${e.price ?? ""}",
                                    style: Styles.headerText(color: Colors.red),
                                  ),
                                  const Sizer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: const Size(100, 40),
                                      maximumSize: const Size(100, 40),
                                    ),
                                    onPressed: () {
                                      createRestaurantCubit.removeMenuItem(
                                          context, e);
                                    },
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                              fit: BoxFit.cover,
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
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.emptyFieldNotValid.tr();
                        }
                        return null;
                      },
                      controller: foodNameController,
                      decoration: InputDecoration(
                        filled: false,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: LocaleKeys.itemName.tr(),
                        hintStyle: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const Sizer(),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.emptyFieldNotValid.tr();
                        }
                        return null;
                      },
                      controller: priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: InputDecoration(
                        filled: false,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: LocaleKeys.price.tr(),
                        hintStyle: const TextStyle(color: Colors.red),
                      ),
                    ),
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
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: .4)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, state) {
                return Visibility(
                  visible: state is ValidationState && (state.isMneu ?? false),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
                    child: Text(
                      "You have to fill at least one item!",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              })
            ],
          ),
        );
      },
    );
  }
}
