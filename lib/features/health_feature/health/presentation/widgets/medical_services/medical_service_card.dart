import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
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
              color: AppColors.PRIMARY_COLOR,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
            color: AppColors.GREYBG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 220.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.subCategory.image,
                        ),
                        fit: BoxFit.fill,
                      )),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                        isFavorite
                            ? Icons.favorite_outlined
                            : Icons.favorite_border,
                        color: Colors.red),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                ),
              ],
            ),
            const Sizer(height: 8,),
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
                      style: Styles.mediumText(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconAppButton(
                    radius: 20.r,
                    size: 30.h,
                    icon: Icons.add,
                    isCircle: true,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
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
                        context.push(Routes.LOGIN);
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

//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
// import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
// import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:go_router/go_router.dart';
//
// class HealthMedicalServiceCard extends StatelessWidget {
//   final HealthSubcategoryEntity subCategory;
//
//   const HealthMedicalServiceCard({super.key, required this.subCategory});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (context.read<HealthCubit>().state.mainCategory != null) {
//           context.push(
//             Routes.ADS,
//             extra: AdsViewParams(
//                 mainCategory: context.read<HealthCubit>().state.mainCategory!,
//                 subCategory: subCategory),
//           );
//         }
//       },
//       child: Card(
//         elevation: 1,
//         margin: EdgeInsetsDirectional.only(
//             end: 10.w, bottom: 10.h, top: 10.h, start: 5.w),
//         child: Container(
//           width: 0.55.sw,
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 2,
//                   offset: const Offset(0, 3),
//                 ),
//               ]),
//           child: Column(
//             children: [
//               Expanded(
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: Stack(
//                       children: [
//                         Positioned.fill(
//                           child: SquareImage(
//                             fit: BoxFit.fitWidth,
//                             radius: 10,
//                             url: subCategory.image,
//                           ),
//                         ),
//                         if (UserCubit.to.isLoggedIn)
//                           Positioned(
//                               top: 5,
//                               right: 5,
//                               child: IconAppButton(
//                                   size: 20,
//                                   icon: subCategory.isFavorite == true
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: ThemeCubit.get(context).isDarkTheme
//                                       ? AppColors.QUANTITY_COLOR
//                                       : AppColors.PRIMARY_COLOR_DARK,
//                                   onPressed: () {
//                                     print(
//                                         "555555555555555555555555555555555555555555555555${subCategory.id}");
//                                     context
//                                         .read<HealthCubit>()
//                                         .toggleFavoriteMedicalService(
//                                         subCategory.id);
//                                   }))
//                       ],
//                     ),
//                   )),
//               const Sizer(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Label(
//                     text: context.isArabic
//                         ? subCategory.nameAr
//                         : subCategory.nameEn,
//                     style: Styles.mediumText(fontWeight: FontWeight.bold),
//                   ),
//                   IconAppButton(
//                     icon: Icons.add,
//                     isCircle: true,
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                     backColor: AppColors.PRIMARY_COLOR,
//                     onPressed: () {
//                       if (context.read<HealthCubit>().state.mainCategory !=
//                           null &&
//                           UserCubit.to.isLoggedIn) {
//                         context.push(
//                           Routes.CREATEAD,
//                           extra: CategorizationEntity(
//                               mainCategory: context
//                                   .read<HealthCubit>()
//                                   .state
//                                   .mainCategory!,
//                               subCategory: subCategory),
//                         );
//                       } else {
//                         context.push(Routes.LOGIN);
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
