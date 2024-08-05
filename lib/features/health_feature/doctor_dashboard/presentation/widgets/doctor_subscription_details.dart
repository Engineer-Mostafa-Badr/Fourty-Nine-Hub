import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorRenewDayCountWidget extends StatelessWidget {
  const DoctorRenewDayCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: Labels.deadline,
          style: Styles.headerText(),
        ),
        const Sizer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _Item(
                numerOfDays: '50',
                label: Labels.subscription,
              ),
              _Item(
                numerOfDays: '2',
                label: Labels.id,
                onTap: () => context.push(Routes.EDITDOCTORDOCS),
              ),
              _Item(
                numerOfDays: '10',
                label: Labels.practiceCertification,
                onTap: () => context.push(Routes.EDITDOCTORDOCS),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final String numerOfDays;
  final String label;
  final Function()? onTap;
  const _Item({required this.numerOfDays, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            numerOfDays,
            style: Styles.headerText(),
          ),
          Text(
            label,
            style: Styles.mediumText(),
          ),
        ],
      ),
    );
  }
}
