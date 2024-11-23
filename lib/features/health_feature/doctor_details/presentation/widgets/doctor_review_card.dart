import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/rating_stars.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorReviewCard extends StatelessWidget {
  final UserDoctorRateEntity review;
  const DoctorReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const ProfileImage(
                      userId: '',
                      accountId: 0,
                      imageURL: UIConst.profilePlaceHolder,
                    ),
                    const Sizer(),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                            text: review.userName, style: Styles.mediumText()),
                        RatingStars(
                          rating: review.rate,
                          color: AppColors.ACCENT_COLOR,
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              ClickableWidget(
                  onTap: !context.read<UserCubit>().isLoggedIn
                      ? () => context.push(Routes.LOGIN)
                      : () {
                          bottomSheet(
                              context: context,
                              widget: ReportView(
                                id: review.userId ?? '',
                                categoryId: '62c8b57c9332225799fe3306',
                              ));
                        },
                  child: Icon(
                    Icons.report,
                    color: AppColors.SECONDARY_COLOR,
                    size: 60.w,
                  ))
            ],
          ),
          const Sizer(),
          ReadMoreLabel(
            text: review.comment,
            style: Styles.mediumText(
                fontWeight: FontWeight.w400, color: Colors.black),
          ),
          const Sizer(),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.call.localize,
                  color: (review.openCall == true &&
                          context.read<UserCubit>().isLoggedIn)
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.call,
                  onTap: !context.read<UserCubit>().isLoggedIn
                      ? () => context.push(Routes.LOGIN)
                      : review.openCall == true
                          ? () {
                              LaunchURLHelper().call(phone: review.phone ?? '');
                            }
                          : () async {
                              SubscriptionMethod().subscribe(
                                  subscribeId: '62c8b57c9332225799fe3306',
                                  title: LocaleKeys.health.localize);
                            },
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.message.localize,
                  color: (review.openCall == true &&
                          context.read<UserCubit>().isLoggedIn)
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.email,
                  onTap: !context.read<UserCubit>().isLoggedIn
                      ? () => context.push(Routes.LOGIN)
                      : review.openCall == true
                          ? () {}
                          : () {
                              SubscriptionMethod().subscribe(
                                  subscribeId: '62c8b57c9332225799fe3306',
                                  title: LocaleKeys.health.localize);
                            },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
