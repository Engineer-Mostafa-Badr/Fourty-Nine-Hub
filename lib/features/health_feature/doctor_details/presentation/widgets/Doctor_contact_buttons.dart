import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/functions/helper/launch_url.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../helpers/subscription_method.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../health/presentation/controllers/shared_data/health_shared_data.dart';
import '../cubit/doctor_details_cubit.dart';

class DoctorContactButtons extends StatelessWidget {
  final String doctorID;

  const DoctorContactButtons({super.key, required this.doctorID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
      builder: (context, state) {
        if (state.enabled == true) {
          return Row(
            children: [
              Expanded(
                child: AppButton(
                  label: LocaleKeys.call.localize,
                  icon: Icons.call,
                  color: Colors.white,
                  backColor: AppColors.PRIMARY_COLOR,
                  textColor: Colors.white,
                  // onPressed: () {},
                  onPressed: !context.read<UserCubit>().isLoggedIn
                      ? () {
                    pleaseLoginDialog(context);
                    // context.push(Routes.LOGIN);
                  }
                      : state.enabled == true
                          ? () {
                              LaunchURLHelper()
                                  .call(phone: state.doctor?.phone ?? '');
                            }
                          : () async {
                              SubscriptionMethod().subscribe(
                                  subscribeId:
                                      state.doctor?.subCategory.id ?? '',
                                  title: LocaleKeys.ads.localize);
                            },
                ),
              ),
              const Sizer(),
              Expanded(
                child: AppButton(
                  label: LocaleKeys.message.localize,
                  icon: Icons.message,
                  color: Colors.white,
                  textColor: Colors.white,
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: !context.read<UserCubit>().isLoggedIn
                      ? () {
                    pleaseLoginDialog(context);
                    // context.push(Routes.LOGIN);
                  }
                      : state.enabled == true
                          ? () {
                              LaunchURLHelper()
                                  .call(phone: state.doctor?.phone ?? '');
                            }
                          : () async {
                              SubscriptionMethod().subscribe(
                                  subscribeId:
                                      state.doctor?.subCategory.id ?? '',
                                  title: LocaleKeys.ads.localize);
                            },
                ),
              ),
              const Sizer(),
              Expanded(
                child: InkWell(
                  onTap: () {
                    bottomSheet(
                        context: context,
                        widget: ReportView(
                          id: doctorID ?? '',
                          categoryId: serviceLocator<HealthSharedData>()
                              .doctorSearchParams
                              .subCategory
                              .id,
                        ));
                  },
                  child: const Icon(
                    Icons.report_gmailerrorred_rounded,
                    color: AppColors.SECONDARY_COLOR,
                    size: 30,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container(
            height: 48.h,
            width: 566.w,
            decoration: BoxDecoration(
                color: AppColors.cF3F3F3,
                borderRadius: BorderRadius.circular(30.r)),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Icon(
                      Icons.call,
                      color: AppColors.colorRed,
                      size: 48.sp,
                    ),
                    onTap: () => showModalBottomSheet(
                      backgroundColor: context.isDarkMode
                          ? AppColors.DARK_BLUE_COLOR
                          : Colors.white,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0.sp),
                          topRight: Radius.circular(30.0.sp),
                        ),
                      ),
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return AnimatedPadding(
                          padding: MediaQuery.of(context).viewInsets,
                          duration: const Duration(milliseconds: 50),
                          child: Container(
                            height: 350.h,
                            width: 750.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 30.w,
                            ),
                            child: Column(
                              children: [
                                const Sizer(
                                  height: 17,
                                ),
                                /// on close Button
                                Row(
                                  children: [
                                    const Spacer(),
                                    InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: CircleAvatar(
                                            radius: 30.r,
                                            backgroundColor:
                                                AppColors.LIGHT_GRAY_COLOR,
                                            child: Icon(
                                              Icons.close,
                                              color: AppColors.black,
                                            )))
                                  ],
                                ),
                                const Sizer(
                                  height: 17,
                                ),
                                AppButton(
                                    height: 88.h,
                                    label: LocaleKeys.freeCall.localize,
                                    color: AppColors.whiteColor,
                                    backColor: AppColors.PRIMARY_COLOR,
                                    onPressed: () {}),
                                const Sizer(
                                  height: 30,
                                ),
                                AppButton(
                                    height: 88.h,
                                    label: LocaleKeys.regularCall.localize,
                                    color: AppColors.black,
                                    backColor: AppColors.BG_GRAY_COLOR,
                                    onPressed: () {})
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // !context.read<UserCubit>().isLoggedIn
                    //     ? () => context.push(Routes.LOGIN)
                    //     : state.enabled == true
                    //         ? () {
                    //             LaunchURLHelper()
                    //                 .call(phone: state.doctor?.phone ?? '');
                    //           }
                    //         : () async {
                    //             SubscriptionMethod().subscribe(
                    //                 subscribeId:
                    //                     state.doctor?.subCategory.id ?? '',
                    //                 title: LocaleKeys.ads.localize);
                    //           },
                  ),
                ),
                const Sizer(),
                Expanded(
                  child: InkWell(
                    child: Icon(Icons.mail_sharp,
                        color: AppColors.colorRed, size: 48.sp),
                    onTap: !context.read<UserCubit>().isLoggedIn
                        ? () {
                      pleaseLoginDialog(context);
                      // context.push(Routes.LOGIN);
                    }
                        : state.enabled == true
                            ? () {}
                            : () async {
                                SubscriptionMethod().subscribe(
                                    subscribeId:
                                        state.doctor?.subCategory.id ?? '',
                                    title: LocaleKeys.ads.localize);
                              },
                  ),
                ),
                const Sizer(),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      bottomSheet(
                          context: context,
                          widget: ReportView(
                            id: doctorID ?? '',
                            categoryId: serviceLocator<HealthSharedData>()
                                .doctorSearchParams
                                .subCategory
                                .id,
                          ));
                    },
                    child: Icon(
                      Icons.report,
                      color: AppColors.SECONDARY_COLOR,
                      size: 48.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
