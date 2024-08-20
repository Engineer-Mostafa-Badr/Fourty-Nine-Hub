import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BookDoctorAppointmentCardInfo extends StatelessWidget {
  final IconData icon;
  final Widget widget;
  final double height;
  const BookDoctorAppointmentCardInfo({
    super.key,
    required this.icon,
    required this.widget,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.PRIMARY_COLOR,
              ),
              Container(
                height: 2,
                width: kToolbarHeight * .5,
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: AppColors.SECONDARY_COLOR,
              )
            ],
          ),
          Container(
            height: height,
            width: .5,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.GREY_DARK_COLOR,
          ),
          Expanded(child: widget),
        ],
      ),
    );
  }
}
