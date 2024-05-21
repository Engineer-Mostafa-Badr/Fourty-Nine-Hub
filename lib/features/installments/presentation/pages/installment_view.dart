import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/public/product_card.dart';
import '../widgets/public/vendor_card.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class InstallmentView extends StatelessWidget {
  const InstallmentView({super.key});

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
          _buildVendorsWidget(context: context),
          _buildOptionsWidget(context: context),
          _buildHorizontalCategories(context: context),
          _buildProductsWidget(),
        ],
      ),
    );
  }

  Widget _buildHorizontalCategories({
    required BuildContext context,
  }) {
    return SizedBox(
      height: kToolbarHeight * .5,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              bottomSheet(context: context, widget: Scaffold());
            },
            child: Container(
              height: kToolbarHeight * .5,
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.PRIMARY_COLOR),
                  color: AppColors.PRIMARY_COLOR),
              child: const Icon(
                Icons.sort,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: index == 0
                          ? null
                          : Border.all(color: AppColors.LIGHT_GRAY_COLOR),
                      color: index == 0
                          ? AppColors.PRIMARY_COLOR
                          : AppColors.LIGHT_GRAY_COLOR),
                  child: Center(
                    child: Label(
                        text: 'Goods',
                        style: Styles.mediumText(
                            color: index == 0 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500)),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Sizer(
                width: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          itemCount: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .8,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemBuilder: (context, index) => const ProductCard()),
    );
  }

  Widget _buildVendorsWidget({
    required BuildContext context,
  }) {
    return Container(
      height: kToolbarHeight * 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => const VendorCard(),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: 10),
    );
  }

  Widget _buildOptionsWidget({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: _buildOptionsItem(
                  label: 'My Requests',
                  icon: Icons.list,
                  color: AppColors.PRIMARY_COLOR,
                  onTap: () => context.push(Routes.INSTALLMENTORDERS))),
          const Sizer(),
          Expanded(
              child: _buildOptionsItem(
                  label: 'My Products',
                  icon: Icons.receipt_long,
                  color: AppColors.DARK_GRAY_COLOR,
                  onTap: () => context.push(Routes.INSTALLMENTORDERS)))
        ],
      ),
    );
  }

  Widget _buildOptionsItem(
      {required String label,
      required IconData icon,
      required Function onTap,
      required Color color}) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Label(text: label, style: Styles.mediumText(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
