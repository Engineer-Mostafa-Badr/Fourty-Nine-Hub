import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

import '../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../../../../../routes/routes.dart';

class PremiumRequestButton extends StatefulWidget {
  const PremiumRequestButton({
    super.key,
    required this.subscriptionStatus,
    required this.subCategoryId,
    required this.adId,
    this.dontPop = false,
  });

  final String subscriptionStatus;
  final String subCategoryId;
  final String adId;
  final bool dontPop;

  @override
  State<PremiumRequestButton> createState() => _PremiumRequestButtonState();
}

class _PremiumRequestButtonState extends State<PremiumRequestButton> {

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementCubit, AdsState>(builder: (context, state) {
      final controller = context.read<AdvertisementCubit>();
      return AppButton(
        label: LocaleKeys.premiumRequest.localize,
        style: Styles.headerText(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.6,
        ),
        backColor: AppColors.SECONDARY_COLOR_DARK2,
        radius: 15,
        height: 38,
        onPressed: () {
          if (!widget.dontPop) context.pop();
          if (context.read<UserCubit>().isLoggedIn) {
            // TODO: change
            // if (subscriptionStatus != 'premium') {
            if (false) {
              SubscriptionMethod().subscribe(
                subscribeId: widget.subCategoryId,
                showRegular: false,
                title: widget.subCategoryId,
              );
            } else {
              showModalBottomSheet(
                // backgroundColor: context.isDarkMode
                //     ? AppColors.DARK_BLUE_COLOR.withValues(alpha: 0.95)
                //     : AppColors.LIGHT_COLOR,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  return BlocProvider(
                    create: (context) => serviceLocator<AdvertisementCubit>(),
                    child: RequestNumberBottomSheet(
                      // controller: controller,
                      // adId: adId,
                      formKey: controller.formKey,
                      textController: controller.phoneController,
                      isLoading: state.requestStatus == AdsStates.loading,
                      onChanged: (c) => controller.changePhone(v: c),
                      onTap: () async {
                        if (controller.formKey.currentState!.validate()) {
                          await controller.makeAdPremiumRequest(id: widget.adId);
                          //     .then((value) {
                          //   if (value == true) {
                          //     context.pop();
                          //     showSuccessMessage(
                          //         context, 'Request Sent Successfully');
                          //     controller.resetRequest();
                          //   } else {
                          //     context.pop();
                          //     if (state.failure != null) {
                          //       showErrorMessage(context,
                          //           getFailureMessage(state.failure!, context));
                          //     } else {
                          //       showErrorMessage(context, 'Please Try Again!');
                          //     }
                          //   }
                          // });
                        }
                      },
                    ),
                  );
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
                                currentController: TextEditingController(),
                                isRequired: true,
                                maxLines: null,
                                maxLength: 150,
                                onChanged: (c) => controller.changePhone(v: c),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        await controller
                                            .makeAdPremiumRequest(id: widget.adId)
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
                                                      state.failure!, context));
                                            } else {
                                              showErrorMessage(
                                                  context, 'Please Try Again!');
                                            }
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 80.h,
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
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
            }
          } else {
            return pleaseLoginDialog(context);

            // context.push(Routes.LOGIN);
          }
        },
      );
      // return AvaialbleTripsButton(
      //   title: LocaleKeys.premiumRequest.localize,
      //   color: AppColors.SECONDARY_COLOR_DARK2,
      //   radius: 15,
      //   onTap: () {
      //     context.pop();
      //     if (context.read<UserCubit>().isLoggedIn) {
      //       if (subscriptionStatus != 'premium') {
      //         SubscriptionMethod().subscribe(
      //             subscribeId: subCategoryId,
      //             showRegular: false,
      //             title: LocaleKeys.premiumRequest.localize);
      //       } else {
      //         showModalBottomSheet(
      //           backgroundColor: Colors.white,
      //           context: context,
      //           shape: const RoundedRectangleBorder(
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(32.0),
      //               topRight: Radius.circular(32.0),
      //             ),
      //           ),
      //           isDismissible: true,
      //           isScrollControlled: true,
      //           builder: (BuildContext context) {
      //             return AnimatedPadding(
      //               padding: MediaQuery.of(context).viewInsets,
      //               duration: const Duration(milliseconds: 50),
      //               child: Container(
      //                 height: 400.h,
      //                 padding: EdgeInsets.symmetric(
      //                   vertical: 10.h,
      //                   horizontal: 10,
      //                 ),
      //                 child: Column(
      //                   children: [
      //                     Label(
      //                       text: LocaleKeys.enterPhoneNumber.localize,
      //                       style: Styles.headerText(),
      //                     ),
      //                     Sizer(
      //                       height: 30.h,
      //                     ),
      //                     Container(
      //                       constraints: BoxConstraints(maxHeight: 180.h),
      //                       child: Form(
      //                         key: controller.formKey,
      //                         child: TextFormField(
      //                           validator: (value) {
      //                             if ((value == null || value.isEmpty)) {
      //                               return LocaleKeys.required.localize;
      //                             } else {
      //                               return null;
      //                             }
      //                           },
      //                           // focusNode: focusNode,
      //                           maxLines: null,
      //                           maxLength: 150,
      //                           onChanged: (c) => controller.changePhone(v: c),
      //                           // controller: controller,
      //                           decoration: InputDecoration(
      //                               hintText: LocaleKeys.phoneNumber.localize,
      //                               fillColor: Colors.white,
      //                               hintStyle: Styles.mediumText(
      //                                   color: AppColors.DARK_GRAY_COLOR)),
      //                         ),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: Row(
      //                         children: [
      //                           Expanded(
      //                             child: InkWell(
      //                               onTap: () async {
      //                                 if (controller.formKey.currentState!
      //                                     .validate()) {
      //                                   await controller
      //                                       .makeAdPremiumRequest(id: adId)
      //                                       .then((value) {
      //                                     if (value == true) {
      //                                       context.pop();
      //                                       showSuccessMessage(context,
      //                                           'Request Sent Successfully');
      //                                       controller.resetRequest();
      //                                     } else {
      //                                       context.pop();
      //                                       if (state.failure != null) {
      //                                         showErrorMessage(
      //                                             context,
      //                                             getFailureMessage(
      //                                                 state.failure!, context));
      //                                       } else {
      //                                         showErrorMessage(
      //                                             context, 'Please Try Again!');
      //                                       }
      //                                     }
      //                                   });
      //                                 }
      //                               },
      //                               child: Container(
      //                                 width: 100,
      //                                 height: 80.h,
      //                                 padding: const EdgeInsets.all(5),
      //                                 decoration: BoxDecoration(
      //                                     color: AppColors.PRIMARY_COLOR,
      //                                     borderRadius:
      //                                         BorderRadius.circular(15)),
      //                                 alignment: Alignment.center,
      //                                 child: Label(
      //                                   text: LocaleKeys.send.localize,
      //                                   style: Styles.headerText(
      //                                       color: Colors.white),
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                           Expanded(
      //                             child: TextButton(
      //                               onPressed: () {
      //                                 Navigator.of(context).pop();
      //                               },
      //                               child: Label(
      //                                 text: LocaleKeys.cancel.localize,
      //                                 style: Styles.headerText(),
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             );
      //           },
      //         );
      //       }
      //     } else {
      //       context.push(Routes.LOGIN);
      //     }
      //   },
      // );
    });
  }
}
