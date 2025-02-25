import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_color_circle_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/pickup_location_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Label(text:LocaleKeys.rideDetails.localize,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(Assets.map2,fit: BoxFit.cover,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child:  Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Label(
                          text: "Captain ride with Mohammed",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 4,),
                        Label(
                          text: "Feb 13 - 12:41 PM",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Label(
                          text: "150 EGP",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              Assets.greyCar,
                              width: 120,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 8,
                            child: Container(
                              alignment: Alignment.center,
                              width: 32,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.cF5F5F5,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 12,
                                  ),
                                  Label(
                                    text: "3.5",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 97,
                  decoration: BoxDecoration(
                    color: AppColors.cF3F3F3,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 4,
                      children: [
                        SvgPicture.asset(Assets.receiptIcon),
                        Label(text: LocaleKeys.receipt.localize,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16,),
               const Row(
                spacing: 18,
                children: [
                  CustomColorCircleWidget(firstColor: AppColors.c19D176,),
                   Expanded(child:   Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Label(text: "Cairo International Airport"
                      ,style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),),
                    SizedBox(height: 2,),
                    Label(text: "Heliopolis, El Nozha, Cairo Governora...",style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),),
                  ],
                ),),
                  Label(text: "12:10 PM",style: TextStyle(
                    color: AppColors.c5A5A5A,
                    fontSize: 14,
                    fontWeight: FontWeight.w700
                  ),),
                ],
              ),
              const SizedBox(height: 16,),
              const Row(
                spacing: 18,
                children: [
                  CustomColorCircleWidget(firstColor: AppColors.c3897F0,),
                  Expanded(child:   Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Label(text: "Cairo International Airport"
                        ,style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),),
                      SizedBox(height: 2,),
                      Label(text: "Heliopolis, El Nozha, Cairo Governora...",style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),),
                    ],
                  ),),
                  Label(text: "12:10 PM",style: TextStyle(
                      color: AppColors.c5A5A5A,
                      fontSize: 14,
                      fontWeight: FontWeight.w700
                  ),),
                ],
              ),
              const SizedBox(height: 38,),
              Row(
                children: [
                  SvgPicture.asset(Assets.star2),
                  const SizedBox(width: 16,),
                  Label(text: LocaleKeys.noRating.localize,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cF3F3F3,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Label(text: LocaleKeys.rate.localize,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    ),
                  ),
                ],
              ),
            ], 
          ),
        ),
      ),
    );
  }
}
