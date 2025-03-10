import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';


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
            icon:  Image.asset(Assets.emergencyIcon,width: 30,),
            label:  Text(LocaleKeys.call_emergency.localize),
          ),
          Container(
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
                  return ProtectionCard(item: items[index]);
                },
              ),
            ),
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
    // saftey
  }
}





class ProtectionItem {
  final String title;
  final IconData icon;
  final Color color;

  ProtectionItem({required this.title, required this.icon, required this.color});
}

List<ProtectionItem> items = [
  ProtectionItem(title: LocaleKeys.beforeTheTrip.localize, icon: Icons.info, color: Colors.red),
  ProtectionItem(title: LocaleKeys.identityVerification.localize, icon: Icons.verified_user, color: Colors.blue),
  ProtectionItem(title: LocaleKeys.securityFeatures.localize, icon: Icons.security, color: Colors.green),
  ProtectionItem(title: LocaleKeys.emergencyChat.localize, icon: Icons.chat, color: Colors.orange),
  ProtectionItem(title: LocaleKeys.carInspection.localize, icon: Icons.directions_car, color: Colors.redAccent),
  ProtectionItem(title: LocaleKeys.secureCommunications.localize, icon: Icons.message, color: Colors.purple),
];

class ProtectionCard extends StatelessWidget {
  final ProtectionItem item;

  const ProtectionCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 35, color: item.color),
          SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
