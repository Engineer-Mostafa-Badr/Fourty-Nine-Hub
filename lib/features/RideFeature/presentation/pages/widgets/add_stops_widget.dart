import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class AddStopsWidget extends StatefulWidget {
  const AddStopsWidget({super.key, required this.rideCubit});
  final RideCubit rideCubit;

  @override
  State<AddStopsWidget> createState() => _AddStopsWidgetState();
}

class _AddStopsWidgetState extends State<AddStopsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.rideCubit,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _customLocationField(
                  isTo: false,
                  color: Colors.green,
                  text: state.currentLocation?.address,
                  onPressed: () async {
                    ManageVibration.vibrate();
                    context.pushNamed(Routes.GoogleMapsSearchAndPick,
                        extra: RideGoogleMapSearchAndPickParams(
                      onPicked: (pickedData) async {
                        serviceLocator<RideCubit>().updateFromLocation(
                          lat: pickedData.latitude,
                          lng: pickedData.longitude,
                          address: pickedData.address,
                        );
                        context.pop();
                      },
                    ));
                  },
                ),
                _customLocationField(
                  isTo: true,
                  color: Colors.blue,
                  text: state.toLocation?.address,
                  onPressed: () async {
                    ManageVibration.vibrate();
                    context.pushNamed(Routes.GoogleMapsSearchAndPick,
                        extra: RideGoogleMapSearchAndPickParams(
                      onPicked: (pickedData) async {
                        serviceLocator<RideCubit>().updateToLocation(
                          lat: pickedData.latitude,
                          lng: pickedData.longitude,
                          address: pickedData.address,
                        );
                        await serviceLocator<RideCubit>()
                            .fetchRideExpectedPrice(id: 'id');
                        context.pop();
                      },
                    ));
                  },
                  onAddPressed: () {
                    setState(() {
                      serviceLocator<RideCubit>().showWaypointOne = true;
                    });
                  },
                  showAddIcon: state.toLocation != null &&
                      !serviceLocator<RideCubit>().showWaypointOne,
                ),
                if (serviceLocator<RideCubit>().showWaypointOne)
                  _customLocationField(
                    isTo: true,
                    color: Colors.blue,
                    text: state.wayPointOne?.address,
                    onPressed: () async {
                      ManageVibration.vibrate();
                      context.pushNamed(Routes.GoogleMapsSearchAndPick,
                          extra: RideGoogleMapSearchAndPickParams(
                        onPicked: (pickedData) async {
                          serviceLocator<RideCubit>().updateWayPointOne(
                            lat: pickedData.latitude,
                            lng: pickedData.longitude,
                            address: pickedData.address,
                          );
                          await serviceLocator<RideCubit>()
                              .fetchRideExpectedPrice(id: 'id');
                          context.pop();
                        },
                      ));
                    },
                    onAddPressed: () {
                      ManageVibration.vibrate();
                      setState(() {
                        serviceLocator<RideCubit>().showWaypointTwo = true;
                      });
                    },
                    showAddIcon: state.wayPointOne != null &&
                        !serviceLocator<RideCubit>().showWaypointTwo,
                  ),
                if (serviceLocator<RideCubit>().showWaypointTwo)
                  _customLocationField(
                    isTo: true,
                    color: Colors.blue,
                    text: state.wayPointTwo?.address,
                    onPressed: () async {
                      ManageVibration.vibrate();
                      context.pushNamed(Routes.GoogleMapsSearchAndPick,
                          extra: RideGoogleMapSearchAndPickParams(
                        onPicked: (pickedData) async {
                          serviceLocator<RideCubit>().updateWayPointTwo(
                            lat: pickedData.latitude,
                            lng: pickedData.longitude,
                            address: pickedData.address,
                          );
                          await serviceLocator<RideCubit>()
                              .fetchRideExpectedPrice(id: 'id');
                          context.pop();
                        },
                      ));
                    },
                  ),
                _locationInfoBox(state.toLocation?.address),
                if (serviceLocator<RideCubit>().showWaypointOne)
                  _locationInfoBox(state.wayPointOne?.address),
                if (serviceLocator<RideCubit>().showWaypointTwo)
                  _locationInfoBox(state.wayPointTwo?.address),
                const SizedBox(height: 10),
                AppButton(
                  label: context.isArabic ? 'تم' : 'Done',
                  onPressed: () {
                    ManageVibration.vibrate();
                    context.pop();
                  },
                  width: MediaQuery.of(context).size.width / 2,
                  backColor: AppColors.PRIMARY_COLOR,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _locationInfoBox(String? address) {
    if (address == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? AppColors.GREY_DARK_COLOR
              : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_sharp, size: 30),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customLocationField({
    required Color color,
    required String? text,
    required bool isTo,
    required Function()? onPressed,
    Function()? onAddPressed,
    bool showAddIcon = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode
                ? AppColors.GREY_DARK_COLOR
                : const Color(0xFFEEEEEE),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 10,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 5,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  text ??
                      (isTo
                          ? (context.isArabic ? "إلى" : "To")
                          : (context.isArabic ? "من" : "From")),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showAddIcon)
                GestureDetector(
                  onTap: onAddPressed,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, size: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
