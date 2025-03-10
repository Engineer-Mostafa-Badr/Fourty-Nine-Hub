import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'font_manager.dart';
import 'payment_info_widget.dart';

class RideFindingCard extends StatefulWidget {
  const RideFindingCard({super.key});

  @override
  State<RideFindingCard> createState() => _RideFindingCardState();
}
bool switchAcceptFirstDriver= false;
int price = 79;
class _RideFindingCardState extends State<RideFindingCard> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
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
           Text(
            LocaleKeys.findingDrivers.localize,
            style: const TextStyle(fontSize: FontSize.s18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!switchAcceptFirstDriver)
              _fareButton("-3", () {
                if(price>3) {
                  price = price - 3;
                  setState(() {});
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "EGP $price",
                  style: const TextStyle(fontSize:  FontSize.s20, fontWeight: FontWeight.bold),
                ),
              ),
              if(!switchAcceptFirstDriver)
              _fareButton("+3", () {

                  price = price + 3;
                  setState(() {});

              }),
            ],
          ),
          const SizedBox(height: 8),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     elevation: 0,
          //     backgroundColor: AppColors.grey,
          //     foregroundColor: AppColors.PRIMARY_COLOR_DARK,
          //     shape: RoundedRectangleBorder(
          //
          //         borderRadius: BorderRadius.circular(10)),
          //     minimumSize: const Size(double.infinity, 48),
          //   ),
          //   child: const Text("Raise Faire"),
          // ),
          const SizedBox(height: 8),
          if(!switchAcceptFirstDriver)
          Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.buttonDialog,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(LocaleKeys.raiseFare.localize,style:const TextStyle(
              fontSize: FontSize.s16,

              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(Assets.automatic2AcceptIcon,color: context.isDarkMode?Colors.white:Colors.black,),
               Expanded(child: Text(LocaleKeys.automaticallyAcceptTheNearest.localize +"$price EGP")),
              Switch(
                value: switchAcceptFirstDriver,
                onChanged: (value) {
                  switchAcceptFirstDriver=value;
                  setState(() {});
                },
                activeColor: AppColors.PRIMARY_COLOR,
                activeTrackColor: AppColors.LightWHATS_APP_COLOR,
                inactiveThumbColor: AppColors.PRIMARY_COLOR,
                inactiveTrackColor: AppColors.LIGHT_GRAY_COLOR,
              ),

            ],
          ),
          const SizedBox(height: 4),
          PaymentInfoWidget(price: price,),

          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                LocaleKeys.yourCurrentRide.localize,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _locationRow("أول العاشر من رمضان", Colors.blue),
         const SizedBox(height: 10,),
          _locationRow("المنطقة الصناعية الثالثة العاشر من رمضان", Colors.green),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: (){
              // context.push(Routes.supportRideScreen);
            },
            child: Container(
              width: double.infinity,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(LocaleKeys.cancelOrder.localize,style:const TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY_COLOR_DARK,
              ),),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     elevation: 0,
          //     backgroundColor: AppColors.BG_GRAY_COLOR,
          //     foregroundColor: AppColors.PRIMARY_COLOR_DARK,
          //     shape: RoundedRectangleBorder(
          //
          //         borderRadius: BorderRadius.circular(10)),
          //     minimumSize: const Size(double.infinity, 48),
          //   ),
          //   child: const Text("Cancel Order"),
          // ),
        ],
      ),
    );
  }

  Widget _fareButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:AppColors.PRIMARY_COLOR,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontSize:  FontSize.s16)),
    );
  }

  Widget _locationRow(String location, Color color) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            border: Border.all(
              color: color,
              width: 4
            )
          ),
        ),
        const SizedBox(width: 8),
        Text(location),
      ],
    );
  }
}