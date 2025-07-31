import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../photo/restaurant_photo_picker.dart';

// استورد/انسخ هذه الدالة أو اجعلها في ملف:

class ShowMneu extends StatelessWidget {
  final String? subcategoryId;
  final String? restaurantId;

  ShowMneu({super.key, this.subcategoryId, this.restaurantId});

  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    final menuCubit = context.read<RestaurantMenuCubit>();

    return BlocBuilder<RestaurantMenuCubit, RestaurantMenuState>(
      builder: (context, state) {
        return Form(
          key: menuCubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // إذا كانت قائمة الأطباق (menu) غير فارغة
              if (menuCubit.menu.isNotEmpty) ...[
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      // عرض القائمة
                      ...menuCubit.menu.map(
                        (RestaurantMneuModel e) => Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: .5, color: Colors.black),
                          ),
                          child: Column(children: [
                            Center(
                              child: Label(
                                text: LocaleKeys.menu.localize,
                                style: Styles.headerText(color: Colors.red),
                              ),
                            ),
                            16.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // الصورة
                                Column(
                                  children: [
                                    buildPhotoBox(
                                        width: 200.w,
                                        context: context,
                                        isAddBox: false, // لأنها صورة موجودة
                                        image: XFile(e.photoPath ?? ""),
                                        onTap:
                                            () {}, // لا يوجد منطق لتغيير الصورة
                                        onDelete:
                                            null // نحذف العنصر من الزر "Remove" أدناه
                                        ),
                                    8.verticalSpace,
                                    Text(
                                      context.isArabic ? "وجبة" : "Meal",
                                      style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                const Sizer(),
                                // باقي معلومات العنصر
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.w, vertical: 20.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:AppColors.getFillColor(context)),
                                        child: Row(
                                          children: [
                                            Text(
                                              e.foodName ?? "",
                                              style: Styles.mediumText(
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Sizer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.w, vertical: 20.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:AppColors.getFillColor(context),
                                      ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${e.price ?? ""}",
                                              style: Styles.mediumText(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Sizer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.getRedColor(context),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          minimumSize: const Size(100, 40),
                                          maximumSize: const Size(100, 40),
                                        ),
                                        onPressed: () {
                                          menuCubit.removeMenuItem(context, e);
                                        },
                                        child:  Text(
                                          LocaleKeys.remove.localize,
                                          style: Styles.mediumText(
                                            color: AppColors.getReversedTextColor(context)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Sizer(),

              // فورم إضافة عنصر جديد
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: .5, color: Colors.black),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Label(
                          text: LocaleKeys.menu.localize,
                          style: Styles.headerText(color: AppColors.getRedColor(context)),
                        ),
                      ),
                      16.verticalSpace,
                      // صف يحوي صورة العنصر + حقول النص
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // الصورة
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                // استدعاء اختيار الصورة
                                await menuCubit.uploadMealImage(
                                  context,
                                  subcategoryId: subcategoryId,
                                );
                              },
                              child: Column(
                                children: [
                                  BlocBuilder<RestaurantMenuCubit,
                                      RestaurantMenuState>(
                                    builder: (context, state) {
                                      // إن كان لدينا صورةPicked، نحفظ path في imagePath
                                      if (state is RestaurantMenuImagePicked) {
                                        imagePath = state.imagePath;
                                      }

                                      // التحقق هل الصورة فارغة أم لا
                                      final bool noImageYet = imagePath.isEmpty;

                                      return buildPhotoBox(
                                        width: 200.w,
                                        context: context,
                                        isAddBox: noImageYet,
                                        image: noImageYet
                                            ? null
                                            : XFile(imagePath),
                                        onTap: () async {
                                          // نفس onTap أعلاه
                                          await menuCubit.uploadMealImage(
                                              context,
                                              subcategoryId: subcategoryId ??  "62c8babb8e28a58a3edf581d");
                                        },
                                        onDelete:
                                            null, // لا يوجد حذف للصورة قبل إضافة العنصر
                                      );
                                    },
                                  ),
                                  8.verticalSpace,
                                  Text(
                                    context.isArabic ? "وجبة" : "Meal",
                                    style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Sizer(
                            width: 30,
                          ),
                          // حقول الاسم والسعر
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  style: Styles.mediumText(
                                    color:  AppColors.getTextColor(context)
                                  ),
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
                                    contentPadding: const EdgeInsets.all(10),
                                    hintText: LocaleKeys.itemName.tr(),
                                    hintStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                                    fillColor: AppColors.getFillColor(context),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                const Sizer(),
                                TextFormField(
                                  style: Styles.mediumText(
                                      color:  AppColors.getTextColor(context)

                                  ),
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
                                  inputFormatters: [],
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints.loose(
                                        Size.fromHeight(90.h)),
                                    contentPadding: const EdgeInsets.all(10),
                                    hintText: LocaleKeys.price.tr(),
                                    hintStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                                    fillColor:  AppColors.getFillColor(context),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                const Sizer(),

                                // زر الإضافة
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 210.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                          AppColors.getRedColor(context),
                                        ),
                                        child: IconButton(
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () {
                                            final foodName =
                                                foodNameController.text;
                                            final price = double.tryParse(
                                                priceController.text);

                                            if (menuCubit.formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              if (foodName.isNotEmpty &&
                                                  price != null) {
                                                final menuItem =
                                                    RestaurantMneuModel(
                                                  foodName: foodName,
                                                  price: price,
                                                  photoPath: imagePath,
                                                  photo: menuCubit
                                                      .imageId, // من الـcubit
                                                );

                                                context
                                                    .read<RestaurantMenuCubit>()
                                                    .addMenuItem(
                                                        context, menuItem);

                                                // نظف الحقول
                                                foodNameController.clear();
                                                priceController.clear();
                                                imagePath = "";
                                                menuCubit.imageId = "";

                                                // قد تريد إعادة بناء واجهة الإضافة كي تعود الصورة لإيقونة
                                                menuCubit.emit(
                                                    RestaurantMenuImagePicked(
                                                        ""));
                                              }
                                            }
                                          },
                                          icon: Icon(Icons.add),
                                          color: AppColors.getReversedTextColor(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // في حال الخطأ - لم يضف أي عنصر
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                builder: (context, restState) {
                  return Visibility(
                    visible: restState is ValidationState &&
                        (restState.isMneu ?? false),
                    child:  Padding(
                      padding:const EdgeInsets.only(right: 5, left: 5, top: 5.0),
                      child: Text(
                        context.isArabic?'يجب ملء عنصر واحد على الاقل!':"You have to fill at least one item!",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
