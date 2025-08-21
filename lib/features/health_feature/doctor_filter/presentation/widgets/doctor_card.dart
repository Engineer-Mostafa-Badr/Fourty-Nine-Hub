import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/pages/DoctorDetails.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/premuim_views_card.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

import '../../../doctor_details/presentation/widgets/doctor_image.dart';
import '../../../doctor_details/presentation/widgets/info.dart';
import '../../../health/presentation/widgets/cards/health_contacts_button.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorCard({super.key, required this.doctor, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        if (UserCubit.to.isLoggedIn) {
          context.push(Routes.VISITADOCTORDETAILS,
              extra: DoctorDetailsParams(
                  doctorId: doctor.id, fromSearch: false, type: type));
        } else {
          return pleaseLoginDialog(context);

          // context.push(Routes.LOGIN);
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
            /// premium views banner
            PremuimViewsCard(),
            const Divider(),

            /// doctor image
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          DoctorImage(
                            rating: doctor.rating ?? 0,
                            imageUrl: doctor.image ?? '',
                          ),
                          Sizer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// first name
                              Label(
                                text:
                                    '${toBeginningOfSentenceCase(doctor.firstName ?? '')} ${toBeginningOfSentenceCase(doctor.lastName ?? '')}',
                                style: Styles.headerText(
                                    fontWeight: FontWeight.w600),
                              ),

                              /// last name
                              Label(
                                  text: context.isArabic
                                      ? doctor.subCategory.nameAr ?? ''
                                      : doctor.subCategory.nameEn ?? '',
                                  maxLines: 1,
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ],
                      ),
                      const Sizer(),
                    ],
                  ),
                ),
                if (doctor.classification != 'NotSubscribed')
                  Container(
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
                      doctor.classification == "Regular subscription"
                          ? LocaleKeys.regular.localize
                          : LocaleKeys.premium.localize,
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
            const Sizer(),

            /// address
            DoctorDetailsInfoCard(
                icon: Icons.location_on, label: ' ${doctor.address.address}  '),
            const Sizer(),

            /// fees
            _buildFeesRow(
                icon: context.isArabic ? "الرسوم" : "Fees",
                label: LocaleKeys.cash.localize,
                fees: "100 EGP"),
            const Sizer(),

            /// waiting time
            DoctorDetailsInfoCard(
                icon: Icons.access_time,
                label:
                    '${LocaleKeys.waitingTime.localize}: ${doctor.waitingTime ?? ''} ${LocaleKeys.minuteLoc.localize}'),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Request button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 120.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: AppColors.colorRed),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Label(
                        text: LocaleKeys.book.localize,
                        style: Styles.mediumText(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                  Sizer(
                    width: 50,
                  ),
                  Expanded(
                    child: HealthContactsButtons(
                      otherUserId: '',
                      subcategoryId: '',
                      phone: '',
                      id: "",
                    ),
                  ),
                ],
              ),
            )
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

  Widget _buildFeesRow(
      {required String icon, required String label, required String fees}) {
    return Row(
      children: [
        SvgPicture.asset(Assets.cash),
        const Sizer(),
        Expanded(child: Label(text: label, style: Styles.mediumText())),
        Spacer(),
        Expanded(child: Label(text: fees, style: Styles.mediumText())),
      ],
    );
  }
}
