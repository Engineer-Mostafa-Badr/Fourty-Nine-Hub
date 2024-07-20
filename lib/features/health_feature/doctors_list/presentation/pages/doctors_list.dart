import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/presentation/cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/presentation/widgets/select_city.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../widgets/doctor_card.dart';
import '../widgets/select_state.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDoctorsFilter(context: context),
            const Sizer(),
            Expanded(child: _buildDoctorsWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsFilter({required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Expanded(
          //   child: AppButton(
          //     label: 'Sorting',
          //     icon: Icons.filter_alt_rounded,
          //     onPressed: () {
          //       bottomSheet(
          //           // isScrollControlled: true,
          //           context: context,
          //           widget: Column(
          //             children: [],
          //           ));
          //     },
          //     backColor: AppColors.PRIMARY_COLOR,
          //   ),
          // ),
          // const Sizer(),
          // Expanded(
          //   child: AppButton(
          //     label: 'Filter',
          //     icon: Icons.sort,
          //     onPressed: () {},
          //     backColor: AppColors.PRIMARY_COLOR,
          //   ),
          // ),
          Label(
            text: Labels.doctorsList,
            style: Styles.mediumText(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconAppButton(
              icon: Icons.sort,
              onPressed: () {
                bottomSheet(
                    // isScrollControlled: true,
                    context: context,
                    widget: _buildFiltersWidget(context: context));
              })
        ],
      ),
    );
  }

  Widget _buildFiltersWidget({required BuildContext context}) {
    final controller = context.read<DoctorsListCubit>();
    return BlocBuilder<DoctorsListCubit, DoctorsListState>(
        builder: (context, state) {
      return Column(
        children: [
          ListTile(
            title: Label(
              text: Labels.state,
              style: Styles.mediumText(),
            ),
            subtitle: Label(
              text: state.selectedState?.name ?? Labels.notSelected,
              style: Styles.mediumText(),
            ),
            onTap: () => bottomSheet(
              isScrollControlled: true,
              context: context,
              widget: SelectState(
                states: state.states ?? [],
                onSelected: (v) => controller.selectState(v: v),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Label(
              text: Labels.city,
              style: Styles.mediumText(),
            ),
            subtitle: Label(
              text: state.selectedCity?.name ?? Labels.notSelected,
              style: Styles.mediumText(),
            ),
            onTap: () => bottomSheet(
              isScrollControlled: true,
              context: context,
              widget: SelectCity(
                cities: state.cities ?? [],
                onSelected: (v) => controller.selectCity(v: v),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDoctorsWidget() {
    return BlocBuilder<DoctorsListCubit, DoctorsListState>(
        builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => DoctorCard(
                doctor: state.doctors![index],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: state.doctors?.length ?? 0);
    });
  }
}
