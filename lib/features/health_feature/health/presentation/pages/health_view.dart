import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import '../cubit/health_cubit.dart';
import '../widgets/customer/booking_card.dart';
import '../widgets/customer/visita_options.dart';
import '../../../../../res/style/app_colors.dart';

class HealthView extends StatelessWidget {
  const HealthView({super.key});

  final bool isDoctor = false;

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
            return ListView(
              children: [
                if (state.subCategories != null &&
                    (state.subCategories?.isNotEmpty ?? false))
                  VisitaOptions(options: state.subCategories!),
                const Sizer(),
                const DashboardBanner(
                  title: 'Doctor Dashboard\n',
                  subTitle:
                      'New Bookings are waiting you, go to doctor dashboard and explore more!',
                  route: Routes.DOCTORDASHBOARD,
                ),
                const Sizer(),
                _buildCurrentBookings(),
                const Sizer(),
              ],
            );
          }),
        ));
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
