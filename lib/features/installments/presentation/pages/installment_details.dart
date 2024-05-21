import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/const.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class InstallmentsDetails extends StatelessWidget {
  const InstallmentsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 1,
        index: 2,
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        children: [
          _buildHeaderWidget(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Sizer(),
                AppButton(
                    label: 'Buy with installment',
                    onPressed: () =>
                        context.push(Routes.INSTALLMENTORDERDETAILS)),
                const Sizer(),
                info(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        infoItem(icon: Icons.delivery_dining, label: 'Free Delivery'),
        Label(
            text: 'Description',
            style: Styles.mediumText(fontWeight: FontWeight.bold)),
        const Sizer(),
        const ReadMoreLabel(text: UIConst.placeholderText),
      ],
    );
  }

  Widget infoItem({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.PRIMARY_COLOR,
          size: 20,
        ),
        const Sizer(),
        Expanded(child: Label(text: label, style: Styles.mediumText()))
      ],
    );
  }

  Widget _buildHeaderWidget() {
    return Column(
      children: [
        const SquareImage(
            height: kToolbarHeight * 3,
            width: double.infinity,
            fit: BoxFit.cover,
            source: NetworkImage(UIConst.productImage)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                      text: '100 EGP/month',
                      style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                  Label(
                      text: 'Nike',
                      style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                ],
              ),
              RichText(
                  text: TextSpan(
                      children: [0, 1, 2, 3, 4, 5].map((e) {
                return WidgetSpan(
                    child: Container(
                  margin: const EdgeInsets.all(3),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      color: e == 0 ? AppColors.SECONDARY_COLOR : null,
                      borderRadius: BorderRadius.circular(5),
                      border: e == 0 ? null : Border.all(color: Colors.grey)),
                  child: Label(
                      text: '${(6 + e * 3)} Months',
                      style: Styles.mediumText(
                          color: e == 0 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold)),
                ));
              }).toList())),
              Label(
                  text: 'Nike Shoes',
                  style: Styles.mediumText(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
