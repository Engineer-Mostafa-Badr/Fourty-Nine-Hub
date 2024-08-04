import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Item(
                numerOfDays: '50',
                label: Labels.subscription,
              ),
              _Item(numerOfDays: '2', label: Labels.id),
              _Item(numerOfDays: '10', label: Labels.practiceCertification),
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
  const _Item({required this.numerOfDays, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
