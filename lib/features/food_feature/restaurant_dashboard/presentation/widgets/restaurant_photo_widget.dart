import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/images/image_picker_placeholder.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../create_restaurant/cubit/create_restaurant_cubit.dart';
import '../../domain/usecases/update_restaurant_usecase.dart';
import '../cubit/restaurant_dashboard_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';

class RestaurantPhotoPicker extends StatefulWidget {
  var subcategoryId;

  RestaurantPhotoPicker({super.key, this.subcategoryId});

  @override
  State<RestaurantPhotoPicker> createState() => _RestaurantPhotoPickerState();
}

class _RestaurantPhotoPickerState extends State<RestaurantPhotoPicker> {
  bool _showPic = false;
  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<RestaurantDashboardCubit>();
    return BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Sizer(),
          BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
            buildWhen: (previous, current) => previous.files != current.files,
            builder: (context, state) {
              return Column(
                // runSpacing: 10,
                // spacing: 10,
                children: [
                  if (((state.files?.isNotEmpty ?? false) && _showPic)) ...[
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
                                ManageVibration.vibrate();
                                context
                                    .read<RestaurantDashboardCubit>()
                                    .removeFile(e);
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
                    const Sizer(),
                  ],
                  if ((state.files?.isNotEmpty ?? false) && _showPic) ...[
                    AppButton(
                      backColor: AppColors.getRedColor(context),
                      color: AppColors.whiteColor,
                      onPressed: () {
                        ManageVibration.vibrate();
                        _updateRestaurantImage(context);
                      },
                      label: LocaleKeys.update.localize,
                    ),
                    const Sizer(),
                  ],
                  InkWell(
                    onTap: () async {
                      ManageVibration.vibrate();
                      await createRestaurantCubit.uploadProfileImage(
                          subcategoryId: widget.subcategoryId,
                          context: context);
                      setState(() {
                        _showPic = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: LocaleKeys.restaurantPhoto.localize,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            Label(
                              text: LocaleKeys.update.localize,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Container(
                              width: 44,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: AppColors.getButtonPrimaryWhiteColor(
                                      context),
                                  width: 1,
                                ),
                              ),
                              child: Image.asset(
                                Assets.uploadImage,
                                color: AppColors.getButtonPrimaryWhiteColor(
                                  context,
                                ),
                              ),
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
    cubit
        .updateRestaurant1(
      params: UpdateRestaurantParams(
        city: null,
        government: null,
        subcategoryId: null,
        name: null,
        number: null,
        restaurantMedia: imageIds, // Send only the image IDs
      ),
    )
        .then((_) {
      setState(() {
        _showPic = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: AppColors.getFindFillColor(context),
            content: Text(
              context.isArabic ? 'تم التحديث' : "Updated",
              style: TextStyle(color: AppColors.getTextColor(context)),
            )),
      );
    });
  }
}
