import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/pages/DoctorDetails.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  const DoctorCard({super.key, required this.doctor, required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(UserCubit.to.isLoggedIn){
          context.push(Routes.VISITADOCTORDETAILS, extra:DoctorDetailsParams(doctorId: doctor.id,fromSearch: false,type: type));
        }else{
          context.push(Routes.LOGIN);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: cardDarkColor(context),
            border: Border.all(color: AppColors.LIGHT_GRAY_COLOR),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileImage(
                        userId: '',
                        accountId: 0,
                        size: 25,
                        imageURL: doctor.image,
                      ),
                      const Sizer(),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  toBeginningOfSentenceCase(doctor.fullName) ??
                                      '',
                                  style: Styles.mediumText()),
                              RatingStars(
                                rating: doctor.rating.toDouble(),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                if(doctor.classification!='NotSubscribed')Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: doctor.isPremium ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: doctor.isPremium ? Colors.amber : Colors.grey,
                      width: 2.0,
                    ),
                    boxShadow: doctor.isPremium
                        ? [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    doctor.classification== "Regular subscription"? LocaleKeys.regular.localize : LocaleKeys.premium.localize,
                    style: TextStyle(
                      color: doctor.isPremium ? Colors.amber : Colors.grey,
                      fontWeight: doctor.isPremium
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            const Sizer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.userDoctor,
                ),
                const Sizer(),
                Expanded(
                    child: ReadMoreLabel(
                  text: doctor.description,
                  trimLines: 1,
                      style: Styles.mediumText(color: context.isDarkMode?null:AppColors.PRIMARY_COLOR),
                ))
              ],
            ),
            const Sizer(),
            Row(
              children: [
                const Icon(
                  Icons.attach_money_sharp,
                ),
                const Sizer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(doctor.clinicPrice.isNotEmpty)Label(
                        text: '${LocaleKeys.clinicFees.localize}: ${doctor.clinicPrice} ${context.isArabic?doctor.currencyAr:doctor.currencyEn}',
                        style: Styles.mediumText(),
                      ),
                      if(doctor.callsPrice.isNotEmpty)Label(
                        text: '${LocaleKeys.callFees.localize}: ${doctor.callsPrice} ${context.isArabic?doctor.currencyAr:doctor.currencyEn}',
                        style: Styles.mediumText(),
                      ),
                      if(doctor.visitHomePrice.isNotEmpty)Label(
                        text: '${LocaleKeys.homeVisitFees.localize}: ${doctor.visitHomePrice} ${context.isArabic?doctor.currencyAr:doctor.currencyEn}',
                        style: Styles.mediumText(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            _buildWaitingTime,
            const Sizer(),
          ],
        ),
      ),
    );
  }

  Widget get _buildWaitingTime {
    if (serviceLocator<HealthSharedData>().doctorSearchParams.bookingType ==
        BookingTypes.clinic) {
      return Row(
        children: [
          const Icon(
            Icons.timer,
          ),
          const Sizer(),
          Expanded(
            child: Label(
              text:
                  '${Labels.waitingTime}: ${doctor.waitingTime} ${Labels.minutes}',
              style: Styles.mediumText(),
            ),
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
