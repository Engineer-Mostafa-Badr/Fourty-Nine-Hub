import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/cubit/health_cubit.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../health_care/data/models/visita_option_model.dart';
import '../../widgets/customer/booking_card.dart';
import '../../widgets/customer/visita_options.dart';

class VisitaCustomerView extends StatelessWidget {
  const VisitaCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
            return ListView(
              children: <Widget>[
                Label(
                    text: '49 HOSPITALITY',
                    style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                const Sizer(),
                if (state.subCategories != null &&
                    (state.subCategories?.isNotEmpty ?? false))
                  VisitaOptions(options: state.subCategories!),
                const Sizer(),
                _buildCurrentBookings(),
                const Sizer(),

                // _buildBookNowWidget(),
                // _buildDoctorsFilter(),
                // const Sizer(),
                // _buildDoctorsWidget(),
              ],
            );
          })),
    );
  }

  Widget _buildCurrentBookings() {
    return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => VisitaBookingCard(
                appointment: state.myBookings![index],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: state.myBookings?.length ?? 0);
    });
  }

  Widget _buildBookNowWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.PRIMARY_COLOR),
      child: Column(
        children: [
          Image.asset(
            Assets.logo,
            height: 80,
          ),
          const Sizer(),
          Label(
              text: UIConst.placeholderText,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Styles.mediumText(
                color: Colors.white,
              )),
          const Sizer(),
          AppButton(
            label: 'Show Details',
            onPressed: () {},
            backColor: Colors.white,
            textColor: AppColors.PRIMARY_COLOR,
          )
        ],
      ),
    );
  }
}
