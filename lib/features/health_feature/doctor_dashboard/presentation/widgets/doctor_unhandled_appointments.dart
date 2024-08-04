import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorUnhandledAppointmentsWidget extends StatelessWidget {
  const DoctorUnhandledAppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: Labels.unhandledAppointments,
          style: Styles.headerText(),
        ),
        const Sizer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: 2,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: SquareImage(
                            url: UIConst.profilePlaceHolder,
                          )),
                      const Sizer(),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Label(
                              text: 'Ahmed Mohamed',
                              style: Styles.headerText(),
                            ),
                            Label(
                              text: 'Clinic\n9:00 - 10:00 AM',
                              style: Styles.mediumText(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            AppButton(
                              label: Labels.accept,
                              onPressed: () {},
                              backColor: AppColors.PRIMARY_COLOR,
                            ),
                            const Sizer(),
                            AppButton(
                              label: Labels.reject,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Sizer(),
              AppButton(label: Labels.viewMore, onPressed: () {})
            ],
          ),
        ),
      ],
    );
  }
}
