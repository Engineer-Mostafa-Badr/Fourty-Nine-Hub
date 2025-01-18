import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/basic_info_part_screen.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/car_licence_part_screen.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/driver_licence_part_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class VehicleInfoPartsScreen extends StatelessWidget {
  const VehicleInfoPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.isDarkMode
            ? AppColors.UNSELECTED_DARK_GRAY_COLOR
            : Colors.white,
        boxShadow: context.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 30,
                ),
              ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const BasicInfoPartScreen(),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                ),
                Text(
                  "Brand",
                  style: Styles.mediumText(fontSize: 35),
                ),
              ],
            ),
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DriverLicencePartScreen(),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                ),
                Text(
                  "Registration plate",
                  style: Styles.mediumText(fontSize: 35),
                ),
              ],
            ),
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(
            
          ),
          const Sizer(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CarLicencePartScreen(),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                ),
                Text(
                  "Certificate of vehicle registration",
                  style: Styles.mediumText(fontSize: 35),
                ),
              ],
            ),
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const VehicleInfoPartsScreen(),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                ),
                Text(
                  "Picture",
                  style: Styles.mediumText(fontSize: 35),
                ),
              ],
            ),
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const VehicleInfoPartsScreen(),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                ),
                Text(
                  "National ID card",
                  style: Styles.mediumText(fontSize: 35),
                ),
              ],
            ),
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
        ],
      ),
    ),
    );
  }
}