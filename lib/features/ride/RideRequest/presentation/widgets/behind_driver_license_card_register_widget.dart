import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BehindDriverLicenseCardRegisterWidget extends StatelessWidget {
  const BehindDriverLicenseCardRegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 30)
                  ]
                ),
      child: Column(
        children: [
          Text(
            "الجانب الخلفي من رخصة السائق",
            style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 40),
          ),
          Sizer(),
          Image.asset(Assets.driversLicense),
          Sizer(),
          Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: Text(
                  "إضافة صورة",
                  style: Styles.mediumText(),
                )),
              ),
        ],
      ),
    );
  }
}