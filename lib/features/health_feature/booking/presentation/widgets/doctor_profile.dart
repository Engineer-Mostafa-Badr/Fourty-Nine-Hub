import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDoctorProfileWidget extends StatelessWidget {
  const BookingDoctorProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<BookDoctorAppointmentCubit>().doctor;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cardDarkColor(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileImage(
            userId: '',
            accountId: 0,
            size: 50,
            imageURL: doctor.image,
          ),
          Sizer(height: 16.h),
          Text(
            '${LocaleKeys.doctor.localize} ${toBeginningOfSentenceCase(doctor.fullName)}',
            style: Styles.headerText(),
          ),
          Sizer(height: 8.h),
          Text(
            doctor.description,
            overflow: TextOverflow.fade,
            maxLines: 2,
            softWrap: false,
            style: Styles.mediumText(),
          ),
        ],
      ),
    );
  }
}
