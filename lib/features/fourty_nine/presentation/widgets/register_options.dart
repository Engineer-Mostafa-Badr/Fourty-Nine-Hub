import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';

class RegisterOptions extends StatelessWidget {
  const RegisterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'Join Us As',
            style: Styles.mediumText(fontWeight: FontWeight.w700),
          ),
          const Sizer(
            height: 3,
          ),
          SizedBox(
            height: kToolbarHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRegisterOptionItem(context,
                    label: 'Driver', image: Assets.driver),
                _buildRegisterOptionItem(context,
                    label: 'Women Only', image: Assets.driverWomen),
                _buildRegisterOptionItem(context,
                    label: 'Scooter', image: Assets.scooter),
                _buildRegisterOptionItem(context,
                    label: 'Restaurant', image: Assets.restaurant),
                _buildRegisterOptionItem(context,
                    label: 'Doctor', image: Assets.doctor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterOptionItem(BuildContext context,
      {required String label, required String image}) {
    return InkWell(
      onTap: () => context.go(Routes.REGISTERDRIVER),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: .5)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Image.asset(image)),
            Label(text: label),
          ],
        ),
      ),
    );
  }
}
