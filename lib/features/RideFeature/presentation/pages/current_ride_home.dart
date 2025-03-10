import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'widgets/dialog_widget/confirm_record_dialog.dart';
import 'widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'widgets/font_manager.dart';
import 'widgets/map_section.dart';
import 'widgets/otp_input_widget.dart';


class CurrentRideScreen extends StatefulWidget {
   const CurrentRideScreen({super.key});

  @override
  State<CurrentRideScreen> createState() => _CurrentRideScreenState();
}

class _CurrentRideScreenState extends State<CurrentRideScreen> {
  // // تحكم في الخريطة
  // GoogleMapController? _mapController;

  // final LatLng _initialPosition = const LatLng(30.0444, 31.2357);

  // final TextEditingController otpController = TextEditingController();

  // void _onMapCreated(GoogleMapController controller) {
  //   _mapController = controller;
  // }

   bool isOpenKeyBoard(){
     return MediaQuery.of(context).viewInsets.bottom >0?true:false;
   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Your current ride'),
      // ),
      body: SharedScaffold(
        mainCategoryId: 2,
        body: SafeArea(
          child: Column(
            children: [
             const Expanded(
                flex: 3,
                child: MapSection(),
                // Image.network(
                //   "https://miro.medium.com/v2/resize:fit:1024/1*lNbCllyMLyiVyGfY-HXHjw.png",
                //   width: double.infinity,
                //   height: MediaQuery.of(context).size.height * 0.5,
                //   fit: BoxFit.cover,
                // ),
              ),
              Expanded(
                flex: MediaQuery.of(context).viewInsets.bottom > 0 ? 2 : 4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? const Color(0xff2C2C2C) : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.isDarkMode ? Colors.black54 : Colors.grey.shade300,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isOpenKeyBoard())
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.CHECK_MARK_COLOR,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'أول العاشر من رمضان',
                                    style: TextStyle(
                                      color: context.isDarkMode ? AppColors.whiteColor : Colors.grey,
                                      fontSize: FontSize.s14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            if (!isOpenKeyBoard()) const SizedBox(height: 8),
                            if (!isOpenKeyBoard())
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.LIGHT_BLUE,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'المنطقة الصناعية العاشرة من رمضان (10th of Ramadan City 1) الثانية',
                                      style: TextStyle(
                                        fontSize: FontSize.s14,
                                        color: context.isDarkMode ? AppColors.whiteColor : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (!isOpenKeyBoard()) const SizedBox(height: 8),

                            // **OTP Widget**
                            OtpInputWidget(
                              length: 6,
                              onChanged: (otp) {
                              },
                              onCompleted: (otp) {
                              },
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.push(Routes.RideRequestHOME);


                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.colorNavy,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      isOpenKeyBoard() ? LocaleKeys.done.tr() : LocaleKeys.openGoogleMap.tr(),
                                      style: const TextStyle(fontSize: FontSize.s16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (!isOpenKeyBoard())
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showCustomDialogTrip(context,const ConfirmRecordDialog());
                                        // showCustomDialogTrip(context,WhyDoHaveCancelDialog());
                                        // showCustomDialogTrip(context,ClientCancelTripDialog());
                                        // showCustomDialogTrip(context,WrongOtpDialog());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.colorRed,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        LocaleKeys.start.tr(),
                                        style: const TextStyle(fontSize: FontSize.s16),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? const Color(0xff3A3A3A) : AppColors.colorGreyLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children:  [
                                  const Icon(Icons.info, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Travel time: ~14 min. Distance: 6.58 Km.',
                                      style: TextStyle(
                                        color:context.isDarkMode?AppColors.whiteColor: Colors.black87,
                                        fontSize: FontSize.s14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  foregroundColor: AppColors.colorRed,
                                  side: const BorderSide(color: Color(0xFFFF4C4C), width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.cancelTheRide.tr(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

          ],
          ),
        ),
      ),
    );
  }
}

