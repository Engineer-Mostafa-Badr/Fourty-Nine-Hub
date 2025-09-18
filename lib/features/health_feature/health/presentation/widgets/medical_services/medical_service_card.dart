import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class HealthMedicalServiceCard extends StatefulWidget {
  final HealthSubcategoryEntity subCategory;

  const HealthMedicalServiceCard({super.key, required this.subCategory});

  @override
  State<HealthMedicalServiceCard> createState() =>
      _HealthMedicalServiceCardState();
}

class _HealthMedicalServiceCardState extends State<HealthMedicalServiceCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        print('subCategory: ${widget.subCategory.id}');
        print(
            'mainCategory: ${context.read<HealthCubit>().state.mainCategory!.id}');
        if (context.read<HealthCubit>().state.mainCategory != null) {
          context.push(
            Routes.ADS,
            extra: AdsViewParams(
                mainCategory: context.read<HealthCubit>().state.mainCategory!,
                subCategory: widget.subCategory),
          );
        }
      },
      child: Container(
        width: 250.h,
        // height: 280.h,
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
            color: AppColors.getFindFillColor(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.subCategory.image,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                        widget.subCategory.isFavorite==true
                            ? Icons.favorite_outlined
                            : Icons.favorite_border,
                        color: Colors.red),
                    onPressed: () {
                      ManageVibration.vibrate();
                      context.read<HealthCubit>().toggleFavoriteSubcategory(widget.subCategory.id);
                      // setState(() {
                      //   widget.subCategory.isFavorite = !(widget.subCategory.isFavorite??false);
                      // });
                    },
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                ),
              ],
            ),
            const Sizer(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      context.isArabic
                          ? widget.subCategory.nameAr
                          : widget.subCategory.nameEn,
                      style: Styles.mediumText(
                          color: AppColors.getTextColor(context)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconAppButton(
                    radius: 20.r,
                    size: 30.h,
                    icon: Icons.add,
                    isCircle: true,
                    color: context.isDarkMode
                        ? AppColors.PRIMARY_COLOR
                        : Colors.white,
                    backColor: AppColors.getButtonPrimaryWhiteColor(context),
                    onPressed: () {
                      ManageVibration.vibrate();
                      print("widget.subCategory.id111 ${widget.subCategory.id}");
                      if (context.read<HealthCubit>().state.mainCategory !=
                              null &&
                          UserCubit.to.isLoggedIn) {
                        context.push(
                          Routes.CREATEAD,
                          extra: CategorizationEntity(
                              mainCategory: context
                                  .read<HealthCubit>()
                                  .state
                                  .mainCategory!,
                              subCategory: widget.subCategory),
                        );
                      } else {
                        return pleaseLoginDialog(context);

                        // context.push(Routes.LOGIN);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
