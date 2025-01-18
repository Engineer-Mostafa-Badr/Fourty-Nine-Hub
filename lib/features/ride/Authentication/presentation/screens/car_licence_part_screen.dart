import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/behind_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_image_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_model_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/front_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/plate_number_register_card_widget.dart';

class CarLicencePartScreen extends StatelessWidget {
  const CarLicencePartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Sizer(
                height: 30,
              ),

              const CarModelRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              const PlateNumberRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              const FrontCarLicenseRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              const BehindCarLicenseRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              ExpirationDateDriverLicenseCardRegisterWidget(
                onTap: (date) {
                  context.read<RegisterRiderCubit>().model.licenseExpiryDate =
                      date.toString();
                },
              ),
              const Sizer(
                height: 30,
              ),
              const CarImageRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),

          ],
        ),
      ),
    );
  }
}
