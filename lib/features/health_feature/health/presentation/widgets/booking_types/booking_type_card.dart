import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class HealthBookingTypeCard extends StatelessWidget {
  final HealthBookingFilterModel bookingFilterModel;
  const HealthBookingTypeCard({super.key, required this.bookingFilterModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        serviceLocator<HealthSharedData>().doctorSearchParams.reset();

        if (context.read<UserCubit>().isLoggedIn) {
          serviceLocator<HealthSharedData>().doctorSearchParams.bookingType =
              bookingFilterModel.bookingType;
          context.push(bookingFilterModel.route);
        } else {
          context.push(Routes.REGISTER);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ]),
        child: Column(
          children: [
            Expanded(child: Image.asset(bookingFilterModel.image)),
            Text(
              bookingFilterModel.bookingType.translatedName,
            ),
          ],
        ),
      ),
    );
  }
}
