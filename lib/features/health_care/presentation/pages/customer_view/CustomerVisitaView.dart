import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../data/models/visita_option_model.dart';
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
        child: ListView(
          children: <Widget>[
            Label(
                text: '49 HOSPITALITY',
                style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
            const Sizer(),
            VisitaOptions(
              options: [
                VisitaOptionModel(
                    name: 'كشف عيادة',
                    image:
                        'https://cdn-icons-png.flaticon.com/512/2449/2449899.png',
                    description: 'كشف عيادة'),
                VisitaOptionModel(
                    name: 'مكالمة دكتور',
                    image:
                        'https://cdn2.iconfinder.com/data/icons/coronavirus-information/128/coronovirus_call_doctor_hospital-512.png',
                    description: 'كشف عيادة'),
                VisitaOptionModel(
                    name: 'زيارة منزلية',
                    image:
                        'https://cdn-icons-png.flaticon.com/512/2449/2449899.png',
                    description: 'كشف عيادة'),
                VisitaOptionModel(
                    name: 'خدمة أو عملية',
                    image:
                        'https://cdn-icons-png.flaticon.com/512/2449/2449899.png',
                    description: 'كشف عيادة'),
              ],
            ),
            const Sizer(),
            _buildCurrentBookings(),
            const Sizer(),

            _buildBookNowWidget(),
            // _buildDoctorsFilter(),
            // const Sizer(),
            // _buildDoctorsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBookings() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const VisitaBookingCard(),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 2);
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
