import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/use_cases/cache_out/pay_out_request_use_case.dart';
import '../../../domain/use_cases/cache_out/request_yellow_card_use_case.dart';
import '../../cache_out_cubit/payment_cubit.dart'; // For image picking

class PaymentYellowCard extends StatefulWidget {
  const PaymentYellowCard({super.key});

  @override
  _PaymentYellowCardState createState() => _PaymentYellowCardState();
}

class _PaymentYellowCardState extends State<PaymentYellowCard> {
  bool hasYellowCard = true;
  bool isRequestingYellowCard = false;
  final TextEditingController yellowCardNumberController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    yellowCardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          serviceLocator<PaymentCacheOutCubit>()..loadData(),
      child: BlocConsumer<PaymentCacheOutCubit, PaymentCacheOutState>(
        listener: (BuildContext context, PaymentCacheOutState state) {
          if (state.status == StateStatus.success) {
            if(hasYellowCard)
              {showSuccessMessage(context, LocaleKeys.yellowCardSuccess.localize);
              }else{
              showSuccessMessage(context, LocaleKeys.receiveFawry.localize);
            }

          }
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          }
        },
        builder: (BuildContext context, state) {
          final controller = context.read<PaymentCacheOutCubit>();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Label(text: LocaleKeys.doYellowCard.localize),
                    value: hasYellowCard,
                    activeTrackColor: AppColors.SECONDARY_COLOR,
                    activeColor: AppColors.AUTH_CONTAINER_COLOR,
                    inactiveTrackColor: AppColors.GREY_NORMAL_COLOR,
                    onChanged: (value) {
                      setState(() {
                        hasYellowCard = value;
                      });
                    },
                  ),
                  if (hasYellowCard) ...[
                    Column(
                      children: [
                        buildInputField(
                          controller: amountController,
                          labelText: LocaleKeys.amount.localize,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.pleaseEnterTheAmount.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer(),
                        buildInputField(
                          controller: yellowCardNumberController,
                          labelText: LocaleKeys.yellowCardNumber.localize,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhoneNumber,
                        ),
                        const Sizer(),
                        InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              showAreYouSure(
                                  title: LocaleKeys.alert.localize,
                                  subTitle:
                                      LocaleKeys.sureWithdrawMoney.localize,
                                  action: () {
                                    context
                                        .read<PaymentCacheOutCubit>()
                                        .payOutRequest(
                                            params: PayoutRequestParams(
                                          amount: double.parse(
                                              amountController.text),
                                          payoutMethod: 'fawry_card',
                                          phoneNumber:
                                              yellowCardNumberController.text,
                                          payoutSource: 'main_wallet',
                                        ));
                                  },
                                  context: context);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 100.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Label(
                              text: LocaleKeys.submit.localize,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    InkWell(
                      onTap: () {
                        if (state.wallet!.realAmount >= 300) {
                          setState(() {
                            isRequestingYellowCard = true;
                          });
                        } else {
                          showErrorMessage(context,
                              LocaleKeys.atLeast300YellowCard.localize);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.SECONDARY_COLOR,
                        ),
                        child: Center(
                          child: Label(
                            text:
                                '${LocaleKeys.requestYellowCard.localize} (${state.price?.yellowCardCharge} ${state.price?.currency} ${LocaleKeys.deducted.localize})',
                            maxLines: 2,
                            color: AppColors.AUTH_CONTAINER_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isRequestingYellowCard && !hasYellowCard) ...[
                    Sizer(height: 50.h),
                    Text(
                      LocaleKeys.iDFrontAndBack.localize,
                      style: Styles.mediumText(),
                    ),
                    Sizer(height: 5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            leading:
                                                const Icon(Icons.photo_library),
                                            title: Text(
                                                LocaleKeys.gallery.localize),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              controller.uploadPhoto(
                                                  isGallery: true,
                                                  isFrontImage: true);
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: Text(
                                                LocaleKeys.camera.localize),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              controller.uploadPhoto(
                                                  isGallery: false,
                                                  isFrontImage: true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Label(
                                      text: state.frontImage == null
                                          ? LocaleKeys.uploadFrontID.localize
                                          : LocaleKeys.frontIDUploaded.localize,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              const Sizer(),
                              if (state.frontImage != null &&
                                  state.frontImage?.file != null)
                                Column(
                                  children: [
                                    // Use the path property of the XFile to create a File object
                                    Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        Image.file(
                                          File(state.frontImage!.file.path),
                                          // Use .path here
                                          width: double.infinity,
                                          height: 170.h,
                                          fit: BoxFit
                                              .fill, // Optional: to cover the area proportionally
                                        ),
                                        // IconButton(
                                        //   onPressed: () {
                                        //     context.read<PaymentCacheOutCubit>().removePhoto(isFrontImage: true);
                                        //   },
                                        //   icon: const Icon(
                                        //     Icons.close,
                                        //     color: AppColors.SECONDARY_COLOR,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            leading:
                                                const Icon(Icons.photo_library),
                                            title: Text(
                                                LocaleKeys.gallery.localize),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              controller.uploadPhoto(
                                                  isGallery: true,
                                                  isFrontImage: false);
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: Text(
                                                LocaleKeys.camera.localize),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              controller.uploadPhoto(
                                                  isGallery: false,
                                                  isFrontImage: false);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  print('FFFFFFFFFFFFFFFFFFFFFF');
                                  print(state.backColor);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Label(
                                      text: state.backImage == null
                                          ? LocaleKeys.uploadBackID.localize
                                          : LocaleKeys.BackIDUploaded.localize,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              const Sizer(),
                              if (state.backImage != null &&
                                  state.backImage?.file != null)
                                Column(
                                  children: [
                                    // Use the path property of the XFile to create a File object
                                    Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        Image.file(
                                          File(state.backImage!.file.path),
                                          // Use .path here
                                          width: double.infinity,
                                          height: 170.h,
                                          fit: BoxFit
                                              .fill, // Optional: to cover the area proportionally
                                        ),
                                        // IconButton(
                                        //   onPressed: () {
                                        //     context.read<PaymentCacheOutCubit>().removePhoto(isFrontImage: false);
                                        //   },
                                        //   icon: const Icon(
                                        //     Icons.close,
                                        //     color: AppColors.SECONDARY_COLOR,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Sizer(),
                    buildInputField(
                      controller: fullNameController,
                      labelText: LocaleKeys.fullName.localize,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterFullName.localize;
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    buildInputField(
                      controller: phoneController,
                      labelText: LocaleKeys.phoneNumber.localize,
                      validator: _validatePhoneNumber,
                    ),
                    const Sizer(),
                    buildInputField(
                      controller: nationalIdController,
                      labelText: LocaleKeys.nationalIdNumber.localize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterNationalId.localize;
                        }
                        if (!RegExp(r'^[0-9]{14}$').hasMatch(value)) {
                          return LocaleKeys.pleaseEnter14Digit.localize;
                        }
                        return null;
                      },
                    ),
                    Sizer(height: 30.h),
                    InkWell(
                      onTap: () {
                        print('object');
                        print(state.wallet?.realAmount);
                        if (isRequestingYellowCard &&
                            state.wallet!.realAmount >= 300) {
                          if (state.frontImage?.mediaId != null &&
                              state.backImage?.mediaId != null) {
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<PaymentCacheOutCubit>()
                                  .requestYellowCard(
                                      params: RequestYellowCardParams(
                                          nationalIdBack:
                                              state.frontImage!.mediaId,
                                          nationalIdFront:
                                              state.backImage!.mediaId,
                                          fullName: fullNameController.text,
                                          nationalIdNumber:
                                              nationalIdController.text,
                                          phoneNumber: phoneController.text));
                              print('FFFFFFFFFFFFFFFFFFFFFF');
                              print(state.frontImage?.mediaId);
                              print(state.backImage?.mediaId);
                            }
                          } else {
                            showErrorMessage(
                              context,
                              LocaleKeys.pleaseEnterFrontIdAndBackId.localize,
                            );
                          }
                        } else if (state.wallet!.realAmount < 300) {
                          showErrorMessage(context,
                              LocaleKeys.atLeast300YellowCard.localize);
                        }
                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 100.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Label(
                          text: LocaleKeys.submitYellowCardRequest.localize,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.transparent,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys
          .pleaseEnterYourPhoneNumber.localize; // Please enter a phone number
    }
    // Regex for Egyptian phone number
    final RegExp phoneRegExp = RegExp(r'^(01)[0-9]{9}$');
    if (!phoneRegExp.hasMatch(value)) {
      return LocaleKeys.invalidPhoneNumber.localize; // Invalid phone number
    }
    return null;
  }
}
