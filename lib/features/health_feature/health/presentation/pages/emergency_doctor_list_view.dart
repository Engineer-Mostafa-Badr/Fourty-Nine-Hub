import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_list/health_emergeny_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/page_name_row.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class EmergencyDoctorListView extends StatefulWidget {
  const EmergencyDoctorListView({
    super.key,
  });

  @override
  State<EmergencyDoctorListView> createState() => _EmergencyDoctorListViewState();
}

class _EmergencyDoctorListViewState extends State<EmergencyDoctorListView> {
  bool noDoctors = false;

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              PageNameRow(
                title: LocaleKeys.doctorList.localize,
              ),
              const Sizer(),
              if (noDoctors)
                Expanded(
                  child: Center(
                    child: Label(
                      text: LocaleKeys.noDoctorsFound.localize,
                      style: Styles.headerText(
                          fontWeight: FontWeight.w600, fontSize: 40),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      HealthEmergencyCard(
                        onTab: () {},
                        buttonTitle: LocaleKeys.book.localize,
                        isSubscribed: false,
                        title: 'Dr.Ibrahim Ahmed',
                        status: LocaleKeys.premium.localize,
                      ),
                      // Sizer(),
                      HealthEmergencyCard(
                        onTab: () {},
                        buttonTitle: LocaleKeys.book.localize,
                        isSubscribed: false,
                        title: 'Dr.Ibrahim Ahmed',
                        status: LocaleKeys.regular.localize,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ));
  }
}
