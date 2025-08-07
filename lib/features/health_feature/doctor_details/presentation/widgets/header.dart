import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/pages/meeting_room.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'Doctor_contact_buttons.dart';
import 'doctor_image.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DoctorDetailsAccountHeader extends StatefulWidget {
  const DoctorDetailsAccountHeader({super.key});

  @override
  State<DoctorDetailsAccountHeader> createState() =>
      _DoctorDetailsAccountHeaderState();
}

class _DoctorDetailsAccountHeaderState
    extends State<DoctorDetailsAccountHeader> {
  final commentController = TextEditingController();
  final phoneController = TextEditingController();
  int rating = 3;

  TimeOfDay stringToTimeOfDay(String timeString) {
    // Split the string into hours and minutes
    final parts = timeString.split(' ');
    final hourPart = parts[0].replaceAll('h', ''); // Remove the 'h'
    final minutePart = parts[1].replaceAll('m', ''); // Remove the 'm'

    // Parse the values
    final hours = int.tryParse(hourPart) ?? 0;
    final minutes = int.tryParse(minutePart) ?? 0;

    // Return a TimeOfDay instance
    return TimeOfDay(hour: hours, minute: minutes);
  }

  bool isNonZeroTime(String timeString) {
    // Split the string into hours and minutes
    final parts = timeString.split(' ');
    final hourPart = parts[0].replaceAll('h', ''); // Remove the 'h'
    final minutePart = parts[1].replaceAll('m', ''); // Remove the 'm'

    // Parse the values
    final hours = int.tryParse(hourPart) ?? 0;
    final minutes = int.tryParse(minutePart) ?? 0;

    // Check if either hours or minutes are non-zero
    return hours != 0 || minutes != 0;
  }

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.state.doctor;
    TimeOfDay timeToStart = (doctor?.timeToStart.isNotEmpty ?? false)
        ? stringToTimeOfDay(doctor?.timeToStart ?? '')
        : TimeOfDay.now();
    bool isNonZero = isNonZeroTime(doctor?.timeToStart ?? '');
    print('isBet ${doctor?.isBetweenStartAndEnd ?? false}');
    print('doctorRoomMeeting ${doctor?.meetingData?.toJson()}');
    print(isNonZero);
    final formKey = GlobalKey<FormState>();
    return Column(
      children: [
        Row(
          children: [
            const Sizer(),
            Text(
              LocaleKeys.doctorDetails.localize,
              style: Styles.headerText(),
            ),
          ],
        ),
        const Sizer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              DoctorImage(
                rating: doctor?.rating ?? 0,
                imageUrl: doctor?.image ?? '',
              ),
              const Sizer(),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      /// Doctor Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// first name
                            Label(
                              text:
                                  '${toBeginningOfSentenceCase(doctor?.firstName ?? '')} ${toBeginningOfSentenceCase(doctor?.lastName ?? '')}',
                              style: Styles.headerText(
                                  fontWeight: FontWeight.w600),
                            ),

                            /// last name
                            Label(
                                text: context.isArabic
                                    ? doctor?.subCategory.nameAr ?? ''
                                    : doctor?.subCategory.nameEn ?? '',
                                maxLines: 1,
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),

                      /// doctor rate Button
                      AppButton(
                        style: Styles.headerText(fontSize: 32),
                        height: 78.h,
                        width: 140.w,
                        label: LocaleKeys.rate.localize,
                        textColor: Colors.black,
                        padding: 16.w,
                        color: Colors.black,
                        backColor: AppColors.GREY_LIGHT_COLOR,
                        onPressed: () {
      ManageVibration.vibrate();
                          showModalBottomSheet(
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
                                  height: 700.h,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                    horizontal: 30.w,
                                  ),
                                  child: Column(
                                    children: [
                                      Sizer(),
                                      Row(
                                        children: [
                                          const Sizer(width: 50),
                                          Spacer(),
                                          Label(
                                            text:
                                                LocaleKeys.rateDoctor.localize,
                                            style: Styles.headerText(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Spacer(),

                                          /// on close Button
                                          InkWell(
                                              onTap: () async {
      ManageVibration.vibrate();
                                                commentController.clear();
                                                phoneController.clear();
                                                rating = 0;
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                  radius: 30.r,
                                                  backgroundColor: AppColors
                                                      .LIGHT_GRAY_COLOR,
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.black,
                                                  )))
                                        ],
                                      ),
                                      Label(
                                        text: LocaleKeys.poor2.localize,
                                        style: Styles.headerText(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 60),
                                      ),
                                      const Sizer(),

                                      /// doctor rate stars
                                      RatingBar.builder(
                                        glowColor: AppColors.whiteColor,
                                        itemSize: 55.0.sp,
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (r) {
                                          rating = r.toInt();
                                          setState(() {});
                                          print(rating);
                                        },
                                      ),
                                      Sizer(
                                        height: 30.h,
                                      ),

                                      /// form add review data
                                      Form(
                                          key: formKey,
                                          child: Column(
                                            children: [
                                              /// add comment
                                              Stack(
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxHeight: 210.h),
                                                    child: TextFormField(
                                                      // focusNode: focusNode,
                                                      maxLines: null,
                                                      maxLength: 150,
                                                      onChanged: (c) {},
                                                      validator: (c) =>
                                                          Validator()
                                                              .emptyValidation(
                                                                  c),
                                                      controller:
                                                          commentController,
                                                      style: Styles.headerText(
                                                          color:
                                                              context.isDarkMode
                                                                  ? Colors.black
                                                                  : null),
                                                      decoration:
                                                          InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.r),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: AppColors
                                                                      .DARK_GRAY_COLOR,
                                                                ),
                                                              ),
                                                              hintText: LocaleKeys
                                                                  .add_comment_hint
                                                                  .localize,
                                                              fillColor: AppColors
                                                                  .colorGreyLight,
                                                              hintStyle: Styles
                                                                  .mediumText(
                                                                      color: AppColors
                                                                          .DARK_GRAY_COLOR)),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 20.w,
                                                    top: 25.h,
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: AppColors
                                                          .DARK_GRAY_COLOR,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Sizer(
                                                height: 10,
                                              ),

                                              /// add phone number
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 180.h),
                                                child: TextFormField(
                                                  validator: (c) => Validator()
                                                      .emptyValidation(c),
                                                  maxLines: 1,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (c) {},
                                                  controller: phoneController,
                                                  style: Styles.headerText(
                                                      color: context.isDarkMode
                                                          ? Colors.black
                                                          : null),
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.r),
                                                        borderSide: BorderSide(
                                                          color: AppColors
                                                              .DARK_GRAY_COLOR,
                                                        ),
                                                      ),
                                                      hintText: LocaleKeys
                                                          .phoneNumber.localize,
                                                      fillColor: AppColors
                                                          .colorGreyLight,
                                                      hintStyle: Styles.mediumText(
                                                          color: AppColors
                                                              .DARK_GRAY_COLOR)),
                                                ),
                                              ),
                                            ],
                                          )),
                                      const Sizer(
                                        height: 50,
                                      ),
                                      InkWell(
                                        onTap: () async {
      ManageVibration.vibrate();
                                          if (formKey.currentState!
                                              .validate()) {
                                            bool result =
                                                await doctorDetailsCubit
                                                    .addRating(
                                                        AddDoctorRatingParams(
                                                            doctorId: doctor
                                                                    ?.id ??
                                                                '',
                                                            rating: rating,
                                                            comment:
                                                                commentController
                                                                    .text,
                                                            phone:
                                                                phoneController
                                                                    .text));
                                            if (result == true) {
                                              commentController.clear();
                                              phoneController.clear();
                                              rating = 3;
                                              setState(() {});
                                              Navigator.of(context).pop();
                                              showSuccessMessage(
                                                  context,
                                                  context.isArabic
                                                      ? "تم اضافة التقييم بنجاح"
                                                      : "Rating added successfully");
                                            } else {
                                              commentController.clear();
                                              phoneController.clear();
                                              rating = 3;
                                              setState(() {});
                                              Navigator.of(context).pop();
                                              showErrorMessage(
                                                  context, "message");
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 743.w,
                                          height: 88.h,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: AppColors.PRIMARY_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          alignment: Alignment.center,
                                          child: Label(
                                            text: LocaleKeys.send.localize,
                                            style: Styles.headerText(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Sizer(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      (doctor?.isAfterEnd ?? false)
                          ? const Spacer(flex: 4)
                          : doctor?.isBetweenStartAndEnd == true
                              ? Expanded(
                                  flex: 4,
                                  child: AppButton(
                                    label: LocaleKeys.onlineSession.localize,
                                    style:
                                        Styles.mediumText(color: Colors.white),
                                    onPressed: () async {
      ManageVibration.vibrate();
                                      bool result = await context
                                          .read<StreamCubit>()
                                          .joinNewMeeting(
                                              doctor?.meetingData?.roomId ??
                                                  '');
                                      if (result) {
                                        await context
                                            .read<SecretsCubit>()
                                            .getAllSecrets();
                                        context.go(Routes.MEETINGROOM,
                                            extra: MeetingRoomArguments(
                                                liveID: doctor
                                                        ?.meetingData?.roomId ??
                                                    '',
                                                isHost: false,
                                                userName: context
                                                        .read<UserCubit>()
                                                        .state
                                                        .data
                                                        ?.fullName ??
                                                    ''));
                                      }
                                    },
                                  ),
                                )
                              : ((doctor?.timeToStart.isNotEmpty ?? false) &&
                                      isNonZero)
                                  ? Expanded(
                                      flex: 4,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              context.isArabic
                                                  ? 'لديك جلسة بعد'
                                                  : 'Online Session After',
                                              style: Styles.mediumText(),
                                            ),
                                            SlideCountdown(
                                              style: Styles.headerText(
                                                  color: Colors.white),
                                              duration: Duration(
                                                  minutes: timeToStart.minute,
                                                  hours: timeToStart.hour),
                                              onDone: () {
                                                setState(() {
                                                  doctor?.isBetweenStartAndEnd =
                                                      true;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Spacer(flex: 4),
                      const Sizer(),
                      // Expanded(
                      //   child: InkWell(
                      //     onTap: () {
                      //       bottomSheet(
                      //           context: context,
                      //           widget: ReportView(
                      //             id: doctor?.id??'',
                      //             categoryId: serviceLocator<HealthSharedData>()
                      //                 .doctorSearchParams
                      //                 .subCategory
                      //                 .id,
                      //           ));
                      //     },
                      //     child: const Icon(
                      //       Icons.report_gmailerrorred_rounded,
                      //       color: AppColors.SECONDARY_COLOR,
                      //       size: 30,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
        const Sizer(),
        DoctorContactButtons(
          doctorID: doctor?.id ?? "",
        )
      ],
    );
  }
}