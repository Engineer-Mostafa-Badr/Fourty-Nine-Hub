import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/basic_info_part_screen.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/car_licence_part_screen.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/drag_analysis_part_screen.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/driver_licence_part_screen.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/more_info_part_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_brand_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_colors_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_model_by_brand_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_year_by_model_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/select_car_model_brand_year_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/picture_optional_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RideSocketPartsWidget extends StatelessWidget {
  const RideSocketPartsWidget({super.key, this.model});
  final PartsSocketModel? model;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              builder: (context) => BasicInfoPartScreen(model: model,),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!(model?.basicInfo?.active??false))
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                )
                else
                const Icon(Icons.check, color: Colors.green,),
                Text(
                  "Basic Info",
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
              builder: (context) => DriverLicencePartScreen(),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!(model?.driverLicence?.active??false))
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                )
                else
                const Icon(Icons.check, color: Colors.green,),
                Text(
                  "Driver Licence",
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
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SelectCarModelBrandYearRideCubit(),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetCarBrandRideCubit(repository: serviceLocator())
                          ..get(),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetCarColorsRideCubit(repository: serviceLocator())
                          ..get(),
                  ),
                  BlocProvider(
                    create: (context) => GetCarModelByBrandRideCubit(
                        repository: serviceLocator()),
                  ),
                  BlocProvider(
                    create: (context) => GetCarYearByModelRideCubit(
                        repository: serviceLocator()),
                  ),
                ],
                child: CarLicencePartScreen(),
              ),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!(model?.carLicence?.active??false))
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                )
                else
                const Icon(Icons.check, color: Colors.green,),
                Text(
                  "Car Licence",
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
          // GestureDetector(
          //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const VehicleInfoPartsScreen(),
          //   )),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Icon(
          //         Icons.arrow_back_ios_new,
          //         color: AppColors.PRIMARY_COLOR,
          //       ),
          //       Text(
          //         "Vehicle info",
          //         style: Styles.mediumText(fontSize: 35),
          //       ),
          //     ],
          //   ),
          // ),
          // const Sizer(
          //   height: 10,
          // ),
          // const Divider(),
          const Sizer(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    PictureOptionalCubit(repository: serviceLocator())
                      ..getData(),
                child: DragAnalysisPartScreen(),
              ),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!(model?.dragAnalysisPart?.active??false))
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                )
                else
                const Icon(Icons.check, color: Colors.green,),
                Text(
                  "Drag analysis",
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
          const Sizer(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
      ManageVibration.vibrate();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          serviceLocator<HealthCubit>()..getGovernorates(),
                      child: MoreInfoPartScreen(),
                    ),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!(model?.moreInfo?.active??false))
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.PRIMARY_COLOR,
                )
                else
                const Icon(Icons.check, color: Colors.green,),
                Text(
                  "More info",
                  style: Styles.mediumText(fontSize: 35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}