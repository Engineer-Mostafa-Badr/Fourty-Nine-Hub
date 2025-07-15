import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RunningTripClientWidget extends StatefulWidget {
  const RunningTripClientWidget({super.key, required this.client, this.index, required this.onPickClient});
  final BookingClientEntity client;
  final int? index;
  final Function(String otp) onPickClient;

  @override
  State<RunningTripClientWidget> createState() => _RunningTripClientWidgetState();
}

class _RunningTripClientWidgetState extends State<RunningTripClientWidget> {

  final TextEditingController otpController = TextEditingController();

  bool isGoingToClient = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 10,
                child: CircleAvatar(
                    backgroundColor: AppColors.getFillColor(context),
                    radius: 5),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.client.location.address,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  if(!isGoingToClient){
                    setState(() {
                      isGoingToClient=true;
                    });
                  }else{
                    if(otpController.text.isNotEmpty){
                      if(otpController.text.length==6){
                        widget.onPickClient(otpController.text);
                      }
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isGoingToClient?AppColors.SECONDARY_COLOR:AppColors.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isGoingToClient?context.isArabic?"بدء":"Start":
                    context.isArabic ? "الذهاب الي العميل ${widget.index==0?'الاول':widget.index==1?"الثاني":"الثالث"}" : "Go To ${widget.index==0?'First':widget.index==1?"Second":"Third"} Client",
                    style: const TextStyle(
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 25.h,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.isArabic ? "افتح خرائط جوجل" : "Open Google Map",
                  style: const TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: (!isGoingToClient?15:25).h,
        ),
        Row(
          children: [
            Expanded(
              child: CallMessageButtons(
                flex: 1,
                chatFlex: 1,
                otherUserId: '',
                subcategoryId: 'Constants',
                phone: 'widget.item.phone',
                id: 'widget.item.id',
                hasReport: false,
              ),
            ),
            SizedBox(
              width: 30.w,
            ),
            Expanded(
              child: ClickableWidget(
                onTap:!context.read<UserCubit>().isLoggedIn
                    ? () {
                  return pleaseLoginDialog(context);
                  // context.push(Routes.LOGIN);
                }
                    : () {
                  bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: 'widget.id',
                        categoryId: 'widget.subcategoryId',
                      ));
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.SECONDARY_COLOR,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.SECONDARY_COLOR),
                  ),
                  child: Text(
                    context.isArabic ? "تقرير العميل" : "Report Client",
                    style: const TextStyle(
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        if(isGoingToClient)PinCodeTextField(
          // onTap: () => _showOtpBottomSheet(context),
          // readOnly: true,
          appContext: context,
          length: 6,
          controller: otpController,
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
            widget.onPickClient(value);
          },
          onChanged: (value) {},
          validator: (value) {
            if (value == null || value.length < 6) {
              return context.isArabic?'يرجى إدخال رمز التحقيق المكون من 6 أرقام':'Please enter a 6-digit code';
            }
            return null;
          },
        ),
        Container(
          width: double.infinity,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.PRIMARY_COLOR),
          ),
          child: Text(
            context.isArabic ? "لم يظهر العميل" : "Client not show",
            style: const TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }
}
