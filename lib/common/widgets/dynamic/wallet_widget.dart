import 'package:flutter/material.dart';

import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class WalletWidget extends StatelessWidget {
  final double? margin;

  const WalletWidget({super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: margin ?? 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: AppColors.GRAY_LIGHT_COLOR3,
              blurRadius: 5,
              spreadRadius: 5,
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 3,
            backgroundColor: AppColors.SECONDARY_COLOR,
          ),
          const Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                  text: 'Balance',
                  style: Styles.mediumText(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              const Sizer(),
              Label(
                  text: '1200',
                  style: Styles.mediumText(
                      color: AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          )),
          Container(
            width: .5,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey,
            height: kToolbarHeight * .6,
          ),
          const CircleAvatar(
            radius: 3,
            backgroundColor: AppColors.SECONDARY_COLOR,
          ),
          const Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                  text: 'Gift Wallet',
                  style: Styles.mediumText(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              const Sizer(),
              Label(
                  text: '300',
                  style: Styles.mediumText(
                      color: const Color.fromARGB(255, 87, 87, 87),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          )),
          Container(
            width: .5,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey,
            height: kToolbarHeight * .6,
          ),
          const CircleAvatar(
            radius: 3,
            backgroundColor: AppColors.SECONDARY_COLOR,
          ),
          const Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                  text: 'Wallet',
                  style: Styles.mediumText(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              const Sizer(),
              Label(
                  text: '400',
                  style: Styles.mediumText(
                      color: const Color.fromARGB(255, 87, 87, 87),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          )),
        ],
      ),
    );
  }
}
