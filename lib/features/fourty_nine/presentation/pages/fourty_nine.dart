import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';

class FourtyNineView extends StatefulWidget {
  const FourtyNineView({super.key});

  @override
  State<FourtyNineView> createState() => _FourtyNineViewState();
}

class _FourtyNineViewState extends State<FourtyNineView> {
  List<int> services = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  bool isList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 1,
        index: 2,
      ),
      floatingActionButton: const FloatingButton(
        changeView: 1,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WalletWidget(
              margin: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.GREY_LIGHT_COLOR,
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMazadatWidget(),
                    ],
                  ),
                  const Sizer(),
                  _buildHorizontalServices(),
                  _buildViewType(),
                  _buildFourtyNineServices(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMazadatWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () => context.go(Routes.MAZADAT),
          child: SizedBox(
            height: kToolbarHeight * .5,
            width: kToolbarHeight * 2,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: AppButton(
                      label: 'Auction',
                      icon: Icons.group,
                      onPressed: () => context.push(Routes.MAZADAT)),
                )),
                const Positioned(
                    bottom: 5,
                    left: 5,
                    child: Icon(
                      Icons.star,
                      size: 10,
                      color: AppColors.ACCENT_COLOR,
                    )),
                const Positioned(
                    top: 0,
                    left: 10,
                    child: Icon(
                      Icons.star,
                      size: 10,
                      color: AppColors.ACCENT_COLOR,
                    )),
                const Positioned(
                    top: 15,
                    right: 10,
                    child: Icon(
                      Icons.star,
                      size: 10,
                      color: AppColors.ACCENT_COLOR,
                    ))
              ],
            ),
          ),
        ),
        const Sizer(),
        AppButton(
            padding: 5,
            height: kToolbarHeight * .5,
            label: 'Installments',
            icon: Icons.list,
            onPressed: () => context.push(Routes.INSTALLMENT))
      ],
    );
  }

  Widget _buildViewType() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: kToolbarHeight * 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.PRIMARY_COLOR)),
      child: Row(
        children: [
          Expanded(child: _buildViewItem(icon: Icons.list, isSelected: isList)),
          Expanded(
              child: _buildViewItem(
                  icon: Icons.grid_4x4_outlined, isSelected: !isList)),
        ],
      ),
    );
  }

  Widget _buildViewItem({required IconData icon, required bool isSelected}) {
    return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected ? AppColors.PRIMARY_COLOR : Colors.white),
        child: InkWell(
            onTap: () {
              isList = !isList;
              setState(() {});
            },
            child: Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.PRIMARY_COLOR,
            )));
  }

  Widget _buildFourtyNineServices() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Label(
        text: 'Cars',
        style: Styles.headerText(),
      ),
      GridView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: isList ? 10 : 0,
              mainAxisSpacing: isList ? 10 : 0,
              crossAxisCount: isList ? 2 : 4,
              childAspectRatio: isList ? 2.5 : 1),
          itemBuilder: (context, index) {
            return _buildServiceItem();
          }),
      Label(
        text: 'Health',
        style: Styles.headerText(),
      ),
      GridView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: isList ? 10 : 0,
              mainAxisSpacing: isList ? 10 : 0,
              crossAxisCount: isList ? 2 : 4,
              childAspectRatio: isList ? 2.5 : 1),
          itemBuilder: (context, index) {
            return _buildServiceItem();
          }),
      Label(
        text: 'Social',
        style: Styles.headerText(),
      ),
      GridView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: isList ? 10 : 0,
              mainAxisSpacing: isList ? 10 : 0,
              crossAxisCount: isList ? 2 : 4,
              childAspectRatio: isList ? 2.5 : 1),
          itemBuilder: (context, index) {
            return _buildServiceItem();
          }),
    ]);
  }

  Widget _buildHorizontalServices() {
    return SizedBox(
      height: kToolbarHeight * .5,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.PRIMARY_COLOR),
            child: Center(
              child: Label(
                  text: 'Ride',
                  style: Styles.mediumText(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          );
        },
        separatorBuilder: (context, index) => const Sizer(
          width: 0,
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
            ),
            Expanded(
                child: Label(text: 'Cairo , Egypt', style: Styles.mediumText()))
          ],
        ),
        const Sizer(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              height: kToolbarHeight * .7,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.GRAY_LIGHT_COLOR3),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Label(text: 'Search', style: Styles.mediumText())
                ],
              ),
            )),
            const Sizer(),
            Container(
              height: kToolbarHeight * .7,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.GRAY_LIGHT_COLOR3),
              child: const Icon(
                Icons.sort,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          ],
        ),
        const Sizer(),
        Row(
          children: [
            Container(
              height: kToolbarHeight * .5,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.PRIMARY_COLOR)),
              child: Row(
                children: [
                  const Icon(Icons.repeat_sharp,
                      color: AppColors.PRIMARY_COLOR),
                  Label(text: 'Highly Related', style: Styles.mediumText())
                ],
              ),
            ),
            _buildFilterItem(),
            _buildFilterItem(),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterItem() {
    return Container(
      height: kToolbarHeight * .5,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.PRIMARY_COLOR,
      ),
      child: Row(
        children: [
          Label(text: 'Car', style: Styles.mediumText(color: Colors.white)),
          const Sizer(
            width: 5,
          ),
          const Icon(
            Icons.clear,
            color: Colors.white,
            size: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem() {
    return isList
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              // padding: const EdgeInsets.all(5),
              // margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      UIConst.imagePlaceHolder,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                      child: Container(
                    color: Colors.black.withOpacity(.2),
                  )),
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Label(
                                  text: 'Ride',
                                  style: Styles.headerText(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Label(
                                  text: '14 Ads',
                                  style: Styles.mediumText(color: Colors.white))
                            ],
                          )),
                          const Sizer(),
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.LIGHT_GRAY_COLOR,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Column(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.PRIMARY_COLOR,
                backgroundImage: NetworkImage(UIConst.imagePlaceHolder),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Ride',
                    style: Styles.mediumText(fontWeight: FontWeight.w700)),
                TextSpan(
                    text: ' /12 Ads',
                    style: Styles.smallText(
                        fontWeight: FontWeight.w700, color: Colors.grey)),
              ])),
            ],
          );
  }
}
