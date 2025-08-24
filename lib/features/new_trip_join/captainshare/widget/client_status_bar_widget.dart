import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ClientStatusBarWidget extends StatefulWidget {
  const ClientStatusBarWidget({super.key, required this.myRoute, this.model,this.statusDriver, required this.phoneController, this.onJoin, required this.formKey});
  final bool myRoute;
  final MyBookingEntity? model;
  final Function(String phone)? onJoin;
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final String? statusDriver;

  @override
  State<ClientStatusBarWidget> createState() => _ClientStatusBarWidgetState();
}

class _ClientStatusBarWidgetState extends State<ClientStatusBarWidget> {

  String convertDigits(String input, {bool toArabic = false}) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    final from = toArabic ? western : eastern;
    final to = toArabic ? eastern : western;

    for (int i = 0; i < from.length; i++) {
      input = input.replaceAll(from[i], to[i]);
    }

    return input;
  }

  String getBookingStatus(String status) {
    switch (status) {
      case 'pending':
        return context.isArabic ? 'انتظار' : 'Pending';
      case 'accepted':
        return LocaleKeys.accepted.localize;
      case 'expired':
        return LocaleKeys.expired.localize;
      case 'cancelled':
        return context.isArabic ? 'تم الغاء' : 'Canceled';
      case 'full':
        return context.isArabic ? 'ممتلئ' : 'Full';
      case 'completed':
        return context.isArabic ? 'مكتمل' : 'Completed';
      case 'done':
        return LocaleKeys.done.localize;
      default:
        return LocaleKeys.pending.localize;
    }
  }

  Widget buildStep(String title, bool booked, String? imageUrl, Color pointColor,bool showSeat) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text on top
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 6),

        // Avatar (optional)
        if (imageUrl != null||showSeat) ...[
          if(showSeat)SvgPicture.asset(
            Assets.freeIcon,
            color: AppColors.getTextColor(context),
            height: 30,
            width: 30,
          ),
          if(!showSeat)ImageFromInternet(
              image: imageUrl??'',
              isCircle: true,
              defaultLogo: false,
              width: 30,
              height: 30,
              firstChar: '',
              charPadding:0
          ),
          const SizedBox(height: 6),
        ] else
          const SizedBox(height: 36), // keeps alignment when no image

        // Dot
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: pointColor,
            shape: BoxShape.circle,
          ),
        ),

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child:  Stack(
        children: [
          PositionedDirectional(
            bottom: 6,
            start: 0,
            end: 0,
            child: SizedBox(
              // width: 80,
              child: Divider(
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStep(LocaleKeys.booked.localize, true, widget.myRoute?UserCubit.to.state.data?.profilePicture??'':'', Colors.red,false),
              ClickableWidget(
                onTap: () {
                  if((widget.model?.availableSeats??0)<2){
                    return;
                  }
                  if ((widget.model?.clients ?? []).any(
                          (e) => e.id == UserCubit.to.state.data?.id)) {
                    return;
                  }
                  if (widget.onJoin != null) {
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
                          padding:
                          MediaQuery.of(context).viewInsets,
                          duration:
                          const Duration(milliseconds: 50),
                          child: Container(
                            height: 400.h,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 10,
                            ),
                            child: Form(
                              key: widget.formKey,
                              child: Column(
                                children: [
                                  Label(
                                    text: context.isArabic
                                        ? "ادخل رقم هاتفك"
                                        : "Enter your phone number",
                                    style: Styles.headerText(),
                                  ),
                                  Sizer(
                                    height: 30.h,
                                  ),
                                  CustomPhoneTextFormField(
                                    currentFocusNode: FocusNode(),
                                    nextFocusNode: FocusNode(),
                                    currentController:
                                    widget.phoneController,
                                    onInputChanged: (value) =>
                                        widget.formKey.currentState!
                                            .validate(),
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          11),
                                    ],
                                    validator: (value) {
                                      final input =
                                          value?.trim() ?? '';

                                      if (input.isEmpty) {
                                        return LocaleKeys
                                            .required.localize;
                                      }

                                      final numericValue =
                                      convertDigits(input,
                                          toArabic: false)
                                          .replaceAll(
                                          RegExp(r'[^0-9]'),
                                          '');

                                      if (numericValue.length !=
                                          11) {
                                        return context.isArabic
                                            ? 'يجب أن يحتوي رقم الهاتف على 11 رقمًا'
                                            : 'Phone number must be exactly 11 digits.';
                                      }

                                      if (![
                                        '010',
                                        '011',
                                        '012',
                                        '015'
                                      ].any(numericValue
                                          .startsWith)) {
                                        return context.isArabic
                                            ? 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015'
                                            : 'Phone number must start with 010, 011, 012, or 015.';
                                      }

                                      return null;
                                    },
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              if (widget.formKey
                                                  .currentState!
                                                  .validate()) {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                                widget.onJoin!(
                                                    widget.phoneController
                                                        .text);
                                              }
                                              // if (messageController.text.isNotEmpty) {
                                              //   var result = await controller.sendGreetMessage(context: context, userId: controller.suggestUserPagingController.itemList![index].id, message: messageController.text);
                                              //   if (result == true) {
                                              //     controller.suggestUserPagingController.itemList?.removeWhere((element) => element.id == controller.suggestUserPagingController.itemList?[index].id);
                                              //     showSuccessMessage(context, LocaleKeys.messageSentSuccessfully.localize);
                                              //     Navigator.of(context).pop();
                                              //     setState(() {});
                                              //   } else {
                                              //     print(state.failure);
                                              //     Navigator.of(context).pop();
                                              //   }
                                              // }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 80.h,
                                              padding:
                                              const EdgeInsets
                                                  .all(5),
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .PRIMARY_COLOR,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      15)),
                                              alignment:
                                              Alignment.center,
                                              child: Label(
                                                text: LocaleKeys
                                                    .join.localize,
                                                style: Styles
                                                    .headerText(
                                                    color: Colors
                                                        .white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Label(
                                              text: LocaleKeys
                                                  .cancel.localize,
                                              style: Styles
                                                  .headerText(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: buildStep(((widget.model?.availableSeats ?? 0) >= 2)
                    ? ("${widget.model?.status == 'expired' ? context.isArabic ? 'كان ' : 'Was ' : ''}${LocaleKeys.free.localize}")
                    : LocaleKeys.booked.localize, true, '', Colors.red,(widget.model?.availableSeats ?? 0) >= 2),),
              ClickableWidget(
                onTap: () {
                  if((widget.model?.availableSeats??0)<1){
                    return;
                  }
                  if ((widget.model?.clients ?? []).any(
                          (e) => e.id == UserCubit.to.state.data?.id)) {
                    return;
                  }
                  if (widget.onJoin != null) {
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
                          padding:
                          MediaQuery.of(context).viewInsets,
                          duration:
                          const Duration(milliseconds: 50),
                          child: Container(
                            height: 400.h,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 10,
                            ),
                            child: Form(
                              key: widget.formKey,
                              child: Column(
                                children: [
                                  Label(
                                    text: context.isArabic
                                        ? 'ادخل رقم هاتفك'
                                        : 'Enter your phone number',
                                    style: Styles.headerText(),
                                  ),
                                  Sizer(
                                    height: 30.h,
                                  ),
                                  CustomPhoneTextFormField(
                                    currentFocusNode: FocusNode(),
                                    nextFocusNode: FocusNode(),
                                    currentController:
                                    widget.phoneController,
                                    onInputChanged: (value) =>
                                        widget.formKey.currentState!
                                            .validate(),
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          11),
                                    ],
                                    validator: (value) {
                                      final input =
                                          value?.trim() ?? '';

                                      if (input.isEmpty)
                                        return LocaleKeys
                                            .required.localize;

                                      final numericValue =
                                      convertDigits(input,
                                          toArabic: false)
                                          .replaceAll(
                                          RegExp(r'[^0-9]'),
                                          '');

                                      if (numericValue.length !=
                                          11) {
                                        return context.isArabic
                                            ? 'يجب أن يحتوي رقم الهاتف على 11 رقمًا'
                                            : 'Phone number must be exactly 11 digits.';
                                      }

                                      if (![
                                        '010',
                                        '011',
                                        '012',
                                        '015'
                                      ].any(numericValue
                                          .startsWith)) {
                                        return context.isArabic
                                            ? 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015'
                                            : 'Phone number must start with 010, 011, 012, or 015.';
                                      }

                                      return null;
                                    },
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              if (widget.formKey
                                                  .currentState!
                                                  .validate()) {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                                widget.onJoin!(
                                                    widget.phoneController
                                                        .text);
                                              }
                                              // if (messageController.text.isNotEmpty) {
                                              //   var result = await controller.sendGreetMessage(context: context, userId: controller.suggestUserPagingController.itemList![index].id, message: messageController.text);
                                              //   if (result == true) {
                                              //     controller.suggestUserPagingController.itemList?.removeWhere((element) => element.id == controller.suggestUserPagingController.itemList?[index].id);
                                              //     showSuccessMessage(context, LocaleKeys.messageSentSuccessfully.localize);
                                              //     Navigator.of(context).pop();
                                              //     setState(() {});
                                              //   } else {
                                              //     print(state.failure);
                                              //     Navigator.of(context).pop();
                                              //   }
                                              // }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 80.h,
                                              padding:
                                              const EdgeInsets
                                                  .all(5),
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .PRIMARY_COLOR,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      15)),
                                              alignment:
                                              Alignment.center,
                                              child: Label(
                                                text: LocaleKeys
                                                    .join.localize,
                                                style: Styles
                                                    .headerText(
                                                    color: Colors
                                                        .white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Label(
                                              text: LocaleKeys
                                                  .cancel.localize,
                                              style: Styles
                                                  .headerText(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: buildStep( ((widget.model?.availableSeats ?? 0) >= 1)
                    ? ("${widget.model?.status == 'expired' ? context.isArabic ? 'كان ' : 'Was ' : ''}${LocaleKeys.free.localize}")
                    : LocaleKeys.booked.localize, true, '', Colors.red,(widget.model?.availableSeats ?? 0) >= 1),
              ),
              buildStep( getBookingStatus(widget.statusDriver ?? ""), false, null, Colors.blue,false),
            ],
          ),

        ],
      ),
    );
  }
}
