import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/pickup_text_form_field.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RequestButton extends StatelessWidget {
  const RequestButton({
    super.key,
    required this.adId,
    required this.subscriptionStatus,
    this.dontPop = false,
    required this.successRequest,
    required this.errorRequest,
  });

  final String adId;
  final String subscriptionStatus;
  final bool dontPop;
  final void Function() successRequest;
  final void Function(Failure? failure) errorRequest;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdvertisementCubit, AdsState>(
        listener: (advertisementContext, state) {
      if (state.requestStatus == AdsStates.requestSuccess) {
        successRequest();
      }
      if (state.requestStatus == AdsStates.error) {
        errorRequest(state.failure);
        // context.pop();
      }
    }, builder: (advertisementContext, state) {
      final controller = context.read<AdvertisementCubit>();

      return InkWell(
        onTap: !context.read<UserCubit>().isLoggedIn
            ? () {
                context.pop();
                return pleaseLoginDialog(context);

                // context.pushNamed(Routes.LOGIN);
              }
            // : subscriptionStatus == 'not subscribed'
            //     ? null
            : () {
                if (!dontPop) context.pop();
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
                    return RequestNumberBottomSheet(
                      // controller: controller,
                      // adId: adId,
                      formKey: controller.formKey,
                      textController: controller.phoneController,
                      onChanged: (c) => controller.changePhone(v: c),
                      isLoading:
                          controller.state.requestStatus == AdsStates.loading,
                      onTap: () async {
                        ManageVibration.vibrate();
                        if (controller.formKey.currentState!.validate()) {
                          await controller.makeAdRequest(id: adId);
                          //     .then((value) {
                          //   if (value == true) {
                          //     context.pop();
                          //     showSuccessMessage(
                          //         context, 'Request Sent Successfully');
                          //     controller.resetRequest();
                          //   } else {
                          //     context.pop();
                          //     if (state.failure != null) {
                          //       showErrorMessage(
                          //           context,
                          //           getFailureMessage(
                          //               state.failure!, context));
                          //     } else {
                          //       showErrorMessage(
                          //           context, 'Please Try Again!');
                          //     }
                          //   }
                          // }
                          // );
                        }
                        // else {
                        //   return pleaseLoginDialog(context);
                        //   // context.go(Routes.LOGIN);
                        // }
                      },
                    );
                  },
                );
              },
        child: Container(
          height: 38,
          decoration: ShapeDecoration(
            color: AppColors.getButtonPrimaryColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Center(
            child: Label(
              text: LocaleKeys.request.localize,
              style: Styles.headerText(
                color: AppColors.getReversedTextColor(context),
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
      //           context.pushNamed(Routes.LOGIN);
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

class RequestNumberBottomSheet extends StatefulWidget {
  const RequestNumberBottomSheet({
    super.key,
    // required this.controller,
    // required this.adId,
    required this.formKey,
    required this.onTap,
    required this.onChanged,
    required this.textController,
    required this.isLoading,
  });

  // final AdvertisementCubit controller;
  // final String adId;
  final GlobalKey<FormState> formKey;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController textController;
  final bool isLoading;

  @override
  State<RequestNumberBottomSheet> createState() =>
      _RequestNumberBottomSheetState();
}

class _RequestNumberBottomSheetState extends State<RequestNumberBottomSheet> {
  final RegExp _phonePattern =
      RegExp(r'(\+\d{1,3}[\s-]?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}|'
          r'\d{10}|'
          r'\d{3}[\s.-]\d{3}[\s.-]\d{4}|'
          r'\+\d{10,}');

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    widget.textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 50),
      child: Container(
        // height: 400.h,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label(
            //   text: LocaleKeys.enterPhoneNumber.localize,
            //   style: Styles.headerText(),
            // ),
            // Sizer(
            //   height: 30.h,
            // ),

            InkWell(
              onTap: () {
                ManageVibration.vibrate();
                focusNode.unfocus();
                context.pop();
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9D9D9),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Container(
            //   constraints: BoxConstraints(maxHeight: 180.h),
            //   child: Form(
            //     child: NewPhoneNumberTextFormField(
            //       style: TextStyle(
            //         color: AppColors.getTextColor(context),
            //       ),
            //       currentController: textController,
            //       isRequired: true,
            //       maxLength: 11,
            //       hintColor: AppColors.getTextColor(context),
            //       onChanged: onChanged,
            //       // controller: controller,
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 24,
            // ),
            Container(
              constraints: BoxConstraints(maxHeight: 180.h),
              child: Form(
                key: widget.formKey,
                child: PickUpTextFormField(
                  controller: widget.textController,
                  focusNode: focusNode,
                  onChanged: widget.onChanged,
                  fillColor: AppColors.getFillColor(context),
                  textColor: AppColors.getTextColor(context),
                  hintText: LocaleKeys.phoneNumber.localize,
                  fieldType: FieldType.phone,
                  validator: (value) => validatorPhone(value),
                  // validator: (value) {
                  //   if ((value == null || value.isEmpty)) {
                  //     return LocaleKeys.required.localize;
                  //   }
                  //   if (!_phonePattern.hasMatch(value)) {
                  //     return LocaleKeys.invalidPhoneNumber.localize;
                  //   }
                  //
                  //   return null;
                  // },
                  // controller: controller,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            widget.isLoading
                ? const CustomLoading()
                : InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      // width: 100,
                      // height: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: AppColors.getButtonPrimaryColor(context),
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      child: Label(
                        text: LocaleKeys.send.localize,
                        style: Styles.headerText(
                            color: AppColors.getReversedTextColor(context)),
                      ),
                    ),
                  ),
            // Expanded(
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: InkWell(
            //           onTap: onTap,
            //           child: Container(
            //             width: 100,
            //             height: 80.h,
            //             padding: const EdgeInsets.all(5),
            //             decoration: BoxDecoration(
            //                 color: AppColors.getButtonPrimaryColor(context),
            //                 borderRadius: BorderRadius.circular(15)),
            //             alignment: Alignment.center,
            //             child: Label(
            //               text: LocaleKeys.send.localize,
            //               style: Styles.headerText(
            //                   color: AppColors.getReversedTextColor(context)),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: TextButton(
            //           onPressed: () {
            //             Navigator.of(context).pop(); // Close the dialog
            //           },
            //           child: Label(
            //             text: LocaleKeys.cancel.localize,
            //             style: Styles.headerText(),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
