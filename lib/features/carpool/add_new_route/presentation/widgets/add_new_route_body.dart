import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/car_pool_new_route_info.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/map_and_address_finder_car_pool.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/presentation/cubits/cubit/create_car_pool_cubit.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/presentation/cubits/cubit/create_car_pool_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class AddNewRouteBody extends StatelessWidget {
  const AddNewRouteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCarPoolCubit, CreateCarPoolState>(
      builder: (context, state) {
        if (state is CreateCarPoolSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Carpool created successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          });
        } else if (state is CreateCarPoolFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 2),
              ),
            );
          });
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MapAndAddressFinderCarPool(),
                // const Sizer(height: 50),
                const Visibility(
                  visible: true,
                  child: CarPoolNewRouteInfo(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
