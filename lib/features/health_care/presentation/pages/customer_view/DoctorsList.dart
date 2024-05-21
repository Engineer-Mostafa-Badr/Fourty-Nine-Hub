import 'package:flutter/material.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../widgets/customer/doctor_card.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildDoctorsFilter(context: context),
            _buildDoctorsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsFilter({required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'Sorting',
              icon: Icons.filter_alt_rounded,
              onPressed: () {
                bottomSheet(
                    // isScrollControlled: true,
                    context: context,
                    widget: Column(
                      children: [],
                    ));
              },
              backColor: AppColors.PRIMARY_COLOR,
            ),
          ),
          const Sizer(),
          Expanded(
            child: AppButton(
              label: 'Filter',
              icon: Icons.sort,
              onPressed: () {
                bottomSheet(
                    // isScrollControlled: true,
                    context: context,
                    widget: Column(
                      children: [],
                    ));
              },
              backColor: AppColors.PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsWidget() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const DoctorCard(),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 4);
  }
}
