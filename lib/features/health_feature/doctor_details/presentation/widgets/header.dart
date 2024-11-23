import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/rating_stars.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.doctor;
    final formKey = GlobalKey<FormState>();
    return Column(
      children: [
        Row(
          children: [
            SquareImage(
              source: NetworkImage(
                doctor.image,
              ),
              radius: 10,
              height: kToolbarHeight * 1.5,
              width: kToolbarHeight * 1.5,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text:
                                '${toBeginningOfSentenceCase(doctor.firstName)} ${toBeginningOfSentenceCase(doctor.lastName)}',
                            style:
                                Styles.mediumText(fontWeight: FontWeight.w500),
                          ),
                          RatingStars(
                            rating: doctor.rating,
                            color: AppColors.ACCENT_COLOR,
                            iconSize: 18,
                          ),
                          Label(
                              text: doctor.description,
                              maxLines: 1,
                              style: Styles.mediumText()),
                        ],
                      ),
                    ),
                    AppButton(
                      label: "Rating",
                      icon: Icons.star,
                      textColor: Colors.amber,
                      padding: 10.w,
                      color: Colors.white,
                      backColor: AppColors.SECONDARY_COLOR,
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32.0),
                              topRight: Radius.circular(32.0),
                            ),
                          ),
                          isDismissible: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return AnimatedPadding(
                              padding: MediaQuery.of(context).viewInsets,
                              duration: const Duration(milliseconds: 50),
                              child: Container(
                                height: 550.h,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 10,
                                ),
                                child: Column(
                                  children: [
                                    Label(
                                      text: "Rate Doctor",
                                      style: Styles.headerText(),
                                    ),
                                    Sizer(
                                      height: 30.h,
                                    ),
                                    RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
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
                                    Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxHeight: 180.h),
                                              child: TextFormField(
                                                // focusNode: focusNode,
                                                maxLines: null,
                                                maxLength: 150,
                                                onChanged: (c) {},
                                                validator: (c) => Validator()
                                                    .emptyValidation(c),
                                                controller: commentController,

                                                decoration: InputDecoration(
                                                    hintText: LocaleKeys
                                                        .add_comment_hint
                                                        .localize,
                                                    fillColor: Colors.white,
                                                    hintStyle: Styles.mediumText(
                                                        color: AppColors
                                                            .DARK_GRAY_COLOR)),
                                              ),
                                            ),
                                            Sizer(
                                              height: 10.h,
                                            ),
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
                                                decoration: InputDecoration(
                                                    hintText: LocaleKeys
                                                        .phoneNumber.localize,
                                                    fillColor: Colors.white,
                                                    hintStyle: Styles.mediumText(
                                                        color: AppColors
                                                            .DARK_GRAY_COLOR)),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  bool result = await doctorDetailsCubit
                                                      .addRating(
                                                          AddDoctorRatingParams(
                                                              doctorId:
                                                                  doctor.id,
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
                                                    rating = 0;
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                    showSuccessMessage(
                                                        context, "message");
                                                  } else {
                                                    commentController.clear();
                                                    phoneController.clear();
                                                    rating = 0;
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                    showErrorMessage(
                                                        context, "message");
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 80.h,
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors.PRIMARY_COLOR,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                alignment: Alignment.center,
                                                child: Label(
                                                  text:
                                                      LocaleKeys.send.localize,
                                                  style: Styles.headerText(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () async {
                                                commentController.clear();
                                                phoneController.clear();
                                                rating = 0;
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              },
                                              child: Label(
                                                text:
                                                    LocaleKeys.cancel.localize,
                                                style: Styles.headerText(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
                Sizer(
                  height: 30.h,
                ),
                BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
                  buildWhen: (previous, current) =>
                      current is DoctorDetailsCheckCallAndMessage ||
                      current is DoctorDetailsInitial,
                  builder: (context, state) {
                    if (state is DoctorDetailsCheckCallAndMessage &&
                        state.enabled) {
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: Labels.call,
                              icon: Icons.call,
                              backColor: AppColors.PRIMARY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                          const Sizer(),
                          Expanded(
                            child: AppButton(
                              label: Labels.message,
                              icon: Icons.message,
                              backColor: AppColors.PRIMARY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: Labels.call,
                              icon: Icons.call,
                              backColor: AppColors.DARK_GRAY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                          const Sizer(),
                          Expanded(
                            child: AppButton(
                              label: Labels.message,
                              icon: Icons.message,
                              backColor: AppColors.DARK_GRAY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                Sizer(
                  height: 15.h,
                ),
                Row(
                  children: [
                    serviceLocator<HealthSharedData>()
                                .doctorSearchParams
                                .bookingType ==
                            BookingTypes.call
                        ? Expanded(
                            flex: 4,
                            child: AppButton(
                              label: Labels.onlineSession,
                              onPressed: () {},
                            ),
                          )
                        : const Spacer(flex: 4),
                    const Sizer(),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          bottomSheet(
                              context: context,
                              widget: ReportView(
                                id: doctor.id,
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
                ),
                const Sizer(),
              ],
            ))
          ],
        ),
        const DoctorDetailsDivider(),
      ],
    );
  }
}
