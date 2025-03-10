import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/car_circle_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/info_column_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/person_trip_widget.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';

 
// ignore: must_be_immutable
class RunningTripScreen extends StatelessWidget {
  RunningTripScreen({super.key});

  List<String> images = [
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar
  ];
  List<String> titles = [
    "Women",
    "Captain",
    "Women",
    "Captain",
    "Women",
    "Captain",
    "Women",
    "Captain",
  ];
  List<String> columnTitle = [
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
  ];
  List<String> columnDate = [
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
  ];
  List<String> columnPrice = [
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
  ];
  List<String> imagesRate = [
    Assets.personalImage,
    Assets.personalImage,
    Assets.personalImage,
    Assets.personalImage,
    Assets.personalImage,
    Assets.personalImage,
    Assets.personalImage,
    Assets.personalImage,
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Transform(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          child:  Text(
            LocaleKeys.runningTrips.localize,
            style: const TextStyle(
                // color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 24),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarContainer(title: titles[index], image: images[index]),
                  const SizedBox(
                    width: 16,
                  ),
                  PriceColumn(title: columnTitle[index], date: columnDate[index],price: columnPrice[index]),
                  const Spacer(),
                  PersonTripWidget(image: imagesRate[index], name: 'Montaser', ),
                ],
              ),
            );
          }),
    );
  }





}
