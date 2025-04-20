import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/doctor_list_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/page_name_row.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorListHomeView extends StatefulWidget {
  const DoctorListHomeView({
    super.key,
  });

  @override
  State<DoctorListHomeView> createState() => _DoctorListHomeViewState();
}

class _DoctorListHomeViewState extends State<DoctorListHomeView> {
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
                      DoctorListCard(
                        onTab: () {},
                        buttonTitle: LocaleKeys.book.localize,
                        isSubscribed: true,
                        title: 'Dr.Ibrahim Ahmed',
                        status: LocaleKeys.premium.localize,
                      ),
                      // Sizer(),
                      DoctorListCard(
                        onTab: () {},
                        buttonTitle: LocaleKeys.book.localize,
                        isSubscribed: true,
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
