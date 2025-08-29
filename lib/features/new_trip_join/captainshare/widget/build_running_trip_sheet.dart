
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/service/bottom_sheet_helper.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_home.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/build_count_down_timer.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/running_route_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class BuildRunningTripSheet extends StatefulWidget {
  const BuildRunningTripSheet({super.key,required this.model});
  final RunningRouteEntity model;

  @override
  State<BuildRunningTripSheet> createState() => _BuildRunningTripSheetState();
}

class _BuildRunningTripSheetState extends State<BuildRunningTripSheet> {

  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    otpController.text = widget.model.otp.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        width: 160.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.black
                        ),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(
                          '${context.isArabic?widget.model.vehicleBrandAr:widget.model.vehicleBrandEn} ${context.isArabic?widget.model.vehicleModelAr:widget.model.vehicleModelEn}'
                      )),
                      Column(
                        children: [
                          ImageFromInternet(image: widget.model.carPicturesUrl??'',defaultLogo: true,width: 80,height: 34,borderRadius: BorderRadius.circular(12),),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? AppColors.GREY_DARK_COLOR
                                  : AppColors.GREY_NORMAL_COLOR
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child:  Text(
                                '${widget.model.plateInfo}'
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.GREY_DARK_COLOR
                              : AppColors.GREY_NORMAL_COLOR
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [

                              BuildCountDownTimer(
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () async {
                                  ManageVibration.vibrate();

                                },
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.6,
                                  decoration: BoxDecoration(
                                    color: AppColors.PRIMARY_COLOR,
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        context.isArabic
                                            ? "حسنا، أنا قادم"
                                            : "Ok, I'm coming",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  ActionButtonsWidget(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    driverImageUrl: widget.model.driverProfilePicUrl??'',
                    driverRating: (0).toDouble(),
                    driverName: widget.model.driverFirstName ?? '',
                    onSafety: (){},
                    is_show_message: true,
                    onMessage: () async {
                      ManageVibration.vibrate();
                      // BottomSheetHelper.startChatAndNavigate(
                      //   context: context,
                      //   otherUserId: 'widget.activeTrip?.clientId??''',
                      //   categoryId: 'widget.activeTrip?.subCategoryId??''',
                      // );
                    },
                    onContactDriver: () {
                      ManageVibration.vibrate();
                      // BottomSheetHelper.showCallOptionsBottomSheet(
                      //     context: context,
                      //     senderId: widget.activeTrip?.driverId ?? '',
                      //     senderFirstName: UserCubit.to.state.data?.firstName ?? '',
                      //     senderLastName: UserCubit.to.state.data?.lastName ?? '',
                      //     receiverId: widget.activeTrip?.clientId ?? '',
                      //     receiverName: widget.activeTrip?.clientName ?? '',
                      //     phoneNumber: '01145152315'
                      // );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      bottomSheet(
                          context: context,
                          widget: ReportView(
                            id: 'state.requestedTrip?.id ?? ""',
                            categoryId:
                            'state.requestedTrip?.subCategoryId ?? ""',
                          ));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.GREY_DARK_COLOR
                              : AppColors.GREY_NORMAL_COLOR
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border:
                          Border.all(color: AppColors.PRIMARY_COLOR),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Center(
                              child: Text(context.isArabic
                                  ? "الابلاغ عن السائق"
                                  : "Report Driver")),
                        )),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.isArabic ? "الدفع" : "Payment",
                          style: const TextStyle(
                            fontSize: FontSize.s25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.model.youPay}',
                        style: const TextStyle(
                          fontSize: FontSize.s25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10.h,
                      ),
                      Text(
                        context.isArabic ? "ج.م" : "EGP",
                        style: const TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  LocationInfoWidget(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    hasTitle: true,
                    from: widget.model.pickUp?.address??'',
                    to: widget.model.dropOff?.address??'',
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  PinCodeTextField(
                    // onTap: () => _showOtpBottomSheet(context),
                    // readOnly: true,
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    enabled: false,
                    autoDismissKeyboard: true,
                    autoDisposeControllers: true,
                    autoUnfocus: true,

                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                      inactiveColor: Colors.grey,
                      selectedColor: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    animationDuration:
                    const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: false,
                    enablePinAutofill: false,
                    onCompleted: (value) {
                      // widget.onPressed(otpController.text);
                    },
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return context.isArabic?'يرجى إدخال رمز التحقيق المكون من 6 أرقام':'Please enter a 6-digit code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        Assets.emergencyIcon,
                        color: Colors.red,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        context.isArabic ? "اتصل بالطوارئ" : "Call Emergency",
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.red.shade600,
                        size: 16,
                      ),
                    ],
                  )
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Container(
                  //   width: double.infinity,
                  //   height: 45,
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[100],
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: AppColors.PRIMARY_COLOR)
                  //   ),
                  //   child: Text(
                  //     context.isArabic ? "الغاء" : "Cancel",
                  //     style: const TextStyle(
                  //       fontSize: FontSize.s16,
                  //       fontWeight: FontWeight.bold,
                  //       color: AppColors.PRIMARY_COLOR,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
