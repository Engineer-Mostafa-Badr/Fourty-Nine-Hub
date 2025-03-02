import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'font_manager.dart';


class SafetyCard extends StatelessWidget {
  const SafetyCard({super.key});




  @override
  Widget build(BuildContext context) {

    return Container(
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
                style: TextStyle(fontSize: FontSize.s16, fontWeight: FontWeight.bold),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  flex: 2,
                  child: _buildFeatureButton(Icons.share, LocaleKeys.shareMyRide.localize, (){
                    context.push(Routes.rideFindingScreen);
                  },context)),
              Expanded(
                  flex: 2,
                  child: _buildFeatureButton(Icons.support_agent, LocaleKeys.support.localize, (){
                    context.push(Routes.rideFindingScreen);
                  },context)),
              Expanded(
                  flex: 2,
                  child: _buildFeatureButton(Icons.contacts, LocaleKeys.emergencyContacts.localize, (){
                    context.push(Routes.rideFindingScreen);
                  },context)),
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
            icon:  Image.asset(Assets.emergencyIcon),
            label:  Text(LocaleKeys.call_emergency.localize),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(IconData icon, String label, VoidCallback onTap,BuildContext context) {
    return Card(
      elevation: 0,
      color:context.isDarkMode?Theme.of(context).primaryColor.withOpacity(.2): AppColors.DIVIDER_GRAY_COLOR,
      child: Container(
        padding:const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          children: [
            IconButton(
              icon: Icon(icon, size: 28, ),
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
  }
}
