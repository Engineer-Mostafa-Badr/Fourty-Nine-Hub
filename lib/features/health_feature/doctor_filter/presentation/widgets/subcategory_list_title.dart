import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/app_colors.dart';

class SubcategoryListTitle extends StatelessWidget {
  final SubCategoryEntity specialty;

  const SubcategoryListTitle(
      {super.key, required this.specialty, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        serviceLocator<HealthSharedData>().doctorSearchParams.subCategory =
            specialty;
        if (serviceLocator<HealthSharedData>().doctorSearchParams.bookingType ==
            BookingTypes.call) {
          context.push(Routes.VISITADOCTORLIST,
              extra: DoctorsListParams(
                  fromHome: false, subCategoryId: '', type: type));
        } else {
          context.push(Routes.FILTERDOCTORGOVERNORATE, extra: type);
        }
      },
      child: Container(
        width: 750.w,
        height: 140.h,
        decoration: BoxDecoration(
          color: AppColors.BG_GRAY_COLOR,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(width: 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: ImageFromInternet(
                  image: specialty.image, height: 140.h, width: 160.w),
            ),
            const Sizer(width: 20),
            Label(
              text: context.isArabic ? specialty.nameAr : specialty.nameEn,
              style: Styles.headerText(),
            ),
          ],
        ),
      ),
    );
  }
}
