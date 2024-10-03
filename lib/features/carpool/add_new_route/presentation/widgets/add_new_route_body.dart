import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/car_pool_new_route_info.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/map_and_address_finder_car_pool.dart';

class AddNewRouteBody extends StatelessWidget {
  const AddNewRouteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            MapAndAddressFinderCarPool(),
            // const Sizer(height: 50),
            Visibility(
              visible: true,
              child: CarPoolNewRouteInfo(),
            ),
          ],
        ),
      ),
    );
  }
}
