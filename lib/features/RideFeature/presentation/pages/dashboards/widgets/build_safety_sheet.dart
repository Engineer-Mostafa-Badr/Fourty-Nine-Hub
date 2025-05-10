import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/Build_safety_item.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_arrived_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/saftey_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

class BuildSafetySheet extends StatefulWidget {
  const BuildSafetySheet({super.key, this.onGoingToClient});
  final GestureTapCallback? onGoingToClient;

  @override
  State<BuildSafetySheet> createState() => _BuildSafetySheetState();
}

class _BuildSafetySheetState extends State<BuildSafetySheet> {

  List<ProtectionItem> items = [
    ProtectionItem(title: LocaleKeys.beforeTheTrip.localize, icon: Icons.info,image: Assets.beforeRide, color: Colors.red),
    ProtectionItem(title: LocaleKeys.identityVerification.localize, icon: Icons.verified_user,image: Assets.driverIdentityIcon, color: Colors.blue),
    ProtectionItem(title: LocaleKeys.securityFeatures.localize, icon: Icons.security,image: Assets.safetyRideIcon, color: Colors.green),
    ProtectionItem(title: LocaleKeys.emergencyChat.localize, icon: Icons.chat, image: Assets.emergencyChatIcon,color: Colors.orange),
    ProtectionItem(title: LocaleKeys.carInspection.localize, icon: Icons.directions_car, image: Assets.checkCarIcon,color: Colors.redAccent),
    ProtectionItem(title: LocaleKeys.secureCommunications.localize, icon: Icons.message,image: Assets.safeCommunications, color: Colors.purple),
  ];


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return   Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration:  BoxDecoration(
                      color:Theme.of(context).scaffoldBackgroundColor, // Colors.white,
                      borderRadius:const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow:const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 4,),
                            const Spacer(),
                            Text(
                              LocaleKeys.safetyFeatures.localize,
                              style: const TextStyle(fontSize: FontSize.s16, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              height: 35,
                              width: 35,
                              alignment: Alignment.center,
                              decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.DIVIDER_GRAY_COLOR
                              ),
                              child:const Icon(Icons.close,color: AppColors.black,),
                            ),
                            const SizedBox(width: 4,),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureButton(Assets.supportIcon, LocaleKeys.support.localize, (){
                              context.push(Routes.supportRideScreen);;
                            },context),
                            _buildFeatureButton(Assets.emergencyContactsIcon, LocaleKeys.emergencyContacts.localize, (){
                              context.push(Routes.rideFindingScreen);
                            },context),

                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: (){
                            context.push(Routes.rideFindingScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon:  SvgPicture.asset(Assets.callEmergencyIcon),
                          label:  Text(LocaleKeys.call_emergency.localize),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height*.58,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0,bottom: 16,left: 6,right: 6),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 3.0,
                                mainAxisSpacing: 3.0,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return BuildSafetyItem(item: items[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              );
          });
  }

  Widget _buildFeatureButton(String icon, String label, VoidCallback onTap,BuildContext context) {
    return Card(
      elevation: 0,
      color:context.isDarkMode?Theme.of(context).primaryColor.withOpacity(.2): AppColors.DIVIDER_GRAY_COLOR,
      child: Container(
        width: 220.w,
        padding:const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          children: [
            IconButton(
              icon: SvgPicture.asset(icon),
              onPressed: onTap,
            ),
            Container(
                height: 40,
                child: Center(child: Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: FontSize.s12)))),
          ],
        ),
      ),
    );
    // saftey
  }

}
