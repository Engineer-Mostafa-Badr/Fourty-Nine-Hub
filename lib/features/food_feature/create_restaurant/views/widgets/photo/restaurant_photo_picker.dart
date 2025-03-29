import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';

class CreateRestaurantProfilePhotoPicker extends StatefulWidget {
  var subcategoryId;

  CreateRestaurantProfilePhotoPicker({super.key, this.subcategoryId});

  @override
  State<CreateRestaurantProfilePhotoPicker> createState() =>
      _CreateRestaurantProfilePhotoPickerState();
}

class _CreateRestaurantProfilePhotoPickerState
    extends State<CreateRestaurantProfilePhotoPicker> {
  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<RestaurantDashboardCubit>();
    return BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label(
          //   text: LocaleKeys.photoForRestaurant.tr(),
          //   style: Styles.headerText(),
          // ),
          // BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
          //   buildWhen: (previous, current) => previous.files != current.files,
          //   builder: (context, state) {
          //     return Wrap(
          //       runSpacing: 10,
          //       spacing: 10,
          //       children: [
          //         if (state.files?.isNotEmpty ?? false) ...[
          //           ...state.files!.map(
          //                 (e) => ImagePickerPlaceholder(
          //               title: e.path.split('/').last,
          //               image: Image.file(
          //                 File(e.path),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //           ElevatedButton(
          //             onPressed: () {
          //               _updateRestaurantImage(context);
          //             },
          //             child: Text(LocaleKeys.update.tr()),
          //           ),
          //         ],
          //         InkWell(
          //           onTap: () async {
          //             await createRestaurantCubit.uploadProfileImage(
          //                 subcategoryId: widget.subcategoryId, context: context);
          //           },
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Label(text: LocaleKeys.restaurantPhoto.localize,
          //               style: const TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w500
          //               ),
          //               ),
          //               Row(
          //                 spacing: 4,
          //                 children: [
          //                   Label(text: LocaleKeys.update.localize,
          //                     style: const TextStyle(
          //                         fontSize: 16,
          //                         fontWeight: FontWeight.w500
          //                     ),
          //                   ),
          //                   Container(
          //                     width: 44,
          //                     height: 24,
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(100),
          //                       border: Border.all(
          //                         color: AppColors.PRIMARY_COLOR,
          //                         width: 1
          //                       )
          //                     ),
          //                     child: SvgPicture.asset(Assets.arrowUp),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //         // InkWell(
          //         //   onTap: () async {
          //         //     await createRestaurantCubit.uploadProfileImage(
          //         //         subcategoryId: widget.subcategoryId, context: context);
          //         //   },
          //         //   child: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
          //         //     builder: (context, state) {
          //         //       return ImagePickerPlaceholder(
          //         //         title: LocaleKeys.addPhoto.localize,
          //         //         borderColor: (state is ValidationState && (state.isRestaurantPhoto ?? true))
          //         //             ? Colors.red
          //         //             : Colors.grey,
          //         //       );
          //         //     },
          //         //   ),
          //         // ),
          //       ],
          //     );
          //   },
          // ),

          const Sizer(),
          BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
            buildWhen: (previous, current) => previous.files != current.files,
            builder: (context, state) {
              return Column(
                // runSpacing: 10,
                // spacing: 10,
                children: [
                  if (state.files?.isNotEmpty ?? false) ...[
                    ...state.files!.map(
                          (e) => Stack(
                        children: [
                          ImagePickerPlaceholder(
                            title: e.path.split('/').last,
                            image: Image.file(
                              File(e.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                context.read<RestaurantDashboardCubit>().removeFile(e);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (state.files?.isNotEmpty ?? false)
                  AppButton(
                    backColor:context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR,
                    color:AppColors.whiteColor,
                    onPressed: () {
                      _updateRestaurantImage(context);
                    },
                    label: LocaleKeys.update.tr(),
                  ),
                  InkWell(
                    onTap: () async {
                      await createRestaurantCubit.uploadProfileImage(
                          subcategoryId: widget.subcategoryId,
                          context: context
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: LocaleKeys.restaurantPhoto.localize,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),

                        Row(
                          spacing: 4,
                          children: [
                            Label(
                              text: LocaleKeys.update.localize,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 24,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1
                                  )
                              ),
                              child: SvgPicture.asset(Assets.arrowUp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Visibility(
            visible: state is ValidationState && (state.isName ?? true),
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                LocaleKeys.youHaveToUploadAtLeastOnePhoto.localize,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          Visibility(
            visible: state is ValidationState && (state.isName ?? true),
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                LocaleKeys.youHaveToUploadAtLeastOnePhoto.localize,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      );
    });
  }

  void _updateRestaurantImage(BuildContext context) {
    final cubit = context.read<RestaurantDashboardCubit>();
    final imageIds = cubit.restaurantImagesIds; // Get uploaded image IDs
    print("Updated ${imageIds.toList()}");
    cubit.updateRestaurant1(
      params: UpdateRestaurantParams(
        city: null,
        government: null,
        subcategoryId: null,
        name: null,
        number: null,
        restaurantMedia: imageIds, // Send only the image IDs
      ),
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated")),
      );
    });
  }
}
