

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/theme/cubit/cubit.dart';
import '../../../../../../res/style/app_colors.dart';

class HealthSubCategoryCard extends StatefulWidget {
  final HealthSubcategoryEntity subCategory;

  const HealthSubCategoryCard({super.key, required this.subCategory});

  @override
  State<HealthSubCategoryCard> createState() => _HealthSubCategoryCardState();
}

class _HealthSubCategoryCardState extends State<HealthSubCategoryCard> {
    bool isFavorite=false;

  @override
  Widget build(BuildContext context) {
    print(widget.subCategory.id);
    return GestureDetector(
      onTap: () {
        AdInterstitialTop.loadIntersitialAd();
        AdInterstitialTop.showInterstitialAd();
        print("The x ${widget.subCategory.id}");
        serviceLocator<HealthSharedData>().doctorSearchParams.subCategory =
            widget.subCategory;
        context.push(Routes.VISITADOCTORLIST,
            extra: DoctorsListParams(
                fromHome: true, subCategoryId: widget.subCategory.id));
      },
      child:
      Container(
        width: 250.h,
        height: 280.h,
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
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(image: NetworkImage(
                        widget.subCategory.image,

                      ),
                        fit: BoxFit.fill,)
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(isFavorite?Icons.favorite_outlined:Icons.favorite_border, color: Colors.red),
                    onPressed: () {setState(() {
                      isFavorite=!isFavorite;
                    });},
                    visualDensity:const VisualDensity(horizontal: -4,vertical: -4),
                  ),
                ),
              ],
            ),
            const Sizer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.h),
              child: Text(
                context.isArabic?widget.subCategory.nameAr:widget.subCategory.nameEn,
                style: Styles.mediumText(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      )

    );
  }
}
