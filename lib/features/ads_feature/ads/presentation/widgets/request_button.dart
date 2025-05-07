import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

import '../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../../../../../routes/routes.dart';

class RequestButton extends StatelessWidget {
  const RequestButton(
      {super.key, required this.adId, required this.subscriptionStatus});

  final String adId;
  final String subscriptionStatus;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementCubit, AdsState>(builder: (context, state) {
      final controller = context.read<AdvertisementCubit>();

      return InkWell(
        onTap: !context.read<UserCubit>().isLoggedIn
            ? () {
                context.pop();
                return pleaseLoginDialog(context);

          // context.push(Routes.LOGIN);
              }
            : subscriptionStatus == 'premium'
                ? null
                : () {
                    context.pop();
                    showModalBottomSheet(
                      backgroundColor: context.isDarkMode
                          ? AppColors.DARK_BLUE_COLOR.withValues(alpha: 0.95)
                          : AppColors.LIGHT_COLOR,
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
                            height: 400.h,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 10,
                            ),
                            child: Column(
                              children: [
                                Label(
                                  text: LocaleKeys.enterPhoneNumber.localize,
                                  style: Styles.headerText(),
                                ),
                                Sizer(
                                  height: 30.h,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxHeight: 180.h),
                                  child: Form(
                                    key: controller.formKey,
                                    child: NewPhoneNumberTextFormField(
                                      style: TextStyle(
                                        color: AppColors.getTextColor(context),
                                      ),
                                      currentController: TextEditingController(),
                                      isRequired: true,
                                      maxLines: null,
                                      maxLength: 150,
                                      hintColor:AppColors.getTextColor(context) ,
                                      onChanged: (c) =>
                                          controller.changePhone(v: c),
                                      // controller: controller,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            if (context.isUserLoggedIn &&
                                                controller.formKey.currentState!
                                                    .validate()) {
                                              await controller
                                                  .makeAdRequest(id: adId)
                                                  .then((value) {
                                                if (value == true) {
                                                  context.pop();
                                                  showSuccessMessage(context,
                                                      'Request Sent Successfully');
                                                  controller.resetRequest();
                                                } else {
                                                  context.pop();
                                                  if (state.failure != null) {
                                                    showErrorMessage(
                                                        context,
                                                        getFailureMessage(
                                                            state.failure!,
                                                            context));
                                                  } else {
                                                    showErrorMessage(context,
                                                        'Please Try Again!');
                                                  }
                                                }
                                              });
                                            } else {
                                              return pleaseLoginDialog(context);
                                              // context.go(Routes.LOGIN);
                                            }
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 80.h,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: AppColors.getButtonPrimaryColor(context),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            alignment: Alignment.center,
                                            child: Label(
                                              text: LocaleKeys.send.localize,
                                              style: Styles.headerText(
                                                  color: AppColors.getReversedTextColor(context)),
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
                                            text: LocaleKeys.cancel.localize,
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
        child: Container(
          height: 38,
          decoration: ShapeDecoration(
            color: const Color(0xFF0B1035),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Center(
            child: Label(
              text: LocaleKeys.request.localize,
              style: Styles.headerText(
                color: Colors.white,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

      // return AvaialbleTripsButton(
      //   title: LocaleKeys.request.localize,
      //   color: AppColors.PRIMARY_COLOR,
      //   onTap: !context.read<UserCubit>().isLoggedIn
      //       ? () {
      //           context.pop();
      //           context.push(Routes.LOGIN);
      //         }
      //       : subscriptionStatus == 'premium'
      //           ? null
      //           : () {
      //               context.pop();
      //               showModalBottomSheet(
      //                 backgroundColor: context.isDarkMode
      //                     ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
      //                     : AppColors.LIGHT_COLOR,
      //                 context: context,
      //                 shape: const RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.only(
      //                     topLeft: Radius.circular(32.0),
      //                     topRight: Radius.circular(32.0),
      //                   ),
      //                 ),
      //                 isDismissible: true,
      //                 isScrollControlled: true,
      //                 builder: (BuildContext context) {
      //                   return AnimatedPadding(
      //                     padding: MediaQuery.of(context).viewInsets,
      //                     duration: const Duration(milliseconds: 50),
      //                     child: Container(
      //                       height: 400.h,
      //                       padding: EdgeInsets.symmetric(
      //                         vertical: 10.h,
      //                         horizontal: 10,
      //                       ),
      //                       child: Column(
      //                         children: [
      //                           Label(
      //                             text: LocaleKeys.enterPhoneNumber.localize,
      //                             style: Styles.headerText(),
      //                           ),
      //                           Sizer(
      //                             height: 30.h,
      //                           ),
      //                           Container(
      //                             constraints: BoxConstraints(maxHeight: 180.h),
      //                             child: Form(
      //                               key: controller.formKey,
      //                               child: TextFormField(
      //                                 style: const TextStyle(
      //                                   color: AppColors.DARK_BLUE_COLOR,
      //                                 ),
      //                                 validator: (value) {
      //                                   if ((value == null || value.isEmpty)) {
      //                                     return LocaleKeys.required.localize;
      //                                   } else {
      //                                     return null;
      //                                   }
      //                                 },
      //                                 // focusNode: focusNode,
      //                                 maxLines: null,
      //                                 maxLength: 150,
      //                                 onChanged: (c) =>
      //                                     controller.changePhone(v: c),
      //                                 // controller: controller,
      //                                 decoration: InputDecoration(
      //                                     hintText:
      //                                         LocaleKeys.phoneNumber.localize,
      //                                     fillColor: Colors.white,
      //                                     hintStyle: Styles.mediumText(
      //                                         color:
      //                                             AppColors.DARK_GRAY_COLOR)),
      //                               ),
      //                             ),
      //                           ),
      //                           Expanded(
      //                             child: Row(
      //                               children: [
      //                                 Expanded(
      //                                   child: InkWell(
      //                                     onTap: () async {
      //                                       if (context.isUserLoggedIn &&
      //                                           controller.formKey.currentState!
      //                                               .validate()) {
      //                                         await controller
      //                                             .makeAdRequest(id: adId)
      //                                             .then((value) {
      //                                           if (value == true) {
      //                                             context.pop();
      //                                             showSuccessMessage(context,
      //                                                 'Request Sent Successfully');
      //                                             controller.resetRequest();
      //                                           } else {
      //                                             context.pop();
      //                                             if (state.failure != null) {
      //                                               showErrorMessage(
      //                                                   context,
      //                                                   getFailureMessage(
      //                                                       state.failure!,
      //                                                       context));
      //                                             } else {
      //                                               showErrorMessage(context,
      //                                                   'Please Try Again!');
      //                                             }
      //                                           }
      //                                         });
      //                                       } else {
      //                                         context.go(Routes.LOGIN);
      //                                       }
      //                                     },
      //                                     child: Container(
      //                                       width: 100,
      //                                       height: 80.h,
      //                                       padding: const EdgeInsets.all(5),
      //                                       decoration: BoxDecoration(
      //                                           color: AppColors.PRIMARY_COLOR,
      //                                           borderRadius:
      //                                               BorderRadius.circular(15)),
      //                                       alignment: Alignment.center,
      //                                       child: Label(
      //                                         text: LocaleKeys.send.localize,
      //                                         style: Styles.headerText(
      //                                             color: Colors.white),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ),
      //                                 Expanded(
      //                                   child: TextButton(
      //                                     onPressed: () {
      //                                       Navigator.of(context)
      //                                           .pop(); // Close the dialog
      //                                     },
      //                                     child: Label(
      //                                       text: LocaleKeys.cancel.localize,
      //                                       style: Styles.headerText(),
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               );
      //             },
      // );
    });
  }
}
