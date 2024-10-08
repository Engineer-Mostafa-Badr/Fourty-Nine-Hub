import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/presentation/widgets/available_routed_builder.dart';
import 'package:fourtyninehub/features/carpool/presentation/widgets/map_and_address_finder_car_pool.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CarPoolBody extends StatefulWidget {
  const CarPoolBody({super.key});

  @override
  State<CarPoolBody> createState() => _CarPoolBodyState();
}

class _CarPoolBodyState extends State<CarPoolBody> {
  bool showAvailableRoutes = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.h),
      child: CustomScrollView(
        slivers: [
          const MapAndAddressFinderCarPool(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showAvailableRoutes = true;
                        setState(() {});
                      },
                      child: Container(
                        width: 225.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 5.w),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: showAvailableRoutes
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.grey,
                              width: showAvailableRoutes ? 2 : 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'Avalilable Routes',
                          style: Styles.mediumText(),
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        showAvailableRoutes = false;
                        setState(() {});
                      },
                      child: Container(
                        width: 225.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 5.w),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: !showAvailableRoutes
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.grey,
                              width: !showAvailableRoutes ? 2 : 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'Runing Trips',
                          style: Styles.mediumText(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                return Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: showAvailableRoutes
                        ? const AvailableRoutesBuilder()
                        : const Center(child: Text('Running Trips')));
              },
            ),
          )
        ],
      ),
    );
  }
}
