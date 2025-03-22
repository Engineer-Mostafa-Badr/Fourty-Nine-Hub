import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';

class InstallmentOrderDetails extends StatelessWidget {
  const InstallmentOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildSellerWidget(),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return installmentPaymentStatus(
                      number: (index + 1), isPaid: index == 0);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: 4),
            const Sizer(),
            stepItemWidget(
                label: 'Step#1: Order Sent',
                isDone: true,
                icon: Icons.list,
                description: UIConst.placeholderText),
            stepItemWidget(
                label: 'Step#2: Order in process',
                isDone: false,
                icon: Icons.refresh,
                description: UIConst.placeholderText),
            stepItemWidget(
                label: 'Step#3: Order Accepted',
                isDone: false,
                icon: Icons.check,
                description: UIConst.placeholderText),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerWidget() {
    return Row(
      children: [
        const ProfileImage(
          size: 20,
          accountId: 0,
          userId: '',
        ),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
                text: 'Farouk Mohamed Shahin',
                style: Styles.mediumText(fontWeight: FontWeight.bold)),
            Label(
                text: 'First Payment Date: March 2024',
                style: Styles.mediumText())
          ],
        ))
      ],
    );
  }

  Widget installmentPaymentStatus({required int number, required bool isPaid}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Label(text: 'Payment: #$number', style: Styles.mediumText()),
            Label(text: 'March 2024', style: Styles.mediumText()),
          ],
        ),
        if (isPaid)
          Row(
            children: [
              const Icon(FontAwesomeIcons.ccVisa),
              const Sizer(),
              Label(text: 'xxx xxx xxx 4893', style: Styles.mediumText()),
            ],
          )
        else
          const BadgedLabel(
            label: 'Waiting',
            color: Colors.greenAccent,
          )
      ],
    );
  }

  Widget stepItemWidget(
      {required String label,
      required bool isDone,
      required IconData icon,
      required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
                backgroundColor:
                    isDone ? Colors.greenAccent : AppColors.LIGHT_GRAY_COLOR,
                child: Icon(
                  icon,
                  color: AppColors.LIGHT_COLOR,
                )),
            if (isDone)
              Container(
                width: .5,
                height: kToolbarHeight * 1,
                decoration: const BoxDecoration(color: Colors.greenAccent),
              ),
          ],
        ),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
                text: label,
                style: Styles.mediumText(
                    fontWeight: FontWeight.w500, fontSize: 18.sp)),
            ReadMoreLabel(text: description),
          ],
        )),
      ],
    );
  }
}
