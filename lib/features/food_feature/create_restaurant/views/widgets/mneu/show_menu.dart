import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

// ignore: must_be_immutable
class ShowMneu extends StatelessWidget {
  final String from;

  ShowMneu({super.key, required this.from});

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
                text: 'Menu',
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
                            (RestaurantMneuModel e) =>
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: .4)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImagePickerPlaceholder(
                                    image: Image.file(
                                      File(e.photoPath ?? ""),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Sizer(),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        e.foodName ?? "",
                                        style: Styles.headerText(
                                            color: Colors.red),
                                      ),
                                      Sizer(height: 50.h),
                                      Text(
                                        "${e.price ?? ""}",
                                        style: Styles.headerText(
                                            color: Colors.red),
                                      ),
                                      Sizer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10),
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
              Sizer(),
              Container(
                // height: MediaQuery.of(context).size.width * 0.5,
                // width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                await createRestaurantCubit
                                    .uploadMealImage(context);
                              },
                              child: BlocBuilder<RestaurantMenuCubit,
                                  RestaurantMenuState>(
                                builder: (context, state) {
                                  if (state is RestaurantMenuImagePicked) {
                                    imagePath = state.imagePath;
                                    return ImagePickerPlaceholder(
                                      image: Image.file(
                                        File(imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                  return Container(
                                    // color: Colors.red,
                                    height: 195.h,
                                    child: ImagePickerPlaceholder(
                                      // width: double.infinity,
                                      tilte: LocaleKeys.photoForMeal.tr(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Sizer(),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return LocaleKeys.emptyFieldNotValid.tr();
                                    }
                                    return null;
                                  },
                                  maxLines: null,
                                  controller: foodNameController,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints.loose(
                                        Size.fromHeight(90.h)),
                                    filled: false,
                                    contentPadding: const EdgeInsets.all(10),
                                    hintText: LocaleKeys.itemName.tr(),
                                    hintStyle: Styles.mediumText(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 32),
                                    // Set the border color to grey
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.red),
                                      // Keep red for error state
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                Sizer(),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return LocaleKeys.emptyFieldNotValid.tr();
                                    }
                                    return null;
                                  },
                                  maxLines: null,
                                  controller: priceController,
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9.]")),
                                  ],
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints.loose(
                                        Size.fromHeight(90.h)),
                                    filled: false,
                                    contentPadding: const EdgeInsets.all(10),
                                    hintText: LocaleKeys.price.tr(),
                                    hintStyle: Styles.mediumText(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 32),
                                    // Set the border color to grey
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.red),
                                      // Keep red for error state
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Sizer(),
                      ElevatedAppButton(
                        onPressed: () {
                          // print("1222222dsvvs23");

                          final foodName = foodNameController.text;
                          final price = double.tryParse(priceController.text);
                          if (foodName.isNotEmpty &&
                              price != null ) {
                            final menuItem = RestaurantMneuModel(
                              // restaurantId:'66ff110be6f198a009c8017e' ,
                              foodName: foodName,
                              price: price,
                              photoPath: imagePath,
                              photo: createRestaurantCubit.imageId,
                            );

                            // print("1222222dsvvs23");

                            context
                                .read<RestaurantMenuCubit>()
                                .addMenuItem(context, menuItem);
                            if (from == 'update') {
                              // context
                              //     .read<RestaurantMenuCubit>()
                              //     .addMenuItem(context, menuItem);

                              context
                                  .read<RestaurantMenuCubit>()
                                  .updateMenuItem(
                                  menuItem,);
                            } else {
                              context
                                  .read<RestaurantMenuCubit>()
                                  .addMenuItem(context, menuItem);
                            }

                            // Clear the input fields
                            foodNameController.clear();
                            priceController.clear();
                          }
                        },
                        label: '',
                        backColor: AppColors.SECONDARY_COLOR,
                        icon: Icons.add,

                        // child: Container(
                        //   alignment: Alignment.center,
                        //   height: MediaQuery.of(context).size.width * .1,
                        //   width: MediaQuery.of(context).size.width * .4,
                        //   padding: const EdgeInsets.all(10),
                        //   decoration: BoxDecoration(
                        //       color: Colors.red,
                        //       borderRadius: BorderRadius.circular(10),
                        //       border: Border.all(width: .4)),
                        //   child:
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: state is ValidationState &&
                          (state.isMneu ?? false),
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
